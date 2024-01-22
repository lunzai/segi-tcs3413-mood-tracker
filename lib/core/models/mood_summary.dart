import 'package:mood_tracker/core/enums/mood_value.dart';

class MoodSummary {
  int count;
  int total;
  double percent;
  MoodValue mood;

  MoodSummary({
    required this.count,
    required this.total,
    required this.mood,
  }) : 
    percent = double.parse((count.toDouble() / total.toDouble()).toStringAsPrecision(2));

  MoodSummary.fromMap(Map<String, dynamic> map) :
    mood=MoodValue.values.byName(map["label"]),
    count=map["count"],
    total=map["total"],
    percent=map["count"].toDouble() / map["total"].toDouble();

}