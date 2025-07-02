from django.core.management.base import BaseCommand
import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore

class Command(BaseCommand):
    help = 'Import kaggle data to firestore'

    def handle(self, *args, **options):
        #read dataset
        df = pd.read_csv(r'/Users/tomhucke/Downloads/megaGymDataset.csv')

        #firestore connection
        try:
            firebase_app = firebase_admin.get_app()
        except ValueError as e:
            cred = credentials.Certificate('/Users/tomhucke/TrainingCompanion/training-companion/django_app/companion/secret/trainingcompanion-58742-firebase-adminsdk-g421v-edaed6381b.json')
            firebase_admin.initialize_app(cred)

        db = firestore.client()

        #push data to firestore
        for index, row in df.iterrows():
            doc_ref = db.collection(u'exercises').document(str(index))
            doc_ref.set(row.to_dict())

        self.stdout.write(self.style.SUCCESS('Successfully imported data to firestore'))