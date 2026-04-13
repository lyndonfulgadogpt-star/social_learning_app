# Social Learning App - Backend

This is the backend for a social learning app that teaches history and culture based on the user's location.

## Project Structure
- `main.py`: Flask entry point and API routes.
- `services/`:
    - `content_service.py`: Manages historical data and YouTube API integration.
    - `chat_service.py`: Handles real-time chat logic.
    - `location_service.py`: Coordinates processing.
    - `map_service.py`: Google Maps/Places API integration.
- `data/`:
    - `historical_data.json`: Initial dataset for landmarks.
- `requirements.txt`: Python dependencies.

## Setup Instructions

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Environment Variables**:
   Create a `.env` file in the `backend/` directory:
   ```env
   YOUTUBE_API_KEY=YOUR_YOUTUBE_API_KEY
   GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
   ```

3. **Run the Application**:
   ```bash
   python main.py
   ```
   The API will be available at `http://127.0.0.1:5000`.

## API Endpoints

- `GET /api/landmarks/nearby?lat={lat}&lon={lon}&radius={km}`: Get landmarks near coordinates.
- `GET /api/landmarks/{landmark_id}`: Get detailed info for a landmark.
- `GET /api/chat/{group_id}`: Get chat history for a group.
- `POST /api/chat/{group_id}`: Post a new message to a group.

## Example Scenario
If a user is at (48.8584, 2.2945), calling `/api/landmarks/nearby?lat=48.8584&lon=2.2945` will return the Eiffel Tower. Tapping it will fetch details including YouTube links and the group chat ID `paris_history_buffs`.
