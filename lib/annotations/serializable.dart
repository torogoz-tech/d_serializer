/// Marks a class as serializable by `d_serializer_builder`.
class Serializable {
  /// Optional alias used as discriminator fallback.
  final String? rename;

  /// Explicit discriminator value used for polymorphic payloads.
  final String? discriminator;

  /// JSON field name used to store/read the discriminator.
  final String? typeField;

  /// Enables strict deserialization for unknown keys.
  final bool strict;

  /// Global naming strategy for fields in this class.
  final JsonNaming naming;

  const Serializable({
    this.rename,
    this.discriminator,
    this.typeField,
    this.strict = false,
    this.naming = JsonNaming.none,
  });
}

const serializable = Serializable();

/// Naming policy applied to generated JSON keys.
enum JsonNaming {
  /// Keep field names as-is.
  none,

  /// Convert field names from `camelCase` to `snake_case`.
  snakeCase,
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
