import 'package:d_serializer/d_serializer.dart';

import '../formatters/money_converter.dart';
import '../formatters/title_case_formatter.dart';
import 'address.dart';
import 'money.dart';
import 'user_status.dart';

part 'user_profile.g.dart';

@Serializable(
  naming: JsonNaming.snakeCase,
  strict: true,
  typeField: 'kind',
  discriminator: 'user_profile',
)
class UserProfile {
  @JsonKey(requiredKey: true)
  final int id;

  @JsonKey(requiredKey: true)
  @Format.trim()
  @Format.custom('TitleCase')
  final String fullName;

  @JsonKey(defaultValue: true)
  final bool active;

  @JsonKey(unknownEnumValue: 'unknown')
  final UserStatus status;

  final DateTime birthDate;

  final DateTime createdAt;

  final List<String> tags;
  final Set<int> scores;
  final Map<String, String> metadata;
  final Address address;

  @JsonKey(converter: 'Money')
  final Money balance;

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
    this.internalToken = '',
  });
}
