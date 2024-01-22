import 'package:mood_tracker/core/services/db.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/core/models/mood.dart';

class MoodAttribute {
  static const String dbTable = 'mood_attribute';
  int? moodId;
  int? attributeId;

  MoodAttribute({
    required Mood mood,
    required Attribute attribute,
  }) :
    moodId = mood.id,
    attributeId = attribute.id;

  Map<String, Object?> toMap() {
    return {
      'mood_id': moodId,
      'attribute_id': attributeId,
    };
  }

  Future<int> save() async {
    return DbService.addMoodAttribute(this);
  }

  Future<int> delete() async {
    return DbService.deleteMoodAttribute(this);
  }
}