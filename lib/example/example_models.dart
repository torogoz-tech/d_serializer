// ignore_for_file: non_constant_identifier_names

import 'package:d_serializer/d_serializer.dart';

part 'example_models.g.dart';

// Converts Money values to JSON (integer cents).
Object? MoneyToJson(dynamic value) => (value as Money).cents;

// Converts integer/num JSON values back to Money.
Money MoneyFromJson(dynamic value) => Money((value as num).toInt());

// Custom formatter used by @Format.custom('TitleCase').
String TitleCaseFormatToJson(dynamic value) {
  final String input = (value as String).trim().toLowerCase();
  if (input.isEmpty) {
    return input;
  }
  return '${input[0].toUpperCase()}${input.substring(1)}';
}

// Uses the same normalization for incoming JSON values.
String TitleCaseFormatFromJson(dynamic value) => TitleCaseFormatToJson(value);

// Typed formatter marker used by @Format.customWith(TitleCase).
class TitleCase {
  const TitleCase._();
}

@SerializableUnion(typeField: 'paymentType')
sealed class PaymentMethod {
  const PaymentMethod();
}

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
class PaypalPayment extends PaymentMethod {
  final String email;

  const PaypalPayment({
    required this.email,
  });
}

// Enum used by the sample profile model.
enum UserStatus {
  active,
  blocked,
  pending,
  unknown,
}

// Value object serialized through a custom JsonKey converter.
class Money {
  final int cents;

  const Money(this.cents);
}

// Nested location object.
@Serializable(naming: JsonNaming.snakeCase)
class Geo {
  final double lat;
  final double lng;

  const Geo({
    required this.lat,
    required this.lng,
  });
}

// Address model that embeds Geo.
@Serializable(naming: JsonNaming.snakeCase)
class Address {
  @JsonKey(requiredKey: true)
  final String street;

  @JsonKey(requiredKey: true)
  final String city;

  final Geo geo;

  const Address({
    required this.street,
    required this.city,
    required this.geo,
  });
}

// Main sample model that demonstrates most serializer features.
@Serializable(
  naming: JsonNaming.snakeCase,
  unknownKeyPolicy: UnknownKeyPolicy.strict,
  typeField: 'kind',
  discriminator: 'user_profile',
)
class UserProfile {
  @JsonKey(requiredKey: true)
  final int id;

  @JsonKey(requiredKey: true)
  @Format.trim()
  @Format.customWith(TitleCase)
  final String fullName;

  @JsonKey(defaultValue: true)
  final bool active;

  @JsonKey(unknownEnumValue: 'unknown')
  final UserStatus status;

  @Format.date('yyyy-MM-dd')
  final DateTime birthDate;
  @Format.date('iso8601')
  final DateTime createdAt;

  final List<String> tags;
  final Set<int> scores;
  final Map<String, String> metadata;

  final Address address;

  @JsonKey(converter: 'Money')
  final Money balance;
  final PaymentMethod paymentMethod;

  @JsonKey(ignore: true)
  final String internalToken;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.active,
    required this.status,
    required this.birthDate,
    required this.createdAt,
    required this.tags,
    required this.scores,
    required this.metadata,
    required this.address,
    required this.balance,
    required this.paymentMethod,
    this.internalToken = '',
  });
}
