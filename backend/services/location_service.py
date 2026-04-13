class LocationService:
    def __init__(self):
        pass

    def process_coordinates(self, lat, lon):
        """
        Process coordinates and return structured location data.
        Can be expanded to include reverse geocoding using Google Maps API.
        """
        return {
            "latitude": lat,
            "longitude": lon,
            "formatted_coords": f"{lat}, {lon}"
        }

    def is_within_bounds(self, lat, lon, bounds):
        """
        Check if a location is within a bounding box.
        bounds: {'min_lat': x, 'max_lat': y, 'min_lon': a, 'max_lon': b}
        """
        return (bounds['min_lat'] <= lat <= bounds['max_lat'] and
                bounds['min_lon'] <= lon <= bounds['max_lon'])
