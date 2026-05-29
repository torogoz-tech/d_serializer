import 'package:d_serializer/d_serializer.dart';

part 'example.g.dart';

enum Status { active, inactive, pending }

@Serializable()
class User {
  final String name;
  final int age;
  final Status status;
  final DateTime createdAt;

  User({
    required this.name,
    required this.age,
    required this.status,
    required this.createdAt,
  });
}

void main() {
  // En archivos fuera de lib/, usa el registro generado del propio modelo.
  registerUserSerializer();

  final User user = User(
    name: 'John',
    age: 30,
    status: Status.active,
    createdAt: DateTime.parse('2026-05-29T10:00:00Z'),
  );

  final String json = Serializer.toJson<User>(user);
  final User restored = Serializer.fromJson<User>(json);

  print(json);
  print('${restored.name} - ${restored.status.name} - ${restored.createdAt.toIso8601String()}');
}
