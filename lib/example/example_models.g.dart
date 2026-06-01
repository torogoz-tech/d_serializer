// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'example_models.dart';

// **************************************************************************
// SerializableGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

Geo GeoFromJson(Map<String, dynamic> json) {
  return Geo(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );
}

Map<String, dynamic> GeoToJson(Geo value) {
  return value.toJson();
}

void registerGeoSerializer() {
  Serializer.register<Geo>(fromJson: GeoFromJson, toJson: GeoToJson);
}

extension GeoSerializer on Geo {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'lat': lat, 'lng': lng};
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

Address AddressFromJson(Map<String, dynamic> json) {
  if (!json.containsKey('street') || json['street'] == null) {
    throw ArgumentError('Missing required field Address.street (street)');
  }
  if (!json.containsKey('city') || json['city'] == null) {
    throw ArgumentError('Missing required field Address.city (city)');
  }
  return Address(
    street: json['street'] as String,
    city: json['city'] as String,
    geo: GeoFromJson(json['geo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> AddressToJson(Address value) {
  return value.toJson();
}

void registerAddressSerializer() {
  Serializer.register<Address>(
    fromJson: AddressFromJson,
    toJson: AddressToJson,
  );
}

extension AddressSerializer on Address {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'street': street,
      'city': city,
      'geo': geo.toJson(),
    };
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

UserProfile UserProfileFromJson(Map<String, dynamic> json) {
  if (json['kind'] != 'user_profile') {
    throw ArgumentError(
      'Invalid discriminator for UserProfile at kind: expected user_profile',
    );
  }
  if (!json.containsKey('id') || json['id'] == null) {
    throw ArgumentError('Missing required field UserProfile.id (id)');
  }
  if (!json.containsKey('fullName') || json['fullName'] == null) {
    throw ArgumentError(
      'Missing required field UserProfile.fullName (fullName)',
    );
  }
  const Set<String> _allowedKeys = <String>{
    'kind',
    'id',
    'fullName',
    'active',
    'status',
    'birthDate',
    'createdAt',
    'tags',
    'scores',
    'metadata',
    'address',
    'balance',
  };
  for (final String key in json.keys) {
    if (!_allowedKeys.contains(key)) {
      throw ArgumentError('Unknown field for UserProfile: $key');
    }
  }
  return UserProfile(
    id: (json['id'] as num).toInt(),
    fullName: ((json['fullName'] as String) as String).trim(),
    active: json['active'] == null ? true : json['active'] as bool,
    status: UserStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String),
      orElse: () => UserStatus.values.byName('unknown'),
    ),
    birthDate: Serializer.parseDate(
      ((DateTime.parse(json['birthDate'] as String)) as String),
      'yyyy-MM-dd',
    ),
    createdAt: Serializer.parseDate(
      ((DateTime.parse(json['createdAt'] as String)) as String),
      'iso8601',
    ),
    tags: (json['tags'] as List).map((e) => e as String).toList(),
    scores: ((json['scores'] as List).map((e) => (e as num).toInt())).toSet(),
    metadata: (json['metadata'] as Map).map(
      (k, v) => MapEntry(k.toString(), v as String),
    ),
    address: AddressFromJson(json['address'] as Map<String, dynamic>),
    balance: MoneyFromJson(json['balance']),
  );
}

Map<String, dynamic> UserProfileToJson(UserProfile value) {
  return value.toJson();
}

void registerUserProfileSerializer() {
  Serializer.register<UserProfile>(
    fromJson: UserProfileFromJson,
    toJson: UserProfileToJson,
  );
}

extension UserProfileSerializer on UserProfile {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kind': 'user_profile',
      'id': id,
      'fullName': ((fullName) as String).trim(),
      'active': active,
      'status': status.name,
      'birthDate': Serializer.formatDate(
        ((birthDate.toIso8601String()) as DateTime),
        'yyyy-MM-dd',
      ),
      'createdAt': Serializer.formatDate(
        ((createdAt.toIso8601String()) as DateTime),
        'iso8601',
      ),
      'tags': (tags as List).map((e) => e).toList(),
      'scores': (scores as Set).map((e) => e).toList(),
      'metadata': (metadata as Map).map((k, v) => MapEntry(k.toString(), v)),
      'address': address.toJson(),
      'balance': MoneyToJson(balance),
    };
  }
}
