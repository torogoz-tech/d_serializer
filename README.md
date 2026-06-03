# d_serializer

`d_serializer` is a static JSON serialization library for Dart and Flutter with annotation-based code generation.

It provides a simple API:

- `Serializer.toJson<T>(value)`
- `Serializer.fromJson<T>(json)`

And a codegen flow that avoids manual `toMap/fromMap` boilerplate for each model.

---

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [API Reference](#api-reference)
   - [Serializer](#serializer)
   - [@Serializable](#serializable)
   - [@JsonKey](#jsonkey)
   - [@Format](#format)
   - [@SerializableUnion](#serializableunion)
5. [UnknownKeyPolicy](#unknownkeypolicy)
6. [Complete Examples](#complete-examples)
   - [Basic Model](#basic-model)
   - [Nested Models](#nested-models)
   - [Collections](#collections)
   - [Custom Converters](#custom-converters)
   - [Formatter Pipeline](#formatter-pipeline)
   - [Polymorphic Unions](#polymorphic-unions)
   - [Date Formatting](#date-formatting)
7. [Advanced Topics](#advanced-topics)
   - [Build Workflow](#build-workflow)
   - [Supported Types](#supported-types)
   - [Error Handling](#error-handling)
8. [Migration Guide](#migration-guide)
9. [Troubleshooting](#troubleshooting)
10. [License](#license)

---

## Features

- **Annotation-based model generation** with `@Serializable()`
- **Static serializer API** (`toJson/fromJson`)
- **Registry bootstrap** via generated `initializeDSerializer()`
- **Field controls** via `@JsonKey(...)`
- **Formatter pipeline** via `@Format(...)`
- **UnknownKeyPolicy** for handling unknown JSON keys (`strict`, `ignore`, `capture`)
- **Polymorphic unions** with discriminator-based resolution
- **Support for common Dart types** and nested models
- **Build-time validation** for type compatibility

---

## Installation

### Requirements

- Dart SDK ^3.11.5 or higher
- Flutter SDK (optional, for Flutter projects)

### Add dependencies

```yaml
dependencies:
  d_serializer: ^1.2.0

dev_dependencies:
  build_runner: ^2.10.3
  d_serializer_builder: ^1.2.0
```

Then run:

```bash
dart pub get
```

---

## Quick Start

### Step 1: Create a model

```dart
import 'package:d_serializer/d_serializer.dart';

part 'user.g.dart';

@Serializable()
class User {
  @JsonKey(requiredKey: true)
  final int id;

  @JsonKey(requiredKey: true)
  final String name;

  @JsonKey()
  final String? email;

  User({
    required this.id,
    required this.name,
    this.email,
  });
}
```

### Step 2: Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `user.g.dart` - contains `UserFromJson`, `UserSerializer`, `registerUserSerializer()`
- `d_serializer_registry.g.dart` - contains `initializeDSerializer()`

### Step 3: Initialize registry once

```dart
import 'package:d_serializer/d_serializer.dart';
import 'd_serializer_registry.g.dart';

void main() {
  // Initialize once at app startup
  initializeDSerializer();
  
  // Now you can serialize/deserialize
  final user = User(id: 1, name: 'Abner', email: 'abner@example.com');
  
  final json = Serializer.toJson<User>(user);
  final restored = Serializer.fromJson<User>(json);
  
  print('Original: $user');
  print('JSON: $json');
  print('Restored: $restored');
}
```

### Step 4: Serialize / deserialize

```dart
// Serialize to JSON string
final jsonString = Serializer.toJson<User>(user);

// Deserialize from JSON string
final restored = Serializer.fromJson<User>(jsonString);

// Or work with Map<String, dynamic>
final Map<String, dynamic> jsonMap = user.toJson();
final restored = Serializer.fromDynamic<User>(jsonMap);
```

---

## API Reference

### Serializer

The main static API for serialization/deserialization:

```dart
// Register a type manually (usually done by generated code)
Serializer.register<User>(
  fromJson: UserFromJson,
  toJson: (User u) => u.toJson(),
);

// Serialize to JSON string
String toJson<T>(T value)

// Deserialize from JSON string
T fromJson<T>(String json)

// Deserialize from decoded JSON value
T fromDynamic<T>(dynamic decoded)

// Encode a runtime value to JSON-compatible structure
Object? encodeDynamic(Object? value)

// Date formatting helpers
String formatDate(DateTime value, String pattern)
DateTime parseDate(String value, String pattern)
```

**Available date patterns:**
- `'yyyy-MM-dd'` - e.g., "2024-06-03"
- `'iso8601'` - ISO 8601 format

---

### @Serializable

Marks a class as serializable. Options:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rename` | `String?` | `null` | Alias used as discriminator fallback |
| `discriminator` | `String?` | `null` | Explicit discriminator value for polymorphic payloads |
| `typeField` | `String?` | `null` | JSON field name to store/read the discriminator |
| `unknownKeyPolicy` | `UnknownKeyPolicy` | `UnknownKeyPolicy.ignore` | Policy for handling unknown keys |
| `naming` | `JsonNaming` | `JsonNaming.none` | Naming strategy (`none` or `snakeCase`) |

**Example:**

```dart
@Serializable(
  naming: JsonNaming.snakeCase,
  unknownKeyPolicy: UnknownKeyPolicy.strict,
  typeField: 'kind',
  discriminator: 'user_profile',
)
class UserProfile {
  final int id;
  final String fullName;
  
  UserProfile({required this.id, required this.fullName});
}
```

---

### @JsonKey

Field-level serialization customizations:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String?` | `null` | Override for the generated JSON key |
| `ignore` | `bool` | `false` | Excludes this field from serialization |
| `defaultValue` | `dynamic` | `null` | Default value when key is missing or null |
| `converter` | `String?` | `null` | Prefix for converter functions (`XToJson`/`XFromJson`) |
| `useEnumIndex` | `bool` | `false` | Encode enums by index instead of name |
| `requiredKey` | `bool` | `false` | Requires key to be present and non-null |
| `unknownEnumValue` | `String?` | `null` | Fallback enum value for unknown inputs |

**Examples:**

```dart
class Product {
  // Custom JSON key name
  @JsonKey(name: 'product_id')
  final int id;
  
  // Ignore field
  @JsonKey(ignore: true)
  final String internalCode;
  
  // Default value
  @JsonKey(defaultValue: 'Unknown')
  final String category;
  
  // Custom converter
  @JsonKey(converter: 'Money')
  final Money price;
  
  // Required field
  @JsonKey(requiredKey: true)
  final String sku;
  
  // Enum fallback
  @JsonKey(unknownEnumValue: 'UNKNOWN')
  final ProductStatus status;
}
```

---

### @Format

Field formatter pipeline applied in both `toJson` and `fromJson`:

| Formatter | Supported types | Description |
|-----------|-----------------|-------------|
| `@Format.trim()` | `String`, `String?` | Trims leading/trailing whitespace |
| `@Format.uppercase()` | `String`, `String?` | Converts to uppercase |
| `@Format.lowercase()` | `String`, `String?` | Converts to lowercase |
| `@Format.date('yyyy-MM-dd')` | `DateTime`, `DateTime?` | Custom date format |
| `@Format.date('iso8601')` | `DateTime`, `DateTime?` | ISO 8601 format |
| `@Format.custom('X')` | Any | Custom formatter by name |
| `@Format.customWith(TypeName)` | Any | Typed custom formatter |

**Pipeline order:**
- Formatters are applied in annotation order (top to bottom)
- Same order is applied in `toJson` and in `fromJson`

**Examples:**

```dart
class User {
  // Multiple formatters (pipeline)
  @Format.trim()
  @Format.uppercase()
  final String code;
  
  //Date formatting
  @Format.date('yyyy-MM-dd')
  final DateTime birthDate;
  
  // Custom formatter
  @Format.custom('TitleCase')
  final String displayName;
}
```

**Custom formatter contract:**

For `@Format.custom('X')`, define in your model library:

```dart
// Top-level functions must be visible
dynamic XFormatToJson(dynamic value) {
  // Transform value for JSON
  return (value as String).trim().toUpperCase();
}

dynamic XFormatFromJson(dynamic value) {
  // Transform value from JSON
  return XFormatToJson(value); // Usually same logic
}
```

For `@Format.customWith(TypeName)`:

```dart
class TitleCase {
  const TitleCase._();
}

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
  @Format.customWith(TitleCase)
  final String title;
  
  Post({required this.title});
}
```

---

### @SerializableUnion

Marks a base type as a polymorphic union root:

```dart
@SerializableUnion(typeField: 'type')
sealed class PaymentMethod {}

@Serializable(discriminator: 'card')
class CardPayment extends PaymentMethod {
  final String last4;
  final String brand;
  
  CardPayment({required this.last4, required this.brand});
}

@Serializable(discriminator: 'paypal')
class PaypalPayment extends PaymentMethod {
  final String email;
  
  PaypalPayment({required this.email});
}
```

When generated serializers are registered, `Serializer.fromJson<PaymentMethod>(json)` resolves the subtype using `typeField` + `discriminator`.

---

## UnknownKeyPolicy

Controls how the deserializer handles JSON keys that don't exist in your model class:

### Values

| Value | Behavior |
|-------|----------|
| `UnknownKeyPolicy.ignore` | Silently ignores unknown keys (default) |
| `UnknownKeyPolicy.strict` | Throws `ArgumentError` for unknown keys |
| `UnknownKeyPolicy.capture` | Captures unknown keys in an `extra` field |

### Usage

```dart
// Ignore unknown keys (default)
@Serializable(unknownKeyPolicy: UnknownKeyPolicy.ignore)
class IgnoreModel {
  final int id;
  // Unknown keys like "metadata" are ignored
}

// Strict mode - throws on unknown keys
@Serializable(unknownKeyPolicy: UnknownKeyPolicy.strict)
class StrictModel {
  final int id;
  // If JSON contains "unknownField", throws ArgumentError
}

// Capture mode - store unknown keys
@Serializable(unknownKeyPolicy: UnknownKeyPolicy.capture)
class CaptureModel {
  final int id;
  final Map<String, dynamic> extra;
  // Unknown keys are stored in "extra"
}
```

### Migration from `strict: true`

The old boolean `strict` parameter is deprecated in favor of `unknownKeyPolicy`:

```dart
// Old (deprecated)
@Serializable(strict: true)

// New
@Serializable(unknownKeyPolicy: UnknownKeyPolicy.strict)
```

Both work identically. The new API provides more options and better type safety.

---

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

### Example JSON Payloads

**Card Payment:**
```json
{
  "kind": "card",
  "last4": "4242",
  "brand": "Visa"
}
```

**PayPal Payment:**
```json
{
  "kind": "paypal",
  "email": "user@example.com"
}
```

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

### Best practices

1. **Use meaningful discriminator values**: Choose values that clearly identify each subtype
2. **Keep discriminators stable**: Once published, avoid changing discriminator values
3. **Use sealed classes**: Dart's sealed modifier ensures exhaustive pattern matching
4. **Document discriminator mappings**: Keep a reference of which discriminator maps to which type

### Limitations

- All subtypes must be annotated with `@Serializable` and have a unique `discriminator`
- The union root must be a `sealed class` (recommended) or a regular class
- Type resolution happens at runtime via factory registration

---

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

---

## Supported Types

## Complete Examples

### Basic Model

```dart
import 'package:d_serializer/d_serializer.dart';

part 'user.g.dart';

@Serializable()
class User {
  @JsonKey(requiredKey: true)
  final int id;
  
  @JsonKey(requiredKey: true)
  final String name;
  
  @JsonKey()
  final int? age;
  
  @JsonKey(defaultValue: 'user')
  final String role;
  
  User({
    required this.id,
    required this.name,
    this.age,
    this.role = 'user',
  });
}
```

### Nested Models

```dart
@Serializable()
class Address {
  @JsonKey(requiredKey: true)
  final String street;
  
  @JsonKey()
  final String city;
  
  @JsonKey()
  final String country;
  
  Address({
    required this.street,
    this.city = '',
    this.country = '',
  });
}

@Serializable()
class Person {
  @JsonKey(requiredKey: true)
  final int id;
  
  @JsonKey(requiredKey: true)
  final String name;
  
  final Address address;
  
  Person({
    required this.id,
    required this.name,
    required this.address,
  });
}
```

### Collections

```dart
@Serializable()
class Store {
  @JsonKey(requiredKey: true)
  final String name;
  
  // List of simple types
  final List<String> tags;
  
  // List of complex types
  final List<Product> products;
  
  // Map
  final Map<String, int> inventory;
  
  // Set
  final Set<String> categories;
  
  Store({
    required this.name,
    this.tags = const [],
    this.products = const [],
    this.inventory = const {},
    this.categories = const {},
  });
}
```

### Custom Converters

```dart
// Define custom type
class Money {
  final int cents;
  const Money(this.cents);
  
  @override
  String toString() => '\$${(cents / 100).toStringAsFixed(2)}';
}

// Define converter functions
Object? MoneyToJson(dynamic value) => (value as Money).cents;
Money MoneyFromJson(dynamic value) => Money((value as num).toInt());

@Serializable()
class Invoice {
  @JsonKey(requiredKey: true)
  final String id;
  
  @JsonKey(converter: 'Money')
  final Money subtotal;
  
  @JsonKey(converter: 'Money')
  final Money tax;
  
  @JsonKey(converter: 'Money')
  final Money total;
  
  Invoice({
    required this.id,
    required this.subtotal,
    required this.tax,
    required this.total,
  });
}
```

### Formatter Pipeline

```dart
class TitleCase {
  const TitleCase._();
}

String TitleCaseFormatToJson(dynamic value) {
  final input = (value as String).trim().toLowerCase();
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String TitleCaseFormatFromJson(dynamic value) {
  return TitleCaseFormatToJson(value);
}

@Serializable()
class Article {
  @JsonKey(requiredKey: true)
  final String title;
  
  @JsonKey()
  @Format.trim()
  final String summary;
  
  @JsonKey()
  @Format.trim()
  @Format.customWith(TitleCase)
  final String author;
  
  @Format.date('yyyy-MM-dd')
  final DateTime? publishedAt;
  
  Article({
    required this.title,
    this.summary = '',
    this.author = '',
    this.publishedAt,
  });
}
```

### Polymorphic Unions

```dart
@SerializableUnion(typeField: 'type')
sealed class Event {}

@Serializable(discriminator: 'user_created')
class UserCreatedEvent extends Event {
  final int userId;
  final String username;
  
  UserCreatedEvent({required this.userId, required this.username});
}

@Serializable(discriminator: 'order_placed')
class OrderPlacedEvent extends Event {
  final String orderId;
  final double amount;
  
  OrderPlacedEvent({required this.orderId, required this.amount});
}

@Serializable(discriminator: 'notification_sent')
class NotificationSentEvent extends Event {
  final String recipient;
  final String message;
  
  NotificationSentEvent({required this.recipient, required this.message});
}

// Usage
void handleEvent(Map<String, dynamic> json) {
  final event = Serializer.fromDynamic<Event>(json);
  // Type is resolved automatically based on discriminator
}
```

### Date Formatting

```dart
@Serializable()
class ScheduledTask {
  @JsonKey(requiredKey: true)
  final String title;
  
  @Format.date('yyyy-MM-dd')
  final DateTime dueDate;
  
  @Format.date('yyyy-MM-dd HH:mm:ss')
  final DateTime createdAt;
  
  @Format.date('iso8601')
  final DateTime? completedAt;
  
  ScheduledTask({
    required this.title,
    required this.dueDate,
    required this.createdAt,
    this.completedAt,
  });
}

// Serialization
final task = ScheduledTask(
  title: 'Meeting',
  dueDate: DateTime(2024, 6, 15),
  createdAt: DateTime(2024, 6, 1, 10, 30),
  completedAt: DateTime(2024, 6, 15, 14, 0),
);

final json = task.toJson();
// {
//   "title": "Meeting",
//   "dueDate": "2024-06-15",
//   "createdAt": "2024-06-01 10:30:00",
//   "completedAt": "2024-06-15T14:00:00.000"
// }
```

---

## Advanced Topics

### Build Workflow

**Development mode (watch):**
```bash
dart run build_runner watch --delete-conflicting-outputs
```

**CI/Release mode:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**After model changes:**
- If you changed annotated models: regenerate
- If models did not change: no manual regeneration needed

### Supported Types

| Type | Notes |
|------|-------|
| `int`, `double`, `String`, `bool`, `dynamic` | Primitives |
| `DateTime`, `DateTime?` | ISO 8601 format |
| `Uri` | String representation |
| `BigInt` | String representation |
| `Duration` | Microseconds |
| `List<T>` | Generic list |
| `Set<T>` | Converted to list on serialization |
| `Map<String, T>` | String keys |
| Enums | By name or index |
| Nested `@Serializable()` | Recursive |

### Error Handling

**Common errors:**

```
Type X is not registered
```
- Run code generation with `build_runner`
- Call `initializeDSerializer()` before use

```
Converter function not found
```
- Ensure `XToJson`/`XFromJson` exist as top-level functions
- Make sure they're visible in the model library scope

```
Custom formatter function not found
```
- Ensure `XFormatToJson`/`XFormatFromJson` exist
- Check function naming matches annotation

```
Unknown field for X: $key
```
- This is expected with `UnknownKeyPolicy.strict`
- Either fix the JSON or change policy to `ignore` or `capture`

---

## Migration Guide

### From `strict: true` to `unknownKeyPolicy`

```dart
// Before
@Serializable(strict: true)
class Model {}

// After
@Serializable(unknownKeyPolicy: UnknownKeyPolicy.strict)
class Model {}
```

### From `json_serializable`

```dart
// json_serializable style
@JsonSerializable()
class User {
  final int id;
  final String name;
}

// d_serializer style
@Serializable()
class User {
  final int id;
  final String name;
  
  User({required this.id, required this.name});
}
```

Key differences:
- No need for `fromJson` factory constructor
- Use `@JsonKey` instead of `@JsonKey(fromJson: ...)`
- Static API via `Serializer.toJson()` instead of `jsonEncode()`

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Type X is not registered` | Run `build_runner` and call `initializeDSerializer()` |
| `Converter function not found` | Ensure `XToJson`/`XFromJson` are top-level functions |
| `Custom formatter not found` | Ensure `XFormatToJson`/`XFormatFromJson` exist |
| `Unknown field` error | Use `UnknownKeyPolicy.ignore` or fix JSON |
| Build fails | Check `@Format` type compatibility |
| Wrong date format | Use correct pattern: `'yyyy-MM-dd'` or `'iso8601'` |

---

## License

MIT

---

## Contributing

Contributions are welcome! Please read the contributing guidelines before submitting PRs.

## Support

- GitHub Issues: https://github.com/torogoz-tech/d_serializer/issues
- Documentation: https://pub.dev/packages/d_serializer