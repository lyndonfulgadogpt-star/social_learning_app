import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv

from services.content_service import ContentService
from services.chat_service import ChatService

load_dotenv()

app = Flask(__name__)
CORS(app)

# Configuration
YOUTUBE_API_KEY = os.getenv("YOUTUBE_API_KEY")
DATA_FILE = os.path.join(os.path.dirname(__file__), 'data', 'historical_data.json')

# Initialize Services
content_service = ContentService(DATA_FILE, youtube_api_key=YOUTUBE_API_KEY)
chat_service = ChatService()

@app.route('/api/landmarks/nearby', methods=['GET'])
def get_nearby_landmarks():
    try:
        lat = float(request.args.get('lat'))
        lon = float(request.args.get('lon'))
        radius = float(request.args.get('radius', 10))

        landmarks = content_service.get_nearby_landmarks(lat, lon, radius)
        return jsonify(landmarks)
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/landmarks/<landmark_id>', methods=['GET'])
def get_landmark_details(landmark_id):
    info = content_service.get_landmark_info(landmark_id)
    if info:
        return jsonify(info)
    return jsonify({"error": "Landmark not found"}), 404

@app.route('/api/chat/<group_id>', methods=['GET'])
def get_chat_messages(group_id):
    messages = chat_service.get_messages(group_id)
    return jsonify(messages)

@app.route('/api/chat/<group_id>', methods=['POST'])
def post_chat_message(group_id):
    data = request.json
    user = data.get('user', 'Anonymous')
    text = data.get('text')

    if not text:
        return jsonify({"error": "Message text is required"}), 400

    message = chat_service.post_message(group_id, user, text)
    if message:
        return jsonify(message)
    return jsonify({"error": "Group not found"}), 404

if __name__ == '__main__':
    app.run(debug=True, port=5000)
