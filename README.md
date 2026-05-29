# d_serializer

**Dart serialization library with invisible code generation**

Unlike other serialization packages, `d_serializer` generates code that is invisible to you. The generated file is a `part of` your source file, keeping your codebase clean.

## Features

- **Invisible code generation** - Generated files are `part of` your model
- **Annotations** - Simple `@Serializable()` class annotation
- **Type support** - Primitives, DateTime, List, Map, enums, nested objects
- **@JsonKey** - Customize field names and ignore fields
- **Extensions** - `toJson()` method available directly on classes

## Usage

### 1. Add dependencies

```yaml
dependencies:
  d_serializer: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
  d_serializer_builder: ^1.0.0
```

### 2. Create a model

```dart
import 'package:d_serializer/d_serializer.dart';

part 'model.g.dart';

@Serializable()
class User {
  String name;
  int age;
  String? email;

  User({required this.name, required this.age, this.email});
}
```

### 3. Add `part` directive

```dart
import 'package:d_serializer/d_serializer.dart';

part 'model.g.dart'; // This is auto-generated

@Serializable()
class User {
  String name;
  int age;
  String? email;

  User({required this.name, required this.age, this.email});
}
```

### 4. Run build_runner

```bash
dart run build_runner build
```

### 5. Use it

```dart
final user = User(name: 'John', age: 30);

// Extension method - toJson() available directly
final json = user.toJson();

// Generated fromJson function
final restored = _$UserFromJson(json);
```

## @JsonKey

Customize serialization with `@JsonKey`:

```dart
@Serializable()
class User {
  @JsonKey(name: 'full_name')
  String name;
  
  @JsonKey(ignore: true)
  String? temporary;
  
  @JsonKey(useEnumIndex: true)
  Status status;
}
```

## Type Support

| Type | Serialization |
|------|---------------|
| int, double | number |
| String | string |
| bool | boolean |
| DateTime | ISO8601 string |
| List<T> | JSON array |
| Map<K,V> | JSON object |
| Enum | string name (or index with `useEnumIndex`) |
| @Serializable | nested object |

## Why d_serializer?

| Feature | json_serializable | freezed | d_serializer |
|---------|-------------------|---------|--------------|
| Generated files visible | `.g.dart` | `.freezed.dart` + `.g.dart` | **Invisible** (`part of`) |
| User sees clean code | No | No | **Yes** |

## Example

```dart
import 'package:d_serializer/d_serializer.dart';

part 'model.g.dart';

enum Status { active, inactive }

@Serializable()
class User {
  String name;
  int age;
  Status status;
  DateTime createdAt;
  List<String> roles;

  User({
    required this.name,
    required this.age,
    required this.status,
    required this.createdAt,
    required this.roles,
  });
}

void main() {
  final user = User(
    name: 'John',
    age: 30,
    status: Status.active,
    createdAt: DateTime.now(),
    roles: ['admin'],
  );

  final json = user.toJson();
  print(json);

  final restored = _$UserFromJson(json);
  print(restored.name);
}
```

## License

MIT
