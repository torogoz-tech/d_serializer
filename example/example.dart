import 'package:d_serializer/d_serializer.dart';
import 'package:d_serializer/d_serializer_registry.g.dart';
import 'package:d_serializer/example/models/address.dart';
import 'package:d_serializer/example/models/geo.dart';
import 'package:d_serializer/example/models/money.dart';
import 'package:d_serializer/example/models/user_profile.dart';
import 'package:d_serializer/example/models/user_status.dart';

void main() {
  initializeDSerializer();

  final UserProfile user = UserProfile(
    id: 42,
    fullName: '   aBnEr vElAsCo   ',
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
      street: 'Av. Siempre Viva',
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
