import '../models/money.dart';

Object? MoneyToJson(dynamic value) => (value as Money).cents;

Money MoneyFromJson(dynamic value) => Money((value as num).toInt());
