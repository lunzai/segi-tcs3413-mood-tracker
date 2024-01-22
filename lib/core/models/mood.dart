import 'package:mood_tracker/core/enums/mood_value.dart';
import 'package:mood_tracker/core/services/db.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/core/models/mood_attribute.dart';

class Mood {
  static const String dbTable = 'mood';

  int? id;
  MoodValue value;
  DateTime date;
  String notes = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attribute> activities = [];
  List<Attribute> emotions = [];
  List<Attribute> oldActivities = [];
  List<Attribute> oldEmotions = [];

  Mood({
    this.id, 
    this.value = MoodValue.Neutral, 
    DateTime? date, 
    String? notes, 
    this.createdAt, 
    this.updatedAt,
    List<Attribute>? activities,
    List<Attribute>? emotions,
  }) :
    date = date ?? DateTime.now(),
    activities = activities ?? [],
    emotions = emotions ?? [],
    oldActivities = activities ?? [],
    oldEmotions = emotions ?? [],
    notes = notes ?? '';
  
  bool isNewRecord() {
    return id == null;
  }

  void afterFind() {
    oldActivities = activities.toList();
    oldEmotions = emotions.toList();
  }

  void afterSave() {
    oldActivities = activities.toList();
    oldEmotions = emotions.toList();
  }

  Mood.fromMap(Map<String, dynamic> map) :
    id=map["id"],
    value=MoodValue.values.byName(map["label"]),
    date=DateTime.parse(map["date"]),
    notes=map["note"] ?? '',
    createdAt=DateTime.parse(map["created_at"]),
    updatedAt=DateTime.parse(map["updated_at"]);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'label': value.name,
      'value': value.value,
      'date': date.toString(),
      'note': notes.trim(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }

  static Future<List<Mood>> findAll() async {
    return await DbService.getMoods();
  }

  static findOne(int id) async {

  }

  Future<bool> save() async {
    bool result = isNewRecord() ? await insert() : await update();
    if (result) {
      afterSave();
    }
    return result;
  }

  Future<bool> insert() async {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    int lastInsertId = await DbService.addMood(this);
    id = lastInsertId;
    var attributes = <dynamic>{ ...activities, ...emotions };
    for (Attribute item in attributes) {
      MoodAttribute(
        mood: this, 
        attribute: item,
      ).save();
    }
    return true;
  }

  Future<bool> update() async {
    updatedAt = DateTime.now();
    DbService.updateMood(this);
    var newAttributes = <dynamic>{ ...activities, ...emotions };
    var oldAttributes = <dynamic>{ ...oldActivities, ...oldEmotions };
    var toRemove = oldAttributes.difference(newAttributes);
    var toAdd = newAttributes.difference(oldAttributes);
    for (Attribute item in toRemove) {
      MoodAttribute(
        mood: this, 
        attribute: item,
      ).delete();
    }
    for (Attribute item in toAdd) {
      MoodAttribute(
        mood: this, 
        attribute: item,
      ).save();
    }
    return true;
  }

}