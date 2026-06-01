import 'package:d_serializer/d_serializer.dart';
import 'package:d_serializer/d_serializer_registry.g.dart';
import 'package:d_serializer/example/example_models.dart';

// NOTE:
// This file is the public sample shown on pub.dev.
// Build-time generated serializers are created from models under `lib/`.
// For that reason, the executable model definitions live in:
// `lib/example/example_models.dart`.
//
// Full model reference used by this example:
//
// enum UserStatus { active, blocked, pending, unknown }
//
// class Money {
//   final int cents;
//   const Money(this.cents);
// }
//
// @Serializable(naming: JsonNaming.snakeCase)
// class Geo {
//   final double lat;
//   final double lng;
//   const Geo({required this.lat, required this.lng});
// }
//
// @Serializable(naming: JsonNaming.snakeCase)
// class Address {
//   @JsonKey(requiredKey: true)
//   final String street;
//   @JsonKey(requiredKey: true)
//   final String city;
//   final Geo geo;
//   const Address({required this.street, required this.city, required this.geo});
// }
//
// @Serializable(
//   naming: JsonNaming.snakeCase,
//   strict: true,
//   typeField: 'kind',
//   discriminator: 'user_profile',
// )
// class UserProfile {
//   @JsonKey(requiredKey: true)
//   final int id;
//   @JsonKey(requiredKey: true)
//   @Format.trim()
//   @Format.customWith(TitleCase)
//   final String fullName;
//   @JsonKey(defaultValue: true)
//   final bool active;
//   @JsonKey(unknownEnumValue: 'unknown')
//   final UserStatus status;
//   @Format.date('yyyy-MM-dd')
//   final DateTime birthDate;
//   @Format.date('iso8601')
//   final DateTime createdAt;
//   final List<String> tags;
//   final Set<int> scores;
//   final Map<String, String> metadata;
//   final Address address;
//   @JsonKey(converter: 'Money')
//   final Money balance;
//   @JsonKey(ignore: true)
//   final String internalToken;
//   const UserProfile({...});
// }


void main() {
  // Global generated initializer (recommended startup pattern).
  initializeDSerializer();

  final UserProfile user = UserProfile(
    id: 42,
    fullName: '   jAnE sMiTh   ',
    active: true,
    status: UserStatus.active,
    birthDate: DateTime(1994, 10, 12),
    createdAt: DateTime.parse('2026-05-30T10:30:00Z'),
    tags: <String>['dart', 'flutter', 'api'],
    scores: <int>{100, 95, 98},
    metadata: <String, String>{
      'team': 'platform',
      'country': 'SV',
    },
    address: const Address(
      street: 'Always Alive Ave',
      city: 'San Salvador',
      geo: Geo(lat: 13.6929, lng: -89.2182),
    ),
    balance: const Money(259900),
    internalToken: 'secret-not-serialized',
  );

  final String json = Serializer.toJson<UserProfile>(user);
  final UserProfile restored = Serializer.fromJson<UserProfile>(json);

  print('JSON => $json');
  print('Restored => ${restored.fullName} | ${restored.status.name}');
  print('Birth => ${restored.birthDate.toIso8601String()}');
  print('Balance(cents) => ${restored.balance.cents}');
}
