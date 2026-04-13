import datetime

class ChatService:
    def __init__(self):
        # In-memory storage for simplicity. In production, use Firebase or a Database.
        self.groups = {
            "paris_history_buffs": {
                "name": "Paris History Buffs",
                "messages": [
                    {"user": "System", "text": "Welcome to Paris History Buffs!", "time": "2023-10-01 10:00:00"}
                ]
            },
            "nyc_history_lovers": {
                "name": "NYC History Lovers",
                "messages": [
                    {"user": "System", "text": "Welcome to NYC History Lovers!", "time": "2023-10-01 10:00:00"}
                ]
            }
        }

    def get_messages(self, group_id):
        return self.groups.get(group_id, {}).get("messages", [])

    def post_message(self, group_id, user, text):
        if group_id in self.groups:
            message = {
                "user": user,
                "text": text,
                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            }
            self.groups[group_id]["messages"].append(message)
            return message
        return None

    def create_group(self, group_id, name):
        if group_id not in self.groups:
            self.groups[group_id] = {"name": name, "messages": []}
            return True
        return False
