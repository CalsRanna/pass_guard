import 'package:isar/isar.dart';

part 'guard.g.dart';

/// The `Guard` class represents a security entity with a unique identifier and a title.
///
/// This class holds a collection of `Segment` objects, each defining a specific
/// part of the guard configuration. It also tracks the creation and update timestamps.
///
/// Variables:
///   - `id`: An auto-incrementing identifier for each guard.
///   - `title`: A string representing the title of the guard.
///   - `segments`: A list of `Segment` objects associated with the guard.
///   - `createdAt`: A `DateTime` indicating when the guard was created.
///   - `updatedAt`: A `DateTime` indicating when the guard was last updated.
@collection
@Name('guards')
class Guard {
  Id id = Isar.autoIncrement;
  String title = '';
  List<Segment> segments = [];
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();

  /// Creates a new `Guard` instance.
  ///
  /// By default, the guard has an auto-incrementing id, an empty title,
  /// an empty list of segments, and the creation and update timestamps
  /// are set to the current date and time.
  Guard();

  /// Creates a new `Guard` instance from a JSON map.
  ///
  /// This constructor parses a JSON map to instantiate a `Guard` object with
  /// properties corresponding to the map's key-value pairs. If keys are missing
  /// in the provided JSON map, it uses default values: an empty string for `title`,
  /// an empty list for `segments`, and the current date and time for `createdAt` and `updatedAt`.
  ///
  /// The `segments` list is populated by mapping each JSON object in the corresponding
  /// JSON array to a `Segment` instance using `Segment.fromJson`.
  ///
  /// Parameters:
  ///   - `json`: The JSON map containing keys `title`, `segments`, `created_at`,
  ///             and `updated_at`. If a key is not present, a default value is used.
  ///
  /// Returns:
  ///   A new `Guard` instance with the properties set from the JSON map.
  factory Guard.fromJson(Map<String, dynamic> json) {
    final guard = Guard();
    guard.title = json['title'] ?? '';
    guard.segments = (json['segments'] as List)
        .map((segment) => Segment.fromJson(segment))
        .toList();
    guard.createdAt = json['created_at'] ?? DateTime.now();
    guard.updatedAt = json['updated_at'] ?? DateTime.now();
    return guard;
  }

  /// Converts a `Guard` instance into a JSON map.
  ///
  /// This method serializes the `Guard` instance into a JSON map containing its properties.
  /// The `segments` list is serialized by converting each `Segment` instance into a JSON
  /// object using the `Segment.toJson` method.
  ///
  /// Returns:
  ///   A map with string keys and dynamic values representing the JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/// The `Segment` class represents a segment of a guard configuration.
///
/// Each segment contains a title and a list of fields, with each field representing
/// a specific property within the segment.
///
/// Variables:
///   - `title`: A string representing the title of the segment.
///   - `fields`: A list of `Field` objects that hold the data for each property in the segment.
///
/// The class provides a constructor for creating a new instance, a factory constructor
/// for creating an instance from a JSON map, and a `toJson` method for serializing the
/// instance into a JSON map.
@embedded
@Name('segments')
class Segment {
  String title = '';
  List<Field> fields = [];

  /// Creates a new [Segment] instance with default values.
  ///
  /// The [title] is initialized as an empty string and [fields] is initialized as an empty list.
  Segment();

  /// Creates a new [Segment] instance from a JSON map.
  ///
  /// This factory constructor parses a JSON map and instantiates a [Segment] object with
  /// properties corresponding to the map's key-value pairs. The `title` is set directly from the
  /// JSON map, while `fields` is populated by mapping each JSON object in the corresponding
  /// JSON array to a [Field] instance using `Field.fromJson`.
  ///
  /// Parameters:
  ///   - `json`: The JSON map containing keys `title` and `fields`, where `fields` is expected
  ///             to be a list of JSON objects corresponding to field data.
  ///
  /// Returns:
  ///   A [Segment] instance with properties set from the JSON map.
  factory Segment.fromJson(Map<String, dynamic> json) {
    final segment = Segment();
    segment.title = json['title'];
    segment.fields =
        (json['fields'] as List).map((field) => Field.fromJson(field)).toList();
    return segment;
  }

  /// Converts a [Segment] instance into a JSON map.
  ///
  /// This method serializes the [Segment] instance into a JSON map containing its properties.
  /// The `fields` list is serialized by converting each [Field] instance into a JSON
  /// object using the [Field.toJson] method.
  ///
  /// Returns:
  ///   A map with string keys and dynamic values representing the JSON object.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}

/// Represents a single field within a segment.
///
/// Each field has a [key], [value], [type], and [label], which can be
/// used to store and represent various types of data within a segment.
///
/// The [key] is a unique identifier for the field.
/// The [value] contains the data associated with the field.
/// The [type] describes the kind of data the field holds (e.g., 'text', 'number').
/// The [label] provides a human-readable label for the field, which can be used
/// in user interfaces.
@embedded
@Name('fields')
class Field {
  String key = '';
  String value = '';
  String type = '';
  String label = '';

  /// Creates a [Field] instance with default values.
  ///
  /// The [key], [value], [type], and [label] are initialized as empty strings.
  Field();

  /// Creates a [Field] instance from a JSON map.
  ///
  /// This constructor parses the provided JSON map and assigns the values to the
  /// corresponding properties of the [Field] instance. The JSON map must contain
  /// the keys 'key', 'value', 'type', and 'label'.
  ///
  /// Parameters:
  ///   - `json`: The JSON map containing keys corresponding to field properties.
  ///
  /// Returns:
  ///   A new [Field] instance with properties set from the JSON map.
  factory Field.fromJson(Map<String, dynamic> json) {
    final field = Field();
    field.key = json['key'];
    field.value = json['value'];
    field.type = json['type'];
    field.label = json['label'];
    return field;
  }

  /// Converts a [Field] instance into a JSON map.
  ///
  /// This method serializes the [Field] instance into a JSON map containing its properties.
  /// Each property of the [Field] instance is represented as a key-value pair in the map.
  ///
  /// Returns:
  ///   A map with string keys and dynamic values representing the JSON object.
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'type': type,
      'label': label,
    };
  }
}
