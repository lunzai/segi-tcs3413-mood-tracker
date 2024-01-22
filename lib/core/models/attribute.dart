import 'package:mood_tracker/core/enums/attribute_category.dart';

class Attribute {
  static const String dbTable = 'attribute';

  int? id;
  String label;
  AttributeCategory category;
  
  Attribute({
    this.id,
    required this.label,
    required this.category
  });

  @override
  int get hashCode {
    return id ?? 0;
  }

  @override
  bool operator==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Attribute && other.id == id;
  }

  bool isNewRecord() {
    return id == null;
  }

  Attribute.fromRelationshipMap(Map<String, dynamic> model) :
    id=model["aId"],
    label=model["aLabel"],
    category=AttributeCategory.values.byName(model["aCategory"]);

  Attribute.fromMap(Map<String, dynamic> model) :
    id=model["id"],
    label=model["label"],
    category=AttributeCategory.values.byName(model["category"]);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'label': label,
      'value': category.name,
    };
  }  
}