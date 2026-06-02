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
| `@Format.customWith(TypeName)` | Any | Typed custom formatter, resolves by type name |

Pipeline order:

- Formatters are applied in annotation order.
- Same order is applied in `toJson` and in `fromJson`.

Build-time validation:

- String formatters on non-string fields fail generation.
- Date formatter on non-date fields fails generation.
- Empty `@Format.custom('')` fails generation.
- `@Format.customWith(TypeName)` requires a valid type literal.

`@Format.custom('X')` and `@Format.customWith(TypeName)` contract:

Define top-level functions visible in the same model library scope:

- `XFormatToJson(dynamic value)`
- `XFormatFromJson(dynamic value)`

## Complete Structured Example

A production-like sample is included in `example/example.dart` (self-contained).

This sample demonstrates:

- nested models
- enum fallback with `unknownEnumValue`
- `List<T>`, `Set<T>`, and `Map<String, T>`
- `@JsonKey(requiredKey, defaultValue, ignore, converter)`
- `@Format.trim()` and `@Format.customWith(TitleCase)`
- `@Serializable(strict, naming, typeField, discriminator)`

Run the sample:

```bash
dart run build_runner build
dart run example/example.dart
```

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

### Typed custom formatter (`@Format.customWith(TitleCase)`)

```dart
String TitleCaseFormatToJson(dynamic value) {
  final input = (value as String).trim().toLowerCase();
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String TitleCaseFormatFromJson(dynamic value) {
  return TitleCaseFormatToJson(value);
}

class TitleCase {
  const TitleCase._();
}

@Serializable()
class Post {
  @JsonKey(requiredKey: true)
  @Format.customWith(TitleCase)
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

## Polymorphic Unions

Support for discriminated union serialization using sealed classes with `@SerializableUnion`.

### Overview

Polymorphic unions allow you to serialize/deserialize hierarchies of related types using a discriminator field. The framework automatically resolves the correct subtype during deserialization.

### Key Concepts

- **Root type**: A `sealed class` marked with `@SerializableUnion`
- **Subtypes**: Concrete classes marked with `@Serializable(discriminator: 'value')`
- **Discriminator field**: JSON field that stores the type indicator (defaults to `'type'`)

### Usage

#### 1. Define the union root

```dart
import 'package:d_serializer/d_serializer.dart';

part 'models.g.dart';

@SerializableUnion(typeField: 'kind')
sealed class PaymentMethod {
  const PaymentMethod();
}
```

#### 2. Define concrete subtypes

```dart
@Serializable(discriminator: 'card')
class CardPayment extends PaymentMethod {
  final String last4;
  final String brand;

  const CardPayment({
    required this.last4,
    required this.brand,
  });
}

@Serializable(discriminator: 'paypal')
class PayPalPayment extends PaymentMethod {
  final String email;

  const PayPalPayment({required this.email});
}
```

#### 3. Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

The generated code will:
- Include the discriminator field in each subtype's JSON
- Register union factories for automatic type resolution

#### 4. Initialize and use

```dart
import 'd_serializer_registry.g.dart';

void main() {
  initializeDSerializer();

  // Serialize any PaymentMethod subtype
  const payment = CardPayment(last4: '1234', brand: 'Visa');
  final json = Serializer.toJson<PaymentMethod>(payment);
  // Output: {'kind': 'card', 'last4': '1234', 'brand': 'Visa'}

  // Deserialize - automatically resolves correct subtype
  final restored = Serializer.fromJson<PaymentMethod>(json);
  // restored is a CardPayment instance
}
```

### API

#### `@SerializableUnion`

Marks a sealed class as a polymorphic union root.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `typeField` | `String` | `'type'` | JSON field name for the discriminator |

#### `@Serializable` (union-specific)

| Parameter | Type | Description |
|-----------|------|-------------|
| `discriminator` | `String` | Unique value for this subtype in the discriminator field |

### Design Patterns

#### Event system

```dart
@SerializableUnion(typeField: 'event')
sealed class AppEvent {
  const AppEvent();
}

@Serializable(discriminator: 'click')
class ClickEvent extends AppEvent {
  final String elementId;
  const ClickEvent({required this.elementId});
}

@Serializable(discriminator: 'scroll')
class ScrollEvent extends AppEvent {
  final int pixels;
  const ScrollEvent({required this.pixels});
}

@Serializable(discriminator: 'error')
class ErrorEvent extends AppEvent {
  final String message;
  const ErrorEvent({required this.message});
}
```

#### API response types

```dart
@SerializableUnion(typeField: 'type')
sealed class ApiResponse {
  const ApiResponse();
}

@Serializable(discriminator: 'success')
class SuccessResponse extends ApiResponse {
  final dynamic data;
  const SuccessResponse({required this.data});
}

@Serializable(discriminator: 'error')
class ErrorResponse extends ApiResponse {
  final String code;
  final String message;
  const ErrorResponse({required this.code, required this.message});
}
```

### Extending existing unions

Subclasses can add additional subtypes by simply annotating new classes with the appropriate discriminator:

```dart
@Serializable(discriminator: 'crypto')
class CryptoPayment extends PaymentMethod {
  final String walletAddress;
  const CryptoPayment({required this.walletAddress});
}
```

### Best practices

1. **Use meaningful discriminator values**: Choose values that clearly identify each subtype
2. **Keep discriminators stable**: Once published, avoid changing discriminator values
3. **Use sealed classes**: Dart's sealed modifier ensures exhaustive pattern matching
4. **Document discriminator mappings**: Keep a reference of which discriminator maps to which type

### Limitations

- All subtypes must be annotated with `@Serializable` and have a unique `discriminator`
- The union root must be a `sealed class` (recommended) or a regular class
- Type resolution happens at runtime via factory registration

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
