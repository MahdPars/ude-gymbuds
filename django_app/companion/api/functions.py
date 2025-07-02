import random
from google.cloud.firestore_v1.base_query import FieldFilter


def split_multi_del(string, trenn):
    for trenner in trenn:
        string = string.replace(trenner, trenn[0])
    return string.split(trenn[0])

def sel_exercises(exercises, training_type):
    selected_exercises = {}
    exercises_per_group = {
        "Push": {"Chest": 3, "Delts": 2, "Triceps": 1},
        "PushL": {"Chest": 3, "Delts": 2, "Triceps": 1, "Quads": 1},
        "Pull": {"Back": 3, "Biceps": 2, "Traps": 1},
        "PullL": {"Back": 3, "Biceps": 2, "Traps": 1, "Glutes":1, "Calves": 1},
        "GK": {"Chest": 1, "Lats": 1, "Quadriceps": 1, "Glutes": 1, "Delts": 1, "Biceps": 1, "Triceps": 1, "Abs": 1},
        "BR": {"Chest": 3, "Back": 3},
        "AS": {"Delts": 3, "Triceps": 2, "Biceps": 2},
        "OK": {"Chest": 2, "Back": 2, "Delts": 1, "Triceps": 1, "Biceps": 1},
        "UK": {"Quadriceps": 2, "Glutes": 2, "Calves": 1, "Abs": 1},
        "Chest": {"Chest": 3},
        "Shoulders": {"Delts": 3},
        "Back": {"Back": 4},
        "Legs": {"Quadriceps": 2, "Glutes": 2, "Calves": 1},
        "Arms": {"Biceps": 2, "Triceps": 2}
    }
    muscle_groups = exercises_per_group.get(training_type, {})
    for muscle_group, num_exer in muscle_groups.items():
        filtered_exercises = [exercise for exercise in exercises if muscle_group in split_multi_del(exercise['Muscle'], ['/', ' '])]
        if filtered_exercises:
            # num_exer = exercises_per_group.get(training_type, {}).get(muscle_group, 1)
            num_to_select = min(len(filtered_exercises), num_exer)
            selected_exercise = random.sample(filtered_exercises, num_to_select)
            selected_exercises[muscle_group] = [exercise['Exercise'] for exercise in selected_exercise]
    return selected_exercises

def apply_filter(query, age, experience, pain):
    count = sum(pain)
    #Filter nach Alter
    if age > 50:
        query = query.where(filter=FieldFilter('Intensity', '==', 'Low'))
    else:
        query = query

    #Filter nach Erfahrung
    if experience == 0:
        query = query.where(filter=FieldFilter('Experience_Level', '==', '0'))
    elif experience == 1:
        query = query.where(filter=FieldFilter('Experience_Level', '!=', '2'))
    else:
        query = query

    if count == 1:
        #Keine Schmerzen
        if pain[3]:
            query = query
        #Nur Schmerzen in der Schulter
        elif pain[0]:
            query = query\
                .where(filter=FieldFilter('Pain', '!=', 'Shoulders'))
        #Nur Schmerzen im Knie
        elif pain[1]:
            query = query\
                .where(filter=FieldFilter('Pain', '!=', 'Knees'))
        #Nur Schmerzen im unteren Rücken
        elif pain[2]:
            query = query\
                .where(filter=FieldFilter('Pain', '!=', 'Lower Back'))

    elif count == 2:
        #Schmerzen in den Schultern und im Knie
        if pain[0] and pain[1]:
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'Lower Back'))
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'None'))
        #Schmerzen in den Schultern und im unteren Rücken  
        elif pain[0] and pain[2]:
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'Knee'))
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'None'))
                #Schmerzen im Knie und im unteren Rücken
        elif pain[1] and pain[2]:
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'Schulter'))
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'None'))

    elif count == 3:
        #Überall Schmerzen (ich)
        if pain[0] and pain[1] and pain[2]:
            query = query\
                .where(filter=FieldFilter('Pain', '==', 'None'))
    
    return query

def create_plan(exercises, frequency, experience):
    experience = str(experience)
    plan = []
    match frequency:
                #Ganzkörper Training
                case '2':
                    plan.append(["GK", "GK"])
                    plan.append(["GK"])
                    gk_plan = sel_exercises(exercises, "GK")
                    plan.append(gk_plan)

                #PPL, Ganzkörpertraining, oder Arnoldsplit
                case '3':        
                    match experience:
                        case '0':
                            plan.append(["GK", "GK", "GK"])
                            plan.append(["GK"])
                            plan.append(sel_exercises(exercises, "GK"))

                        case '1':
                            types = ["Push", "Pull", "Legs"]
                            plan.append(types)
                            plan.append(types)
                            for type in types:
                                plan.append(sel_exercises(exercises, type))

                        case '2':
                            types = ["BR", "Legs", "AS"]
                            plan.append(types)
                            plan.append(types)
                            for type in types:
                                plan.append(sel_exercises(exercises, type))

                #OK UK oder Push Pull (Legs dann aufgeteilt)
                case '4':
                    match experience:
                        case '0':
                            types = ["OK", "UK", "OK", "UK"]
                            plan.append(types)
                            plan.append(["OK", "UK"])
                            plan.append(sel_exercises(exercises, "OK"))
                            plan.append(sel_exercises(exercises, "UK"))

                        case '1' | '2':
                            types = ["PushL", "PullL", "PushL", "PullL"]
                            plan.append(types)
                            plan.append(["PushL", "PullL"])
                            plan.append(sel_exercises(exercises, "PushL"))
                            plan.append(sel_exercises(exercises, "PullL"))

                #PPL und Arnold, Bro-Split oder PPL und 2x GK
                case '5':
                    match experience:
                        case '0':
                            types = ["GK", "Push", "Pull", "Legs", "GK"]
                            plan.append(types)
                            types_only = ["GK", "Push", "Pull", "Legs"]
                            plan.append(types_only)
                            for type in types_only:
                               plan.append(sel_exercises(exercises, type))
        
                        case '1':
                            types = ["BR", "AS", "Legs", "Push", "Pull"]
                            plan.append(types)
                            plan.append(types)
                            for type in types: 
                                plan.append(sel_exercises(exercises, type))

                        case '2':
                            types = ["Chest", "Back", "Shoulders", "Arms", "Legs"]
                            plan.append(types)
                            plan.append(types)
                            for type in types:
                                plan.append(sel_exercises(exercises, type))
    return plan