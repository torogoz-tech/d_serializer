# Changelog

All notable changes to this project will be documented in this file.

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
