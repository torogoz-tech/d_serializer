/// Policy for handling unknown keys during deserialization.
enum UnknownKeyPolicy {
  /// Throws an error if unknown keys are present.
  strict,

  /// Ignores unknown keys silently.
  ignore,

  /// Captures unknown keys in an `extra` field.
  capture,
}

/// Naming policy applied to generated JSON keys.
enum JsonNaming {
  /// Keep field names as-is.
  none,

  /// Convert field names from `camelCase` to `snake_case`.
  snakeCase,
}

/// Marks a class as serializable by `d_serializer_builder`.
class Serializable {
  /// Optional alias used as discriminator fallback.
  final String? rename;

  /// Explicit discriminator value used for polymorphic payloads.
  final String? discriminator;

  /// JSON field name used to store/read the discriminator.
  final String? typeField;

  /// Policy for handling unknown keys during deserialization.
  /// - `strict`: throws error on unknown keys (legacy behavior when strict: true)
  /// - `ignore`: ignores unknown keys
  /// - `capture`: stores unknown keys in the `extra` field
  final UnknownKeyPolicy unknownKeyPolicy;

  /// Global naming strategy for fields in this class.
  final JsonNaming naming;

  const Serializable({
    this.rename,
    this.discriminator,
    this.typeField,
    this.unknownKeyPolicy = UnknownKeyPolicy.ignore,
    this.naming = JsonNaming.none,
  });
}

const serializable = Serializable();

/// Marks a base type as a polymorphic union root.
///
/// Use with `sealed class` to enable discriminated union serialization.
///
/// Example:
/// ```dart
/// @SerializableUnion(typeField: 'type')
/// sealed class PaymentMethod {}
///
/// @Serializable(discriminator: 'card')
/// class CardPayment extends PaymentMethod {
///   final String last4;
///   CardPayment({required this.last4});
/// }
///
/// @Serializable(discriminator: 'paypal')
/// class PaypalPayment extends PaymentMethod {
///   final String email;
///   PaypalPayment({required this.email});
/// }
/// ```
///
/// When generated, `Serializer.fromJson<PaymentMethod>(json)` will automatically
/// resolve the correct subtype based on the discriminator value.
class SerializableUnion {
  /// JSON field name that stores the discriminator value.
  /// Defaults to 'type' if not specified.
  final String typeField;

  const SerializableUnion({this.typeField = 'type'});
}

/// Field-level serialization customizations.
class JsonKey {
  /// Override for the generated JSON key.
  final String? name;

  /// Excludes this field from generated serialization.
  final bool ignore;

  /// Default value used when the input key is missing or null.
  final dynamic defaultValue;

  /// Prefix for top-level converter functions: `XToJson` / `XFromJson`.
  final String? converter;

  /// Encodes enums by index instead of enum name.
  final bool useEnumIndex;

  /// Requires the key to be present and non-null during deserialization.
  final bool requiredKey;

  /// Enum value name used when an unknown enum input is received.
  final String? unknownEnumValue;

  const JsonKey({
    this.name,
    this.ignore = false,
    this.defaultValue,
    this.converter,
    this.useEnumIndex = false,
    this.requiredKey = false,
    this.unknownEnumValue,
  });
}

/// Field-level formatter configuration.
class Format {
  /// Formatter kind identifier used by codegen.
  final String kind;

  /// Optional formatter pattern, for example date patterns.
  final String? pattern;

  /// Optional formatter type for typed custom formatters.
  final Type? formatterType;

  const Format._(this.kind, {this.pattern, this.formatterType});

  /// Trims leading and trailing whitespace.
  const Format.trim() : this._('trim');

  /// Converts string values to uppercase.
  const Format.uppercase() : this._('uppercase');

  /// Converts string values to lowercase.
  const Format.lowercase() : this._('lowercase');

  /// Formats dates using a supported pattern.
  const Format.date(String pattern) : this._('date', pattern: pattern);

  /// Uses custom formatter functions:
  /// `XFormatToJson` and `XFormatFromJson`.
  const Format.custom(String name) : this._('custom', pattern: name);

  /// Uses typed custom formatter functions:
  /// `TypeNameFormatToJson` and `TypeNameFormatFromJson`.
  const Format.customWith(Type formatterType)
      : this._('customWith', formatterType: formatterType);
}