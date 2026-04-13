import json
import os
import requests
from googleapiclient.discovery import build

class ContentService:
    def __init__(self, data_path, youtube_api_key=None):
        self.data_path = data_path
        self.youtube_api_key = youtube_api_key
        self.data = self._load_data()

    def _load_data(self):
        with open(self.data_path, 'r') as f:
            return json.load(f)

    def get_landmark_info(self, landmark_id):
        landmarks = self.data.get('landmarks', [])
        for landmark in landmarks:
            if landmark['id'] == landmark_id:
                # Enrich with YouTube links if API key is present
                if self.youtube_api_key:
                    landmark['youtube_videos'] = self._fetch_youtube_videos(landmark['youtube_query'])
                else:
                    landmark['youtube_videos'] = [
                        {"title": "Sample Documentary", "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}
                    ]
                return landmark
        return None

    def _fetch_youtube_videos(self, query):
        try:
            youtube = build("youtube", "v3", developerKey=self.youtube_api_key)
            request = youtube.search().list(
                q=query,
                part="snippet",
                type="video",
                maxResults=3
            )
            response = request.execute()
            videos = []
            for item in response.get("items", []):
                videos.append({
                    "title": item["snippet"]["title"],
                    "url": f"https://www.youtube.com/watch?v={item['id']['videoId']}"
                })
            return videos
        except Exception as e:
            print(f"Error fetching YouTube videos: {e}")
            return []

    def get_nearby_landmarks(self, lat, lon, radius_km=10):
        # Simple distance filtering (In a real app, use Geo-spatial queries)
        nearby = []
        for landmark in self.data.get('landmarks', []):
            # Roughly estimate distance
            dist = self._calculate_distance(lat, lon, landmark['latitude'], landmark['longitude'])
            if dist <= radius_km:
                nearby.append(landmark)
        return nearby

    def _calculate_distance(self, lat1, lon1, lat2, lon2):
        # Simplified distance calculation
        from math import radians, cos, sin, asin, sqrt
        lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
        c = 2 * asin(sqrt(a))
        r = 6371 # Radius of earth in kilometers
        return c * r
