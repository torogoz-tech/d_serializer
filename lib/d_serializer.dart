export 'annotations/annotations.dart';

mixin SerializableMixin {
  Map<String, dynamic> toJson();
}

class Serializer {
  static String encode(Object? obj) {
    return _encode(obj).toString();
  }

  static Map<String, dynamic>? toJson(Object? obj) {
    if (obj == null) return null;
    return _encode(obj) as Map<String, dynamic>;
  }

  static T fromJson<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonFn) {
    return fromJsonFn(json);
  }

  static dynamic _encode(Object? obj) {
    if (obj == null) return null;
    if (obj is num || obj is bool || obj is String) return obj;
    if (obj is List) return obj.map((e) => _encode(e)).toList();
    if (obj is Map) return obj.map((k, v) => MapEntry(k.toString(), _encode(v)));
    if (obj is DateTime) return obj.toIso8601String();
    if (obj is Uri) return obj.toString();
    if (obj is BigInt) return obj.toString();
    if (obj is Duration) return obj.toString();
    if (obj is RegExp) return obj.pattern;
    if (obj is Set) return obj.map((e) => _encode(e)).toList();
    if (obj is Enum) return obj.name;
    if (obj is Map<String, dynamic>) return obj;
    return (obj as dynamic).toJson();
  }
}
