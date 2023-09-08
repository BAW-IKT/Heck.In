from firebase_admin import credentials, firestore, initialize_app


class FirebaseClient:
    def __init__(self, credentials_path: str = None, default_collection: str = "hedge_profiles"):
        """
        :param credentials_path: path to json file generated via
            https://console.cloud.google.com/iam-admin/serviceaccounts/
            > select the one thats associated with firestore database > keys > generate json key
        :param default_collection: manually created collection via webinterface
        """
        self.credentials_path = credentials_path
        self.default_collection = default_collection
        self.db = None
        self.received_documents = None
        self.connect()

    def connect(self):
        cred = credentials.Certificate(self.credentials_path)
        initialize_app(cred)
        self.db = firestore.client()

    def show_available_collections(self):
        collections = self.db.collections()
        for collection in collections:
            print(collection.id)

    def fetch_all(self):
        collection_reference = self.db.collection(self.default_collection)
        docs = collection_reference.stream()
        self.received_documents = dict()
        for doc in docs:
            self.received_documents[doc.id] = doc.to_dict()
        print(f"Fetched {len(self.received_documents)} documents from collection: {self.default_collection}")

    def print_all_documents(self):
        for doc_id, doc_data in self.received_documents.items():
            formatted_doc_data = "\n".join([f"\t{_k} | {_v}" for _k, _v in doc_data.items()])
            print(f"{doc_id}\n{formatted_doc_data}")


if __name__ == "__main__":
    client = FirebaseClient(credentials_path="hedge-profiler-service-credentials.json")
    client.fetch_all()
    client.print_all_documents()
