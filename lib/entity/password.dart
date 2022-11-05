import 'package:floor/floor.dart';

@Entity(tableName: 'passwords')
class Password {
  final String? comment;
  @PrimaryKey()
  final int? id;
  final String name;
  final String password;
  final String username;

  Password({
    this.comment,
    this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  Password copyWith({
    String? comment,
    int? id,
    String? name,
    String? username,
    String? password,
  }) {
    return Password(
      comment: comment ?? this.comment,
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }
}
