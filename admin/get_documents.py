from datetime import datetime
import json
import os
import uuid
from dotenv import load_dotenv
from pymongo import MongoClient


env_abs_path = os.path.abspath("../data/.env")
if not load_dotenv("../data/.env"):
    exit(f"Could not find .env file at {env_abs_path} - make sure it exists by copying example.env and "
         f"populating it with the proper values.")

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_APP_NAME = os.getenv("DB_APP_NAME")
DB_URI = f"mongodb+srv://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}?retryWrites=true&w=majority&appName={DB_APP_NAME}"


def fetch_documents():
    client = MongoClient(DB_URI)
    db = client[DB_NAME]
    collection = db.get_collection("hedges")

    for document_index, document in enumerate(collection.find()):
        _id = document.get("_id", f"{uuid.uuid4()}")
        form_data = document.get("form_data", {})
        graph_data_full = document.get("graph_data_full", {})
        graph_data_reduced = document.get("graph_data_reduced", {})
        images = document.get("images", [])
        timestamp = document.get("timestamp", datetime.now())

        timestamp_formatted = timestamp.strftime("%Y-%m-%d_%H-%M-%S")
        base_file_name = f"{timestamp_formatted}_{_id}"

        # write dictionary data, 3 .json files per submission
        for data, description in zip([form_data, graph_data_full, graph_data_reduced],
                                     ["form_data", "graph_data_full", "graph_data_reduced"]):
            json_abs_path = os.path.abspath(f"{base_file_name}_{description}.json")
            with open(file=json_abs_path, mode="w", encoding="utf-8") as f_out:
                json.dump(data, f_out)
                print(f"Created: {json_abs_path}")

        # write images
        for image_index, image in enumerate(images):
            image_abs_path = os.path.abspath(f"{base_file_name}_image_{image_index+1}.jpg")
            with open(file=image_abs_path, mode="wb") as img_out:
                img_out.write(bytes(image))
                print(f"Created: {image_abs_path}")

        print(f"Processed {document_index+1} documents")


if __name__ == "__main__":
    fetch_documents()
