import 'package:d_serializer/d_serializer.dart';

import 'geo.dart';

part 'address.g.dart';

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
