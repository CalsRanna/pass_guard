import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';

part 'guard_template.g.dart';

/// `GuardTemplate` is a model that represents a template for creating guards.
///
/// Each instance of `GuardTemplate` contains an auto-incrementing `id`, a `name` for the template,
/// a list of `segments` that define the configuration of the guard, and timestamps for
/// when the template was `createdAt` and `updatedAt`.
///
/// Fields:
///   - `id`: An auto-incrementing identifier for each guard template.
///   - `name`: A string representing the name of the guard template.
///   - `segments`: A list of `Segment` objects that make up the guard configuration.
///   - `createdAt`: A `DateTime` indicating when the guard template was created.
///   - `updatedAt`: A `DateTime` indicating when the guard template was last updated.
@collection
@Name('guard_templates')
class GuardTemplate {
  Id id = Isar.autoIncrement;
  String name = '';
  List<Segment> segments = [];
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();

  /// Creates a new instance of `GuardTemplate`.
  ///
  /// Upon creation, the guard template is assigned an auto-incrementing `id`,
  /// an empty `name`, an empty list of `segments`, and the `createdAt` and
  /// `updatedAt` fields are set to the current date and time.
  GuardTemplate();

  /// Creates a new instance of `GuardTemplate` from a JSON map.
  ///
  /// This constructor parses the provided JSON map and assigns the values to
  /// the respective fields in the `GuardTemplate`. If certain keys are not present
  /// in the JSON, default values are used where applicable.
  ///
  /// The `segments` field is populated by mapping each item in the JSON array to
  /// a `Segment` using `Segment.fromJson`.
  ///
  /// Parameters:
  ///   - `json`: The JSON map containing keys `name`, `segments`, `created_at`,
  ///             and `updated_at`.
  ///
  /// Returns:
  ///   A new `GuardTemplate` instance with fields populated from the JSON map.
  factory GuardTemplate.fromJson(Map<String, dynamic> json) {
    final template = GuardTemplate();
    template.name = json['name'];
    template.segments = (json['segments'] as List)
        .map((segment) => Segment.fromJson(segment))
        .toList();
    template.createdAt = json['created_at'] ?? DateTime.now();
    template.updatedAt = json['updated_at'] ?? DateTime.now();
    return template;
  }

  /// Converts a `GuardTemplate` instance into a JSON map.
  ///
  /// This method serializes the `GuardTemplate` instance into a JSON map containing its properties.
  /// The `segments` list is serialized by converting each `Segment` instance into a JSON
  /// object using the `Segment.toJson` method.
  ///
  /// Returns:
  ///   A map with string keys and dynamic values representing the JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
