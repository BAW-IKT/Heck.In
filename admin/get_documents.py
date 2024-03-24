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
    base_folder = os.path.abspath("hedges")

    if not os.path.exists(base_folder):
        os.mkdir(base_folder)
        print(f"Created folder: {base_folder}")

    for document_index, document in enumerate(collection.find()):
        _id = document.get("_id", f"{uuid.uuid4()}")
        form_data = document.get("form_data", {})
        graph_data = document.get("graph_data", {})
        images = document.get("images", [])
        timestamp = document.get("timestamp", datetime.now())

        timestamp_formatted = timestamp.strftime("%Y-%m-%d_%H-%M-%S")
        hedge_folder = os.path.join(base_folder, f"{timestamp_formatted}_{_id}")

        if not os.path.exists(hedge_folder):
            os.mkdir(hedge_folder)
            print(f"Created folder: {hedge_folder}")

        # write dictionary data, 3 .json files per submission
        for data, description in zip([form_data, graph_data], ["form_data", "graph_data"]):
            json_path = os.path.join(hedge_folder, f"{description}.json")
            with open(file=json_path, mode="w", encoding="utf-8") as f_out:
                json.dump(data, f_out)
                print(f"Created file: {json_path}")

        # write images
        for image_index, image in enumerate(images):
            image_path = os.path.join(hedge_folder, f"image_{image_index+1}.jpg")
            with open(file=image_path, mode="wb") as img_out:
                img_out.write(bytes(image))
                print(f"Created image: {image_path}")

        print(f"Processed {document_index+1} documents")


if __name__ == "__main__":
    fetch_documents()
