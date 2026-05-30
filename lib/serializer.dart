import 'dart:convert';

/// Deserializes a map into an instance of `T`.
typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

/// Serializes an instance of `T` into a JSON map.
typedef JsonEncoder<T> = Map<String, dynamic> Function(T value);

/// Static JSON serializer with type registration.
class Serializer {
  static final Map<Type, JsonFactory<dynamic>> _factories =
      <Type, JsonFactory<dynamic>>{};
  static final Map<Type, JsonEncoder<dynamic>> _encoders =
      <Type, JsonEncoder<dynamic>>{};

  /// Registers conversion functions for a specific type.
  static void register<T>({
    required JsonFactory<T> fromJson,
    required JsonEncoder<T> toJson,
  }) {
    _factories[T] = (Map<String, dynamic> json) => fromJson(json);
    _encoders[T] = (dynamic value) => toJson(value as T);
  }

  /// Serializes [value] to JSON text.
  static String toJson<T>(T value) {
    final Object? payload = _encodeValue(value);
    return jsonEncode(payload);
  }

  /// Deserializes JSON text into type [T].
  static T fromJson<T>(String json) {
    final dynamic decoded = jsonDecode(json);

    if (decoded is Map<String, dynamic>) {
      return _decodeMap<T>(decoded);
    }

    if (decoded == null || decoded is num || decoded is bool || decoded is String) {
      return decoded as T;
    }

    throw ArgumentError('Unsupported JSON payload for type $T');
  }

  /// Formats a [DateTime] with a supported [pattern].
  static String formatDate(DateTime value, String pattern) {
    if (pattern == 'yyyy-MM-dd') {
      final String year = value.year.toString().padLeft(4, '0');
      final String month = value.month.toString().padLeft(2, '0');
      final String day = value.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    if (pattern == 'iso8601') {
      return value.toIso8601String();
    }

    throw UnsupportedError('Unsupported date format pattern: $pattern');
  }

  /// Parses a [DateTime] using a supported [pattern].
  static DateTime parseDate(String value, String pattern) {
    if (pattern == 'yyyy-MM-dd') {
      final RegExp regExp = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
      final RegExpMatch? match = regExp.firstMatch(value);
      if (match == null) {
        throw FormatException(
          'Invalid date value for pattern yyyy-MM-dd',
          value,
        );
      }

      final int year = int.parse(match.group(1)!);
      final int month = int.parse(match.group(2)!);
      final int day = int.parse(match.group(3)!);
      return DateTime(year, month, day);
    }

    if (pattern == 'iso8601') {
      return DateTime.parse(value);
    }

    throw UnsupportedError('Unsupported date format pattern: $pattern');
  }

  static T _decodeMap<T>(Map<String, dynamic> json) {
    final JsonFactory<dynamic>? factory = _factories[T];
    if (factory == null) {
      throw StateError(
        'Type $T is not registered. Call Serializer.register<$T>() first.',
      );
    }

    return factory(json) as T;
  }

  static Object? _encodeValue(Object? value) {
    if (value == null || value is num || value is bool || value is String) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is Uri) {
      return value.toString();
    }

    if (value is BigInt) {
      return value.toString();
    }

    if (value is Duration) {
      return value.inMicroseconds;
    }

    if (value is Enum) {
      return value.name;
    }

    if (value is List) {
      return value.map(_encodeValue).toList();
    }

    if (value is Set) {
      return value.map(_encodeValue).toList();
    }

    if (value is Map) {
      return value.map(
        (dynamic key, dynamic item) => MapEntry(key.toString(), _encodeValue(item)),
      );
    }

    final JsonEncoder<dynamic>? encoder = _encoders[value.runtimeType];
    if (encoder == null) {
      throw StateError(
        'Type ${value.runtimeType} is not registered. '
        'Call Serializer.register<${value.runtimeType}>() first.',
      );
    }

    final Map<String, dynamic> json = encoder(value);
    return json.map(
      (String key, dynamic item) => MapEntry(key, _encodeValue(item)),
    );
  }
}
