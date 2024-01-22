import 'dart:math';

class ReminderNotification {
  static final List<Map<String, String>> list = [
    {
      'title': "Keep Smiling 😊",
      'content': "Don't forget to log your mood today! Your happiness matters."
    },
    {
      'title': "How are You Feeling Today?",
      'content': "Tap here to check in and share your mood. Your feelings matter!"
    },
    {
      'title': "Hey There! 😊",
      'content': "Just a reminder to check in and track your mood today. We're here for you!"
    },
    {
      'title': "Write Your Mood Story 📝",
      'content': "Your mood diary is waiting! Pen down your feelings for today."
    },
    {
      'title': "Explore Your Mood 🔮",
      'content': "Time to explore your emotions! Open the app and let us know how you're feeling."
    },
    {
      'title': "Daily Mood Check-In 🌟",
      'content': "Ready to check in? Let us know how your day is going by sharing your current mood."
    },
    {
      'title': "Journal Your Mood 📔",
      'content': "Your mood journal is waiting! Take a moment to jot down your thoughts and feelings."
    },
    {
      'title': "Mood Magic Unleashed! ✨",
      'content': "Unleash the magic of your mood! Share your emotions and let the good vibes flow."
    },
    {
      'title': "Feel-Good Check-In 😄",
      'content': "Sending a reminder to check in and share the feel-good moments. Your mood matters!"
    },
    {
      'title': "Daily Check-In Reminder! 😊",
      'content': "It's that time of the day! Share your mood and let us know how you're feeling."
    },
    {
      'title': "Weather Check-In! 🌥️",
      'content': "Just like the weather, moods change. Check in and share your emotional forecast."
    },
    {
      'title': "Reflect on Your Day 😕",
      'content': "Take a moment to reflect on your day. Share your mood and thoughts with us."
    },
  ];

  static Map<String, String> random() {
    if (list.isEmpty) {
      throw Exception("Notification list is empty");
    }
    int randomIndex = Random().nextInt(list.length);
    return list[randomIndex];
  }
}