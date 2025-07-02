from firebase_admin import firestore

db = firestore.client()

class FirestoreModel:
    collection_name = ""

    def save(self, uid):
        if not self.collection_name:
            raise ValueError("Collection name is not set")

        collection_ref = db.collection(self.collection_name)
        if hasattr(self, 'id') and self.id:
            doc_ref = collection_ref.document(self.id)
            doc_ref.set(self.__dict__)
        else:
            doc_ref = collection_ref.document(uid)
            doc_ref.set(self.__dict__)  # Set the id attribute to the ID of the new document
  
    @classmethod
    def saveID(self):
        if not self.collection_name: 
            raise ValueError("Collection name is not set")
        
        collection_ref = db.collection(self.collection_name)

        if hasattr(self, 'id') and self.id: 
            doc_ref = collection_ref.document(self.id)
            doc_ref.set(self.__dict__)
        else: 
            doc_ref = collection_ref.document()
            self.id = doc_ref.id
            doc_ref.set(self.__dict__)


    @classmethod
    def all(cls):
        if not cls.collection_name:
            raise ValueError("Collection name is not set.")
        
        collection_ref = db.collection(cls.collection_name)
        return collection_ref.stream()
    
    @classmethod
    def get_by_id(cls, id):
        if not cls.collection_name:
            raise ValueError("Collection name is not set.")
        
        doc_ref = db.collection(cls.collection_name).document(id)
        doc = doc_ref.get()
        if doc.exists:
            return doc.to_dict()
        else:
            return None