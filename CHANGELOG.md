# Changelog

All notable changes to this project will be documented in this file.

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
