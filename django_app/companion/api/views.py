import csv
from datetime import datetime, timedelta
import random
from certifi import where
from django.http import JsonResponse, QueryDict
from django.views.decorators.csrf import csrf_exempt
from firebase_admin import firestore, auth
import firebase_admin

from .functions import apply_filter, create_plan, sel_exercises
from .models import Exercise, Statistic, User, testOtherStatistic, testStatistic, workoutExercises, workouts
import pyrebase
import json, os
from dotenv import load_dotenv
from google.cloud.firestore_v1.base_query import FieldFilter
from django.core.files.storage import default_storage
from companion.preprocessing import preprocess_single_video
import joblib
import numpy as np

load_dotenv()

config = {
    'apiKey': os.getenv('API_KEY'),
    'authDomain': os.getenv('AUTH_DOMAIN'),
    'databaseURL': os.getenv('DATABASE_URL'),
    'projectId': os.getenv('PROJECT_ID'),
    'storageBucket': os.getenv('STORAGE_BUCKET'),
    'ServiceAccount': os.getenv('CREDENTIALS'),
}

firebase = pyrebase.initialize_app(config)
pyauth = firebase.auth()
db = firestore.client()
storage=firebase.storage()

@csrf_exempt
def login_user(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        email = data.get('email')
        password = data.get('password')
        user = pyauth.sign_in_with_email_and_password(email, password)
        print(user)

        if user.get('registered') is True:
            return JsonResponse({'message':'Login successful!', 'token':user['localId'], 'status':'success'}, status=200)
        else:
            return JsonResponse({'message':'Invalid request method', 'status':'error'}, status=405)

@csrf_exempt
def logout_user(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        token = data.get('token')
        pyauth.revoke_refresh_tokens(token)
        return JsonResponse({'message':'Logout successful!', 'status':'success'}, status=200)

@csrf_exempt
def create_user(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        email = data.get('email')
        password = data.get('password')
        password_conf = data.get('password_conf')
        username = data.get('username')
        name = data.get('name')
        age = data.get('age')
        height = data.get('height')
        weight = data.get('weight')
        bodytype = data.get('bodyType')
        experience = data.get('experience')
        goal = data.get('goal')
        frequency = data.get('frequency')
        painPoints = data.get('painPoints')

        print(data)

        user_obj = User(name, username, age, email, height, weight, bodytype, experience, goal, frequency, painPoints, squat_score={}, deadlift_score={}, bench_score={}, first_login=True)

        if password == password_conf:
            try:
                user = pyauth.create_user_with_email_and_password(email, password)
                pyauth.send_email_verification(user['idToken'])
                user_obj.save(user['localId'])
                return JsonResponse({'message':'User successfully created', 'status':'success'}, status=200)
            except Exception as e:
                print(e)
                return JsonResponse({'message':'Something went wrong. User was not created!', 'status':'error'}, status=400)
        else:
            return JsonResponse({'message':'Passwords didn\'t match', 'status':'error'}, status=401)

@csrf_exempt
def upload_image(request):
    if request.method == "POST":
        try:
            # Get the user ID from the request associate
            username = request.POST['username']

            image = request.FILES['image']

            storage.child(f'profiles/{username}/profilepicture').put(image)
            return JsonResponse({'status': 'Image upload successful'}, status= 200)
        except Exception as e:
            print(e)
            return JsonResponse({'error': 'Image upload failed'}, status= 400)

@csrf_exempt
def fetch_userprofile(request):
    if request.method == "GET":
        try:
            token = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            db = firestore.client()
            doc_ref = db.collection('users').document(token)

            user_profile = doc_ref.get()

            if user_profile.exists:
                user_profile_dict = user_profile.to_dict()

                url = storage.child(f'profiles/{user_profile_dict["username"]}/profilepicture').get_url(token)

                user_profile_dict['profile_picture'] = url
                return JsonResponse({'user_profile': user_profile_dict}, status=200)
            else:
                return JsonResponse({'error': 'User not found'}, status=400)

        except ValueError as e:
            print(f'ValueError: {e}')
            return JsonResponse({'error': 'Token is not a string or is empty'}, status=400)
        except auth.InvalidIdTokenError as e:
            print(f'InvalidIdTokenError: {e}')
            return JsonResponse({'error': 'Token is invalid'}, status=400)
        except Exception as e:
            print(f'Exception: {e}')
            return JsonResponse({'error': str(e)}, status=400)

@csrf_exempt
def update_field(request):
    if request.method == "PATCH":
        try:
            token = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]
            data = json.loads(request.body)
            username = data.get('username')
            field = data.get('field')
            value = data.get('value')

            db = firestore.client()
            doc_ref = db.collection('users').document(token)

            # THIS WILL ALSO WORK IF A FIELD DOESNT EXIST YET, IT WILL SIMPLY CREATE IT
            doc_ref.update({field: value})

            return JsonResponse({'message': 'Field updated successfully'}, status=200)
        except Exception as e:
            print(f'Exception occured: {e}')#
            return JsonResponse({'error': 'Failed to update Field'}, status=400)

@csrf_exempt
def track_statistic(request):
    if request.method == "POST":

        try:
            data = json.loads(request.body)

            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]
            exerciseName = data.get('exerciseID')
            weight = data.get('weight')
            reps = data.get('reps')
            set = data.get('set')

            db = firestore.client()

            # Fall abfangen, dass irgendein Wert = 0 ist (auch wenn das keinen Fehler erzeugt)

            statistics = Statistic(userID, exerciseName, weight, reps, set)
            _, doc_ref = db.collection('statistics').add(statistics.__dict__)

            return JsonResponse({
                'exercises':"Perfekt"
            }, status=200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to save track_stat in db'}, status=500)

@csrf_exempt
def create_csv(request):
    if request.method == "GET":

        try:
            user_id = "ZSshfWfo5sVA8Y7KDElh8icuRwk2"
            exercise_id = "benchpress"
            start_date = datetime.now() - timedelta(weeks=4)

            num_days = 28
            num_entries_per_day = 2


            headers = ["userID", "exerciseID", "weight", "reps", "sets", "date"]

            mock_data = []

            for i in range(num_days):
                current_date = start_date + timedelta(days=i)
                for _ in range(num_entries_per_day):
                    weight = random.randint(50, 150)
                    reps = random.randint(5, 10)
                    sets = random.randint(3, 5)

                    mock_data.append({
                        "userID": user_id,
                        "exerciseID": exercise_id,
                        "weight": weight,
                        "reps": reps,
                        "sets": sets,
                        "date": current_date.strftime('%Y-%m-%d')
                    })

            csv_file_name = 'D:\\mock_statistics.csv'
            with open(csv_file_name, mode='w', newline='', encoding='utf-8') as file:
                writer = csv.DictWriter(file, fieldnames=headers)
                writer.writeheader()
                for data in mock_data:
                    writer.writerow(data)
                    print(data)

            print(f"CSV-Datei erstellt: {csv_file_name}")

            return JsonResponse({
                'exercises':"Perfekt"
            }, status=200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to save track_stat in db'}, status=500)

@csrf_exempt
def track_maxlast(request):
     if request.method == "POST":

        try:
            data = json.loads(request.body)

            newWeight = data.get('newWeight')
            lastWeight = data.get('newWeight')
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]
            exerciseName = data.get('exerciseID')

            db = firestore.client()

            query = db.collection('otherStatistic').where(filter=FieldFilter('userID', '==', userID)).where(filter=FieldFilter('exerciseID', '==', exerciseName))

            documents = query.stream()
            doc = next(documents, None)

            if doc:
                doc_ref = doc.reference
                temp_data = doc.to_dict()

                doc_ref.update({'lastUsedWeight': newWeight})

                newWeightMax = int(newWeight)
                maxWeight = int(temp_data['maxWeight'])

                if maxWeight < newWeightMax:
                    doc_ref.update({'maxWeight': newWeight})

            else:
                otherStatistic = testOtherStatistic(userID, exerciseName, newWeight, lastWeight)
                _, doc_ref = db.collection('otherStatistic').add(otherStatistic.__dict__)

            return JsonResponse({
                'exercises':"Perfekt"
            }, status=200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to fetch exercises'}, status=500)

@csrf_exempt
def get_stats(request):
    if request.method == "GET":

        try:
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            query = db.collection('otherStatistic')\
                .where(filter=FieldFilter('userID', '==', userID))

            exercise_data = []

            documents = query.stream()

            documents_list = list(documents)

            if not documents_list:
                return JsonResponse({'statList': [], 'weightlist': []}, status = 200)
   
            for docs in documents_list:
                weightlist = []
                sumWeights = 0
                counter = 0
                lastWeightUsed = 0
                median = 0
                tendenz = ""

                temp_data = docs.to_dict()

                querytwo = db.collection('statistics')\
                    .where(filter=FieldFilter('userID', '==', userID))\
                    .where(filter=FieldFilter('exerciseID', '==', temp_data['exerciseID']))\
                    .order_by('created_at', direction=firestore.Query.DESCENDING)

                documentstwo = querytwo.stream()

                lastWeightUsed = 0
                if temp_data['lastUsedWeight'].isdigit():
                    lastWeightUsed = int(temp_data['lastUsedWeight'])
                
                for docsOne in documentstwo:
                    temp_two = docsOne.to_dict()

                    weight = temp_two.get('weight', '0')
                    if weight.isdigit():
                        sumWeights += int(weight)
                        counter += 1

                obereGrenze = lastWeightUsed*1.05
                untereGrenze = lastWeightUsed*0.99

                median = sumWeights/counter
                if untereGrenze<median and median<obereGrenze:
                    tendenz = "You're stagnating"
                elif median<untereGrenze:
                    tendenz = "You're getting stronger"
                elif median>obereGrenze:
                    tendenz = "You're getting weaker"
                    
                count = 0

                docthree = querytwo.stream()
                for doc in docthree:
                    if count < 7:
                        temp_datatwo = doc.to_dict()
                        if not temp_datatwo['weight']:
                            weightlist.append('0')

                        else:
                            weightlist.append(temp_datatwo['weight'])
                        count += 1
                    else:
                        break
                while len(weightlist) < 7:
                    weightlist.append('0')

                exercise_data.append({
                    'exerciseID':temp_data['exerciseID'],
                    'maxWeight':temp_data['maxWeight'],
                    'lastUsedWeight':temp_data['lastUsedWeight'],
                    'weightList': weightlist,
                    'tendency': tendenz
                })

            return JsonResponse({
                'statList': exercise_data,
                'weightlist': weightlist
            }, status = 200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to get maxWeight'}, status=500)

@csrf_exempt
def make_plans(request):
    if request.method == "GET":

        try:
            db = firestore.client()

            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]
            user_ref = db.collection('users').document(userID)
            user_profile_dict = user_ref.get().to_dict()

            age = user_profile_dict['age']
            experience = user_profile_dict['experience']
            frequency = str(user_profile_dict['frequency'])
            pain = user_profile_dict['painPoins']

            query = db.collection('testingstatistics')      
            query = apply_filter(query, age, experience, pain)

            documents1 = query.stream()

            exercises = [exercise.to_dict() for exercise in documents1]

            trainings_plan = create_plan(exercises, frequency, experience)

            #Hier befindet sich der Trainingsplanname
            workout_name = trainings_plan[0] 

            #Wenn es mehrere Tage mit dem gleichen Plan gibt,
            #wird hier jeder Tag nur einmal aufgeführt
            workout_only = trainings_plan[1]
            	
            for index, var in enumerate(workout_only):
                day_name = var
                for exercise in trainings_plan[index+2].values():
                    if len(exercise) > 1:
                        for single_exercises in exercise:
                            workout_exercise = workoutExercises(single_exercises, userID, day_name)
                            _, doc_ref = db.collection('workoutExercises').add(workout_exercise.__dict__)
                    else:
                        workout_exercise = workoutExercises(exercise[0], userID, day_name)
                        _, doc_ref = db.collection('workoutExercises').add(workout_exercise.__dict__)

            query = db.collection('workouts').where(filter=FieldFilter('userID', '==', userID))

            documents = query.stream()
            doc = next(documents, None)

            if doc:
                doc_ref = doc.reference

                doc_ref.update({'workoutName': workout_name})

            else:
                workout_plan = workouts(workout_name, userID)
                _, doc_ref = db.collection('workouts').add(workout_plan.__dict__)

            return JsonResponse({
                'exercises':"Perfekt"
            }, status=200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to save track_stat in db'}, status=500)

@csrf_exempt
def update_profile(request):
    if request.method == "PATCH":
        try:
            token = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]
            data = json.loads(request.body)
            #username = data.get('username')
            print(request.user)

            db = firestore.client()
            doc_ref = db.collection('users').document(token)

            doc_ref.update(data)

            return JsonResponse({'message': 'Userprofile updated successfully'}, status=200)
        except ValueError as e:
            print(f'ValueError: {e}')
            return JsonResponse({'error': 'Token is not a string or is empty'}, status=400)
        except auth.InvalidIdTokenError as e:
            print(f'InvalidIdTokenError: {e}')
            return JsonResponse({'error': 'Token is invalid'}, status=400)
        except Exception as e:
            print(f'Exception: {e}')
            return JsonResponse({'error': str(e)}, status=400)

@csrf_exempt
def add_exercise_todb(request):
    if request.method == "POST":

        try:
            db = firestore.client()

            csv_file_path = 'D:\\exercise_attributes.csv'

            collection_ref = db.collection('testingstatistics')

            with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
                reader = csv.DictReader(csvfile)
                for row in reader:
                    exercise_name = row['Exercise']
                    collection_ref.document(exercise_name).set(row)

            return JsonResponse({'exercises':"Perfekt"}, status=200)

        except Exception as e:
            print(f'Exception occurred: {e}')
            return JsonResponse({'error': 'Failed to save track_stat in db'}, status=500)

@csrf_exempt
def get_todays_sets(request, exerciseName):
    if request.method == 'GET':
        try:
            setsList = []
            today = datetime.now()
            start_today = datetime(today.year, today.month, today.day)
            end_today = start_today + timedelta(days=1)

            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            query = db.collection('otherStatistic')\
                .where(filter=FieldFilter('userID', '==', userID))
            
            documents = query.stream()
            # 1. Schleife

            querytwo = db.collection('statistics')\
            .where(filter=FieldFilter('userID', '==', userID))\
            .where(filter=FieldFilter('exerciseID', '==', exerciseName))\
            .where(filter=FieldFilter('created_at', '>=', start_today))\
            .where(filter=FieldFilter('created_at', '<', end_today))\
            .order_by('created_at', direction=firestore.Query.ASCENDING)
                
            documentstwo = querytwo.stream()
                # 2. Schleife
            for doctwo in documentstwo:
                temp_doctwo = doctwo.to_dict()
                setsList.append({'weight':temp_doctwo['weight'],
                                    'sets':temp_doctwo['sets'],
                                    'reps': temp_doctwo['reps']})
                
            for var in setsList:
                print(var)
                    
                
            return JsonResponse({
                'setsList': setsList
            }, status=200)
        
        except Exception as e:
            print(f'Exception occured: {e}')
            return JsonResponse({'error': 'Failed to getTdSets from db'}, status=500)

@csrf_exempt
def profile_statistic(request):
    if request.method == 'GET':

        try:
            #wie oft hat der Nutzer bisher schon Trainiert?
            daysTraining = 0
            #wieviel Gewicht hat der Nutzer im Monat bisher bewegt?
            movedWeight = 0

            today = datetime.now()

            db = firestore.client()

            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            query = db.collection('statistics')\
            .where(filter=FieldFilter('userID', '==', userID))

            documents = query.stream()

            unique_dates = set()

            for doc in documents: 
                temp_data = doc.to_dict()
                date = temp_data['created_at'].date()
                unique_dates.add(date)

                reps = temp_data.get('reps')
                weight = temp_data.get('weight')

                if reps.isdigit():
                    reps = int(reps)
                else: 
                    reps = 0
                
                if weight.isdigit():
                    weight = int(weight)
                else: 
                    weight = 0
                movedWeight += reps*weight
                
            trainings_days_per_month = {}

            for i in range(7):
                year, month = today.year, today.month - i 
                if month <= 0:
                    month += 12
                    year -= 1

                first_day_of_month = datetime(year, month, 1)
                last_day_of_month = datetime(year, month + 1, 1) if month < 12 else datetime(year + 1, 1, 1)
                last_day_of_month -= timedelta(seconds=1)
                trainings_days_per_month[first_day_of_month.strftime("%B %Y")] = 0

                querytwo = db.collection('statistics')\
                .where(filter=FieldFilter('userID', '==', userID))\
                .where(filter=FieldFilter('created_at', '>=', first_day_of_month))\
                .where(filter=FieldFilter('created_at', '<=', last_day_of_month))

                documentstwo = querytwo.stream()

                unique_datestwo = set()

                for doctwo in documentstwo:
                    temp_datatwo = doctwo.to_dict()
                    date = temp_datatwo['created_at'].date()
                    unique_datestwo.add(date)
                
                trainings_days_per_month[first_day_of_month.strftime("%B %Y")] = len(unique_datestwo)

            daysTraining = len(unique_dates)

            today = datetime.now().date()
            yesterday = today - timedelta(days=1)
            checkDate = None

            dates_sorted = sorted(unique_dates, reverse=True)

            # Prüfe, ob der Nutzer heute oder gestern aktiv war
            if dates_sorted[0] == today:
                checkDate = today
            elif dates_sorted[0] == yesterday:
                checkDate = yesterday

            # Berechnung der Loggingstreak
            loggingStreak = 0

            if checkDate is not None:
                for date in dates_sorted:
                    if date == checkDate:
                        loggingStreak += 1
                        checkDate -= timedelta(days=1)
                    else:
                        break
            else:
                loggingStreak = 0


            return JsonResponse({
                'movedWeight': movedWeight,
                'daysTrainedMonth': trainings_days_per_month,
                'daysTraining': daysTraining,
                'loggingStreak': loggingStreak
            }, status=200)
        
        except Exception as e:
            print(f'Exception occured: {e}')
            return JsonResponse({'error': 'Failed to get profileStatistics from db'}, status=500)
        
@csrf_exempt
def upload_video(request):
    if request.method == "POST":
        try:
            # get video file from request
            video_file = request.FILES['video']
            exercise_name = request.POST['exercise_name']

            # save the video file temporarily
            file_name = default_storage.save(video_file.name, video_file)

            # get video file path
            file_path = default_storage.path(file_name)
            
            preprocessed_df = preprocess_single_video(file_path, exercise_name)
        
            model = joblib.load(r"C:\\FLUT\\training-companion\django_app\\companion\\api\squat_model.pkl")
            prediction = model.predict(preprocessed_df)

            mean_descent_score = np.mean(prediction[:, 0])
            mean_ascent_score = np.mean(prediction[:, 1])
            mean_depth_score = np.mean(prediction[:, 2])

            score_dict = {
                'mean_descent_score': mean_descent_score.item(),
                'mean_ascent_score': mean_ascent_score.item(),
                'mean_depth_score': mean_depth_score.item()
            }

            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            doc_ref = db.collection('scoring_history').document(userID)

            doc = doc_ref.get()

            if doc.exists:
                doc_ref.update({'squat_scores': score_dict})
            else:
                # If the document does not exist, create it
                doc_ref.set({'userID': userID, 'scores': [score_dict]})

            return JsonResponse({'status': 'Video upload successful', 'content': score_dict}, status= 200)
        except Exception as e:
            print(e)
            return JsonResponse({'error': 'Video upload failed'}, status= 400)


@csrf_exempt
def fetch_scoring_history(request):
    if request.method == "GET":
        try:
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            doc_ref = db.collection('scoring_history').document(userID)
            
            doc = doc_ref.get()
            if doc.exists:
                query = db.collection('scoring_history')\
                    .where('userID', '==', userID)
                docs = query.stream()
                scoring_history = [doc.to_dict() for doc in docs]
                print(scoring_history)
            else:
                scoring_history = {'userID': userID, 'squat_scores': {}, 'deadlift_scores': {}, 'benchpress_scores': {}}
                doc_ref.set(scoring_history)

            return JsonResponse({'status': 'Successfully fetched Scoring History!','scoring_history': scoring_history}, status=200)
        except Exception as e:
            print(e)
            return JsonResponse({'error': 'Failed to fetch Scoring History'}, status= 400)
        
@csrf_exempt
def get_all_exercises(request, exerciseName=None):
    if request.method == "GET":
        try:
            db = firestore.client()

            if not exerciseName:
                exercise_ref = db.collection('testingstatistics')\
                .order_by('Exercise')
            else:
                exercise_ref = db.collection('testingstatistics')\
                .where(filter=FieldFilter("Muscle", "==", exerciseName))\
                .order_by('Exercise')

            exercises_ref = exercise_ref.stream()

            exercises = [doc.to_dict() for doc in exercises_ref]
            exercise_names = []

            count = 0
            for var in exercises:
                exercise_names.append(var['Exercise'])
                count += 1

            return JsonResponse({'exercise_list': exercise_names}, status = 200)
        except Exception as e:
            print(e)
            return JsonResponse({}, status = 500)
        
@csrf_exempt
def get_plans(request):
    if request.method == "GET":
        try:
            workout_names = []
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            query = db.collection("workouts")\
                .where(filter=FieldFilter('userID', '==', userID))
            
            documents = query.stream()
            documents_list = list(documents)

            if not documents_list:
                return JsonResponse({'workout_name': []}, status = 200)
            
            
            for var in documents_list:
                temp_data = var.to_dict()["workoutName"]
                workout_names = temp_data

            return JsonResponse(
                {"workout_name": workout_names}, status = 200)
        except Exception as e:
            print(e)
            return JsonResponse({}, status = 500)
        
@csrf_exempt
def get_plans_exercises(request, planName):
    if request.method == "GET":
        try:
            exerciseList = []
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            query = db.collection("workoutExercises")\
                .where(filter=FieldFilter('userID', '==', userID))\
                .where(filter=FieldFilter('day', '==', planName))
            
            documents = query.stream()

            for var in documents:
                var = var.to_dict()
                exerciseList.append(str(var['exerciseID']))

            return JsonResponse(
                {'exercise_list': exerciseList}, status = 200)
        except Exception as e:
            print(e)
            return JsonResponse({}, status = 500)
        
@csrf_exempt
def check_first_login(request):
    if request.method == "GET":
        try:
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            user_doc = db.collection("users").document(userID).get()

            if user_doc.exists:
                user_data = user_doc.to_dict()
                first_login_check = user_data.get('first_login', False)

            return JsonResponse(
                {'check_first_login': first_login_check}, status = 200)
        except Exception as e:
            print(e)
            return JsonResponse({}, status = 500)
        
@csrf_exempt
def update_first_login(request):
    if request.method == "POST":
        try:
            db = firestore.client()
            userID = request.META.get('HTTP_AUTHORIZATION').split(' ')[1]

            user_doc = db.collection("users").document(userID)

            user_doc.update({'first_login': False})


            return JsonResponse(
                {'message': "First login updated"}, status = 200)
        except Exception as e:
            print(e)
            return JsonResponse({}, status = 500)
        
