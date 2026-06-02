# Changelog

All notable changes to this project will be documented in this file.

## [1.2.0] - 2026-06-01

### Added
- Real polymorphic union support with discriminator resolution.
- New `@SerializableUnion(typeField: ...)` annotation for sealed/union roots.
- Runtime union registration API: `Serializer.registerUnion<T>(...)`.
- Runtime decoded-value API: `Serializer.fromDynamic<T>(...)`.
- Runtime encoded-value API: `Serializer.encodeDynamic(...)`.
- New union test coverage (`test/union_test.dart`).

### Changed
- Generator now auto-registers union subtypes for annotated supertypes.
- Generator now writes union discriminator field automatically for subtype payloads.
- Object field generation now uses runtime dynamic encode/decode for polymorphic fields.
- Example now includes `PaymentMethod` union with `CardPayment`/`PaypalPayment`.

## [1.1.5] - 2026-06-01

### Fixed
- Regenerated `example_models.g.dart` with `d_serializer_builder 1.1.4` to remove `unnecessary_cast` warnings in pub.dev static analysis.

## [1.1.4] - 2026-06-01

### Fixed
- Included `lib/example/example_models.g.dart` in the published package.
- Fixed pub.dev analyzer failure (`URI_HAS_NOT_BEEN_GENERATED`) for `example_models.g.dart`.
- Restored platform/support and downgrade-analysis checks by shipping required generated source.

## [1.1.3] - 2026-06-01

### Added
- Typed formatter annotation support: `@Format.customWith(TypeName)`.
- Consolidated complete example model set in `lib/example/example_models.dart`.
- Pub.dev-facing example (`example/example.dart`) now documents model structure, initialization flow, and usage in one place.

### Fixed
- `@Format.date(...)` serialization/deserialization pipeline for generated code.
- Reduced unnecessary casts in generated formatter expressions.
- Export library headers adjusted to avoid dangling doc-comment analysis warnings.

### Changed
- Formatter docs updated to include typed custom formatters.
- Example updated to use `@Format.customWith(TitleCase)`.

## [1.1.2] - 2026-05-30

### Added
- New complete example with semantic project structure under `lib/example/`.
- End-to-end example coverage for:
  - nested models
  - lists, sets, and maps
  - enum fallback (`unknownEnumValue`)
  - `@JsonKey(requiredKey/defaultValue/ignore/converter)`
  - `@Format.trim()` + `@Format.custom('TitleCase')`
  - `@Serializable(strict/naming/typeField/discriminator)`

### Changed
- `example/example.dart` now demonstrates a realistic model graph and production-like usage.
- Analyzer configuration now excludes generated files (`**/*.g.dart`) from warnings.

## [1.1.1] - 2026-05-30

### Fixed
- Example flow now uses generated `initializeDSerializer()` instead of per-model manual registration.
- Packaging configuration cleaned up after local release validation (removed temporary dependency overrides).

### Changed
- Release workflow documentation hardened with a pre-publish checklist.

## [1.1.0] - 2026-05-30

### Added
- New field formatter annotation `@Format(...)`:
  - `trim`, `uppercase`, `lowercase`
  - `date('yyyy-MM-dd')`, `date('iso8601')`
  - `custom('X')` with `XFormatToJson` / `XFormatFromJson`
- Date formatting/parsing helpers:
  - `Serializer.formatDate(...)`
  - `Serializer.parseDate(...)`
- Formatter tests for supported patterns and error paths.

### Changed
- README expanded with formatter matrix, pipeline order, build-time validation rules, and custom formatter contract.

## [1.0.2] - 2026-05-29

### Added
- Static API usage path: `Serializer.toJson<T>()` and `Serializer.fromJson<T>()`.
- Annotation-driven generation with `@Serializable()` and `@JsonKey()`.
- Advanced annotation options:
  - `@Serializable(strict, naming, discriminator, typeField, rename)`
  - `@JsonKey(requiredKey, defaultValue, converter, unknownEnumValue, useEnumIndex)`
- Support for additional types: `Uri`, `BigInt`, `Duration`, `Set<T>`.

### Changed
- Expanded documentation and converter contract.
- Publication metadata alignment and package cleanup.

## [1.0.1] - 2026-05-29

### Added
- Initial static serializer API and registration mechanism.

## [1.0.0] - 2026-05-29

### Added
- Initial release.
