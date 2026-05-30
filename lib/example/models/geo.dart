import 'package:d_serializer/d_serializer.dart';

part 'geo.g.dart';

@Serializable(naming: JsonNaming.snakeCase)
class Geo {
  final double lat;
  final double lng;

  const Geo({
    required this.lat,
    required this.lng,
  });
}
