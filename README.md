# d_serializer

`d_serializer` is a static JSON serialization library for Dart and Flutter with annotation-based code generation.

It provides a simple API:

- `Serializer.toJson<T>(value)`
- `Serializer.fromJson<T>(json)`

And a codegen flow that avoids manual `toMap/fromMap` boilerplate for each model.

## Features

- Annotation-based model generation with `@Serializable()`
- Static serializer API (`toJson/fromJson`)
- Registry bootstrap via generated `initializeDSerializer()`
- Field controls via `@JsonKey(...)`
- Formatter pipeline via `@Format(...)`
- Strict and safe deserialization options
- Support for common Dart types and nested models

## Installation

```yaml
dependencies:
  d_serializer: ^1.0.2

dev_dependencies:
  build_runner: ^2.10.3
  d_serializer_builder: ^1.0.2
```

## Quick Start

### 1) Create a model

```dart
import 'package:d_serializer/d_serializer.dart';

part 'user.g.dart';

@Serializable()
class User {
  @JsonKey(requiredKey: true)
  final int id;

  @JsonKey(requiredKey: true)
  final String name;

  User({required this.id, required this.name});
}
```

### 2) Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3) Initialize registry once

```dart
import 'd_serializer_registry.g.dart';

void main() {
  initializeDSerializer();
}
```

### 4) Serialize / deserialize

```dart
final user = User(id: 1, name: 'Abner');

final json = Serializer.toJson<User>(user);
final restored = Serializer.fromJson<User>(json);
```

## API

### `Serializer`

- `Serializer.register<T>({fromJson, toJson})`
- `Serializer.toJson<T>(value)`
- `Serializer.fromJson<T>(json)`
- `Serializer.formatDate(value, pattern)`
- `Serializer.parseDate(value, pattern)`

### `@Serializable(...)`

Class-level options:

- `rename`
- `discriminator`
- `typeField`
- `strict`
- `naming` (`JsonNaming.none`, `JsonNaming.snakeCase`)

### `@JsonKey(...)`

Field-level options:

- `name`
- `ignore`
- `defaultValue`
- `converter`
- `useEnumIndex`
- `requiredKey`
- `unknownEnumValue`

### `@Format(...)`

Field formatter pipeline (applied in both `toJson` and `fromJson`).

| Formatter | Supported field types | Notes |
|---|---|---|
| `@Format.trim()` | `String`, `String?` | Trims leading/trailing whitespace |
| `@Format.uppercase()` | `String`, `String?` | Uppercase transformation |
| `@Format.lowercase()` | `String`, `String?` | Lowercase transformation |
| `@Format.date('yyyy-MM-dd')` | `DateTime`, `DateTime?` | Uses built-in formatter/parser |
| `@Format.date('iso8601')` | `DateTime`, `DateTime?` | Uses `toIso8601String`/`DateTime.parse` |
| `@Format.custom('X')` | Any | Uses custom formatter functions |

Pipeline order:

- Formatters are applied in annotation order.
- Same order is applied in `toJson` and in `fromJson`.

Build-time validation:

- String formatters on non-string fields fail generation.
- Date formatter on non-date fields fails generation.
- Empty `@Format.custom('')` fails generation.

`@Format.custom('X')` contract:

Define top-level functions visible in the same model library scope:

- `XFormatToJson(dynamic value)`
- `XFormatFromJson(dynamic value)`

## Advanced Examples

### Custom converter (`@JsonKey(converter: 'Money')`)

```dart
class Money {
  final int cents;
  const Money(this.cents);
}

Object? MoneyToJson(dynamic value) => (value as Money).cents;
Money MoneyFromJson(dynamic value) => Money((value as num).toInt());

@Serializable()
class Invoice {
  @JsonKey(converter: 'Money')
  final Money total;

  Invoice({required this.total});
}
```

### Custom formatter (`@Format.custom('TitleCase')`)

```dart
String TitleCaseFormatToJson(dynamic value) {
  final input = (value as String).trim().toLowerCase();
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String TitleCaseFormatFromJson(dynamic value) {
  return TitleCaseFormatToJson(value);
}

@Serializable()
class Post {
  @JsonKey(requiredKey: true)
  @Format.custom('TitleCase')
  final String title;

  Post({required this.title});
}
```

### Discriminator support

```dart
@Serializable(typeField: 'kind', discriminator: 'order')
class OrderEvent {
  final int id;
  OrderEvent({required this.id});
}
```

### Unknown key policy (`strict`)

```dart
@Serializable(strict: true)
class StrictModel {
  final int id;
  StrictModel({required this.id});
}
```

## Supported Types

- `int`, `double`, `String`, `bool`, `dynamic`
- `DateTime`, `Uri`, `BigInt`, `Duration`
- `List<T>`, `Set<T>`, `Map<String, T>`
- Enums (by name or index)
- Nested `@Serializable()` models

## Build Workflow

### Do I need to run build every time?

Not for every run.

- If you changed annotated models: regenerate.
- If models did not change: no manual regeneration needed.

Recommended during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Recommended for CI/release:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

- `Type X is not registered`:
  - Run code generation.
  - Call `initializeDSerializer()` before use.

- Converter function not found:
  - Ensure `XToJson` / `XFromJson` exist as top-level functions and are visible in the model library.

- Custom formatter function not found:
  - Ensure `XFormatToJson` / `XFormatFromJson` exist as top-level functions and are visible in the model library.

- Unknown fields error:
  - Check `@Serializable(strict: true)` behavior or disable strict mode.

## License

MIT
