# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-05-29

### Added
- Initial release
- `@Serializable()` annotation for classes
- `@JsonKey()` annotation for field customization
- Support for primitives: int, double, String, bool
- Support for DateTime (ISO8601 serialization)
- Support for List and nested objects
- Support for Map
- Support for enums (name and index)
- Invisible code generation (`part of`)
- Extension method `toJson()` on serialized classes
- Generated `_$ClassNameFromJson()` functions
