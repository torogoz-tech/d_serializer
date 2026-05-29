# d_serializer

Serializacion JSON con API estatica tipo `System.Text.Json` y soporte por anotaciones.

## API

- `Serializer.toJson<T>(value)`
- `Serializer.fromJson<T>(json)`

## Flujo

1. Anota modelos con `@Serializable()`.
2. Ejecuta generacion:

```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Inicializa una sola vez:

```dart
import 'd_serializer_registry.g.dart';

void main() {
  initializeDSerializer();
}
```

## ¿Siempre hay que correr build?

No en cada run.

- Si cambias/agregas modelos anotados: si debes regenerar.
- Si no cambias modelos: no hace falta regenerar manualmente.

Desarrollo recomendado:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

CI/release:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Archivos generados

- `*.g.dart`: mapeo por modelo (to/from + registro por tipo)
- `d_serializer_registry.g.dart`: inicializacion central (`initializeDSerializer`)

No se editan manualmente.

## Anotaciones

### Clase

```dart
@Serializable(
  rename: 'AliasOpcional',
  discriminator: 'order',
  typeField: 'type',
  strict: true,
  naming: JsonNaming.snakeCase,
)
```

- `rename`: alias de clase (tambien se usa como discriminador por defecto)
- `discriminator`: valor de discriminador esperado/escrito
- `typeField`: nombre del campo discriminador en JSON
- `strict`: falla si vienen keys desconocidas
- `naming`: estrategia de nombres (`none`, `snakeCase`)

### Campo

```dart
@JsonKey(
  name: 'custom_name',
  ignore: false,
  defaultValue: 0,
  converter: 'Money',
  useEnumIndex: false,
  requiredKey: true,
  unknownEnumValue: 'unknown',
)
```

- `defaultValue`: aplica cuando el valor viene `null`/ausente
- `converter`: prefijo de funciones converter
- `requiredKey`: obliga presencia del campo
- `unknownEnumValue`: fallback por nombre para enums

## Converter custom

No se registra en `Serializer`; se declara como funciones top-level visibles por la libreria del modelo.

```dart
class Money {
  final int cents;
  const Money(this.cents);
}

Object? MoneyToJson(dynamic value) => (value as Money).cents;
Money MoneyFromJson(dynamic value) => Money((value as num).toInt());

@Serializable()
class Invoice {
  @JsonKey(converter: 'Money')
  final Money total;

  Invoice({required this.total});
}
```

## Ejemplo completo

```dart
import 'package:d_serializer/d_serializer.dart';
import 'd_serializer_registry.g.dart';

part 'invoice.g.dart';

enum Status { active, unknown }

class Money {
  final int cents;
  const Money(this.cents);
}

Object? MoneyToJson(dynamic value) => (value as Money).cents;
Money MoneyFromJson(dynamic value) => Money((value as num).toInt());

@Serializable(strict: true, naming: JsonNaming.snakeCase, typeField: 'kind', discriminator: 'invoice')
class Invoice {
  @JsonKey(requiredKey: true)
  final int id;

  @JsonKey(defaultValue: true)
  final bool enabled;

  @JsonKey(converter: 'Money')
  final Money total;

  @JsonKey(unknownEnumValue: 'unknown')
  final Status status;

  final Uri endpoint;
  final BigInt reference;
  final Duration timeout;
  final Set<String> tags;

  Invoice({
    required this.id,
    required this.enabled,
    required this.total,
    required this.status,
    required this.endpoint,
    required this.reference,
    required this.timeout,
    required this.tags,
  });
}

void main() {
  initializeDSerializer();

  final invoice = Invoice(
    id: 10,
    enabled: true,
    total: const Money(1500),
    status: Status.active,
    endpoint: Uri.parse('https://api.example.com'),
    reference: BigInt.parse('12345678901234567890'),
    timeout: const Duration(seconds: 5),
    tags: <String>{'vip'},
  );

  final String json = Serializer.toJson<Invoice>(invoice);
  final Invoice restored = Serializer.fromJson<Invoice>(json);

  print(json);
  print(restored.total.cents);
}
```

## Tipos soportados

- `int`, `double`, `String`, `bool`, `dynamic`
- `DateTime`, `Uri`, `BigInt`, `Duration`
- `List<T>`, `Set<T>`, `Map<String, T>`
- `enum` (por nombre o indice)
- modelos anidados `@Serializable()`

## Troubleshooting

- `Type X is not registered`:
  - corre `build_runner`
  - llama `initializeDSerializer()` al inicio
- converter no encontrado:
  - define `XToJson` y `XFromJson` top-level y visibles
- campos desconocidos con `strict: true`:
  - revisa payload o desactiva strict
