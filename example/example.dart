import 'package:d_serializer/d_serializer_registry.g.dart';
import 'package:d_serializer/example_user.dart';
import 'package:d_serializer/d_serializer.dart';

void main() {
  initializeDSerializer();

  final ExampleUser user = ExampleUser(
    name: 'John',
    age: 30,
    status: ExampleStatus.active,
    createdAt: DateTime.parse('2026-05-29T10:00:00Z'),
  );

  final String json = Serializer.toJson<ExampleUser>(user);
  final ExampleUser restored = Serializer.fromJson<ExampleUser>(json);

  print(json);
  print(
    '${restored.name} - '
    '${restored.status.name} - '
    '${restored.createdAt.toIso8601String()}',
  );
}
