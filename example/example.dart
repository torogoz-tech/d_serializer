import 'package:d_serializer/d_serializer.dart';

part 'example.g.dart';

enum Status { active, inactive, pending }

@Serializable()
class User {
  String name;
  int age;
  String? email;
  Status status;
  DateTime createdAt;
  List<String> roles;
  Map<String, dynamic> metadata;

  User({
    required this.name,
    required this.age,
    this.email,
    required this.status,
    required this.createdAt,
    required this.roles,
    required this.metadata,
  });
}

void main() {
  final user = User(
    name: 'John Doe',
    age: 30,
    email: 'john@example.com',
    status: Status.active,
    createdAt: DateTime.now(),
    roles: ['admin', 'user'],
    metadata: {'theme': 'dark', 'notifications': true},
  );

  final json = user.toJson();
  print('toJson: ${json}');

  final restored = _$UserFromJson(json);
  print('fromJson: ${restored.name}, ${restored.age}, ${restored.status}');
}
