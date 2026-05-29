class Serializable {
  final String? rename;
  final String? discriminator;
  final String? typeField;

  const Serializable({
    this.rename,
    this.discriminator,
    this.typeField,
  });
}

const serializable = Serializable();

class JsonKey {
  final String? name;
  final bool ignore;
  final dynamic defaultValue;
  final String? converter;
  final bool useEnumIndex;

  const JsonKey({
    this.name,
    this.ignore = false,
    this.defaultValue,
    this.converter,
    this.useEnumIndex = false,
  });
}
