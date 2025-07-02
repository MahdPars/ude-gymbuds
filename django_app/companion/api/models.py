import datetime
from django.db import models
from .firestore_models import FirestoreModel

class User(FirestoreModel):
    collection_name = 'users'

    def __init__(self, name, username, age, email, height, weight, bodyType, experience, goal, frequency, painPoints, squat_score, deadlift_score, bench_score, first_login):
        self.name = name
        self.username = username
        self.age = age
        self.email = email
        self.height = height
        self.weight = weight
        self.bodyType = bodyType
        self.experience = experience
        self.goal = goal
        self.frequency = frequency
        self.painPoins = painPoints
        self.squat_score = squat_score
        self.deadlift_score = deadlift_score
        self.bench_score = bench_score
        self.first_login = first_login

class Exercise(FirestoreModel):
    collection_name = 'exercise'       

    def __init__(self, exerciseName, muscle, day):
         self.exerciseName = exerciseName
         self.muscle = muscle
         self.day = day

class Statistic(FirestoreModel):
    collection_name = "statistics"

    def __init__(self, userID, exerciseID, weight, reps, sets):
         self.userID = userID
         self.exerciseID = exerciseID
         self.weight = weight
         self.reps = reps
         self.sets = sets
         self.created_at = datetime.datetime.now()

class testingStatistic(FirestoreModel):
    collection_name = "testingstatistics"

    def __init__(self, Exercise, Experience_Level, Intensity, Pain, Muscle):
         self.Exercise = Exercise
         self.Experience_Level = Experience_Level
         self.Intensity = Intensity
         self.Pain = Pain
         self.Muscle = Muscle

class testStatistic(FirestoreModel):
    collection_name = "teststatistic"

    def __init__(self, set, weight, rep, exerciseName):
        self.set = set
        self.weight = weight
        self.rep = rep
        self.exerciseName = exerciseName

class testOtherStatistic(FirestoreModel):
    collection_name = "otherStatistic"

    def __init__(self, userID, exerciseID, maxWeight, lastUsedWeight):
        self.userID = userID
        self.exerciseID = exerciseID
        self.maxWeight = maxWeight
        self.lastUsedWeight = lastUsedWeight
        self.created_at = datetime.datetime.now()

class tendencytest(FirestoreModel):
    collection_name = "tendencytests"

    def __init__(self, userID, exerciseID, weight, reps, sets, date):
        self.userID = userID
        self.exerciseID = exerciseID
        self.weight = weight
        self.reps = reps
        self.sets = sets
        self.date = date

class scoring_history(FirestoreModel):
    collection_name = "scoring_history"

    def __init__(self, userID, squat_score, deadlift_score, bench_score):
        self.userID = userID
        self.squat_score = squat_score
        self.deadlift_score = deadlift_score
        self.bench_score = bench_score
        self.created_at = datetime.datetime.now()

#Für jeden User wird ein Eintrag erstellt mit der der userID und dem Namen des Plans (also z.B.
# Push Pull Legs etc.)
class workouts(FirestoreModel):
    collection_name = "workouts"

    def __init__(self, workoutName, userID):
        self.workoutName = workoutName
        self.userID = userID

# Hier wird dann für jede Übung die man dem Nutzer im Plan zugewiesen hat, ein neuer Eintrag erstellt.
# exerciseID steht dabei für die Übung, order für die Reihenfolge an dem Tag (also z.B. zuerst Benchpress etc.)
# day steht hierbei für den Tag aus dem Trainingsplan, also z.B. Push etc.
class workoutExercises(FirestoreModel):
    collection_name = "workoutExercises"

    def __init__(self, exerciseID, userID, day ):
        self.exerciseID = exerciseID
        self.userID = userID
        self.day = day

# Create your models here.
