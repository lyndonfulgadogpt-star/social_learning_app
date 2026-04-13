import requests
import os

class MapService:
    def __init__(self, google_maps_api_key=None):
        self.api_key = google_maps_api_key

    def search_nearby_places(self, lat, lon, radius=1000, type="museum"):
        """
        Uses Google Places API to find landmarks if they aren't in our local database.
        """
        if not self.api_key:
            return []

        url = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        params = {
            "location": f"{lat},{lon}",
            "radius": radius,
            "type": type,
            "key": self.api_key
        }

        try:
            response = requests.get(url, params=params)
            results = response.json().get("results", [])
            landmarks = []
            for place in results:
                landmarks.append({
                    "id": place["place_id"],
                    "name": place["name"],
                    "latitude": place["geometry"]["location"]["lat"],
                    "longitude": place["geometry"]["location"]["lng"],
                    "address": place.get("vicinity")
                })
            return landmarks
        except Exception as e:
            print(f"Error fetching from Google Maps: {e}")
            return []
