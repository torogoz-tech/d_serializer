# Publishing Checklist (d_serializer)

Use this checklist before every `pub.dev` release.

1. Versioning
- Bump `pubspec.yaml` version using semver.
- Add the new version entry in `CHANGELOG.md`.

2. Documentation
- README in English is updated and examples still match generated behavior.
- Any new annotations/options are documented with examples.

3. Codegen and examples
- Run code generation:
  - `dart run build_runner build --delete-conflicting-outputs`
- Verify example uses `initializeDSerializer()` where applicable.

4. Quality gates
- `dart analyze`
- `dart test`

5. Publishing safety
- No temporary `dependency_overrides` left in `pubspec.yaml`.
- Run `dart pub publish --dry-run` and fix warnings when possible.

6. Git flow
- Commit changes.
- Push to GitHub.
- Publish to pub.dev only after push.
