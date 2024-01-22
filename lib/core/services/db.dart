import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mood_tracker/core/enums/attribute_category.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/core/models/mood.dart';
import 'package:mood_tracker/core/models/mood_attribute.dart';
import 'package:mood_tracker/core/models/mood_summary.dart';
import 'package:mood_tracker/core/utils/assets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {

  static const dbName = 'database.db';
  
  static Future<Database> getDb() async {
    String dbPath = await initDb();
    return await openDatabase(dbPath, version: 1);
  }

  static Future<String> initDb() async {
    final String path = await getDatabasesPath();
    final String dbPath = join(path, dbName);
    bool isDbExists = await databaseExists(dbPath);
    if (!isDbExists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(AppAssets.dbSchemaFile);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return dbPath;
  }

  static Future<List<MoodSummary>> getRecentSummary() async {
    log('DB: getRecentSummary');
    final db = await getDb();
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT 
        COUNT(id) as count, label, value,
        (SELECT COUNT(id) FROM mood WHERE date >= ?) AS total
      FROM mood
      WHERE date >= ?
      GROUP BY value
      ORDER BY value DESC
      ''',
      [ date.toString(), date.toString() ],
    );
    return result.map((e) => MoodSummary.fromMap(e)).toList();
  }

  static Future<List<Mood>> getRecentHistory() async {
    log('DB: getRecentHistory');
    final db = await getDb();
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT * 
      FROM mood 
      WHERE date >= ?
      ORDER BY date ASC
      ''',
      [ date.toString() ],
    );
    return result.map((e) => Mood.fromMap(e)).toList();
  }

  static Future<Map<int, double>> getDayOfWeekSummary() async {
    log('DB: getDayOfWeekSummary');
    final db = await getDb();
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
    final Map<int, double> dowMap = { for (var item in Iterable.generate(7, (index) => index + 1)) item : 0.0 };
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT 
        CAST((REPLACE(STRFTIME('%w', date), 0, 7)) AS INTEGER) as dow,
        ROUND(AVG(value), 1) as score
      FROM mood 
      WHERE date >= ?
      GROUP BY dow
      ORDER BY dow ASC
      ''',
      [ date.toString() ],
    );
    for (final row in result) {
      dowMap[ row['dow'] as int ] = row['score'] as double;
    }
    return dowMap;
  }

  static Future<List<Attribute>> getGoodMoodRelatedAttributeByCategory(AttributeCategory category) async {
    log('DB: getGoodMoodRelatedAttributeByCategory');
    final db = await getDb();
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT a.*, COUNT(a.id)  as count
      FROM mood m 
      LEFT JOIN mood_attribute ma ON ma.mood_id = m.id
      LEFT JOIN attribute a ON a.id = ma.attribute_id 
      WHERE m.value > 3 
      AND a.category = ?
      GROUP BY a.label 
      HAVING count > 1
      ORDER BY count DESC
      LIMIT 5
      ''',
      [ category.name ]
    );
    return result.map((e) => Attribute.fromMap(e)).toList();
  }

  static Future<List<Attribute>> getBadMoodRelatedAttributeByCategory(AttributeCategory category) async {
    log('DB: getBadMoodRelatedAttributeByCategory');
    final db = await getDb();
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT a.*, COUNT(a.id)  as count
      FROM mood m 
      LEFT JOIN mood_attribute ma ON ma.mood_id = m.id
      LEFT JOIN attribute a ON a.id = ma.attribute_id 
      WHERE m.value < 3 
      AND a.category = ?
      GROUP BY a.label 
      HAVING count > 1
      ORDER BY count DESC
      LIMIT 5
      ''',
      [ category.name ]
    );
    return result.map((e) => Attribute.fromMap(e)).toList();
  }
  

  static Future<List<Attribute>> getAttributesByCategory(AttributeCategory category) async {
    final db = await getDb();
    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT a.*
      FROM attribute a
      LEFT JOIN mood_attribute ma ON ma.attribute_id = a.id
      WHERE category = ?
      GROUP BY a.id
      ORDER BY COUNT(a.id) DESC
      ''',
      [ category.name ]
    );
    return result.map((e) => Attribute.fromMap(e)).toList();
  }

  static Future<List<Attribute>> getActivities() async {
    log('DB: getActivities');
    return await getAttributesByCategory(AttributeCategory.Activities);
  }

  static Future<List<Attribute>> getEmotions() async {
    log('DB: getEmotions');
    return await getAttributesByCategory(AttributeCategory.Emotions);
  }

  static Future<List<Mood>> getMoods() async {
    log('DB: getMoods');
    final db = await getDb();
    String sql = '''
      SELECT m.*, a.id AS aId, a.label AS aLabel, a.category AS aCategory
      FROM mood m
      JOIN (
        SELECT MAX(id) AS max_id FROM mood GROUP BY date(date)
      ) mg ON m.id = mg.max_id
      LEFT JOIN mood_attribute ma ON ma.mood_id = m.id 
      LEFT JOIN attribute a ON a.id = ma.attribute_id
    ''';
    final List<Map<String, Object?>> result = await db.rawQuery(sql);
    final Map<int, Mood> moodMap = {};
    for (final row in result) {
      Mood mood = Mood.fromMap(row);
      if (!moodMap.containsKey(mood.id)) {
        moodMap[ mood.id as int ] = mood;
      }
      if (row['aId'] != null) {
        Attribute attribute = Attribute.fromRelationshipMap(row);
        switch (attribute.category) {
          case AttributeCategory.Activities: 
            moodMap[ mood.id as int ]?.activities.add(attribute);
            break;
          case AttributeCategory.Emotions:
            moodMap[ mood.id as int ]?.emotions.add(attribute);
            break;
        }
      }
    }
    moodMap.forEach((key, value) { value.afterFind(); });
    return moodMap.values.toList();
  }
  
  static Future<int> addMood(Mood mood) async {
    log('DB: addMood');
    final db = await getDb();
    return await db.insert(Mood.dbTable, mood.toMap());
  }

  static Future<int> updateMood(Mood mood) async {
    log('DB: updateMood');
    final db = await getDb();
    return db.update(
      Mood.dbTable,
      mood.toMap(), 
      where: 'id = ?',
      whereArgs: [ mood.id ],
    );
  }

  static Future<int> addMoodAttribute(MoodAttribute moodAttribute) async {
    log('DB: addMoodAttribute');
    final db = await getDb();
    return await db.insert(MoodAttribute.dbTable, moodAttribute.toMap());
  }

  static Future<int> deleteMoodAttribute(MoodAttribute moodAttribute) async {
    log('DB: deleteMoodAttribute');
    final db = await getDb();
    return await db.delete(
      MoodAttribute.dbTable, 
      where: 'mood_id = ? AND attribute_id = ?',
      whereArgs: [ moodAttribute.moodId, moodAttribute.attributeId ],
    );
  }

  static Future<void> truncateAll() async {
    log('DB: truncateAll');
    final db = await getDb();
    await db.rawDelete('DELETE FROM ${MoodAttribute.dbTable}');
    await db.rawDelete('DELETE FROM ${Mood.dbTable}');
    await db.rawDelete('DELETE FROM sqlite_sequence WHERE name = ?', [ Mood.dbTable ]);
  }



}