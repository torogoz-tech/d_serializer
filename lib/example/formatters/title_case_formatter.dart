String TitleCaseFormatToJson(dynamic value) {
  final String input = (value as String).trim().toLowerCase();
  if (input.isEmpty) {
    return input;
  }
  return '${input[0].toUpperCase()}${input.substring(1)}';
}

String TitleCaseFormatFromJson(dynamic value) => TitleCaseFormatToJson(value);
