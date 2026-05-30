import 'package:d_serializer/d_serializer.dart';

part 'example_user.g.dart';

enum ExampleStatus {
  active,
  inactive,
  pending,
}

@Serializable()
class ExampleUser {
  final String name;
  final int age;
  final ExampleStatus status;
  final DateTime createdAt;

  ExampleUser({
    required this.name,
    required this.age,
    required this.status,
    required this.createdAt,
  });
}
