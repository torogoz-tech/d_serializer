// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'example_models.dart';

// **************************************************************************
// SerializableGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

CardPayment CardPaymentFromJson(Map<String, dynamic> json) {
  if (json['paymentType'] != 'card') {
    throw ArgumentError(
      'Invalid discriminator for CardPayment at paymentType: expected card',
    );
  }
  return CardPayment(
    last4: json['last4'] as String,
    brand: json['brand'] as String,
  );
}

Map<String, dynamic> CardPaymentToJson(CardPayment value) {
  return value.toJson();
}

void registerCardPaymentSerializer() {
  Serializer.register<CardPayment>(
    fromJson: CardPaymentFromJson,
    toJson: CardPaymentToJson,
  );
  Serializer.registerUnion<PaymentMethod>(
    typeField: 'paymentType',
    discriminator: 'card',
    fromJson: (Map<String, dynamic> json) => CardPaymentFromJson(json),
  );
}

extension CardPaymentSerializer on CardPayment {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'paymentType': 'card',
      'last4': last4,
      'brand': brand,
    };
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

PaypalPayment PaypalPaymentFromJson(Map<String, dynamic> json) {
  if (json['paymentType'] != 'paypal') {
    throw ArgumentError(
      'Invalid discriminator for PaypalPayment at paymentType: expected paypal',
    );
  }
  return PaypalPayment(email: json['email'] as String);
}

Map<String, dynamic> PaypalPaymentToJson(PaypalPayment value) {
  return value.toJson();
}

void registerPaypalPaymentSerializer() {
  Serializer.register<PaypalPayment>(
    fromJson: PaypalPaymentFromJson,
    toJson: PaypalPaymentToJson,
  );
  Serializer.registerUnion<PaymentMethod>(
    typeField: 'paymentType',
    discriminator: 'paypal',
    fromJson: (Map<String, dynamic> json) => PaypalPaymentFromJson(json),
  );
}

extension PaypalPaymentSerializer on PaypalPayment {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'paymentType': 'paypal', 'email': email};
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

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
// ignore_for_file: non_constant_identifier_names

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
    geo: Serializer.fromDynamic<Geo>(json['geo']),
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
      'geo': Serializer.encodeDynamic(geo),
    };
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

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
    'paymentMethod',
  };
  for (final String key in json.keys) {
    if (!_allowedKeys.contains(key)) {
      throw ArgumentError('Unknown field for UserProfile: $key');
    }
  }
  return UserProfile(
    id: (json['id'] as num).toInt(),
    fullName: TitleCaseFormatFromJson((json['fullName'] as String).trim()),
    active: json['active'] == null ? true : json['active'] as bool,
    status: UserStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String),
      orElse: () => UserStatus.values.byName('unknown'),
    ),
    birthDate: Serializer.parseDate((json['birthDate']), 'yyyy-MM-dd'),
    createdAt: Serializer.parseDate((json['createdAt']), 'iso8601'),
    tags: (json['tags'] as List).map((e) => e as String).toList(),
    scores: ((json['scores'] as List).map((e) => (e as num).toInt())).toSet(),
    metadata: (json['metadata'] as Map).map(
      (k, v) => MapEntry(k.toString(), v as String),
    ),
    address: Serializer.fromDynamic<Address>(json['address']),
    balance: MoneyFromJson(json['balance']),
    paymentMethod: Serializer.fromDynamic<PaymentMethod>(json['paymentMethod']),
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
      'fullName': TitleCaseFormatToJson((fullName).trim()),
      'active': active,
      'status': status.name,
      'birthDate': Serializer.formatDate((birthDate), 'yyyy-MM-dd'),
      'createdAt': Serializer.formatDate((createdAt), 'iso8601'),
      'tags': (tags as List).map((e) => e).toList(),
      'scores': (scores as Set).map((e) => e).toList(),
      'metadata': (metadata as Map).map((k, v) => MapEntry(k.toString(), v)),
      'address': Serializer.encodeDynamic(address),
      'balance': MoneyToJson(balance),
      'paymentMethod': Serializer.encodeDynamic(paymentMethod),
    };
  }
}
