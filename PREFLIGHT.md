# Preflight instructions

## Check Dart Formatting

Ensure the code adheres to Dart formatting guidelines.

```sh
dart format .
```

## Analyze Code

Check for static errors, warnings, and lints to ensure code quality and adherence to Dart best practices.

```sh
dart analyze
```

Apply the linter rules

```
dart fix --dry-run
dart fix --apply
```

## Pre-Publish Check

Verify that the package is ready for publishing without actually uploading it.

```sh
dart pub get
dart pub publish --dry-run
```

## Bump to New Version

### Edit pubspec.yaml

Update the `version` field in `pubspec.yaml` to the new version number.

```yaml
# version: 0.1.0  # Previous version
version: 0.2.0   # New version
```

### Commit the Version Bump

Commit the version change with a conventional commit message.

```
build: bump version to 0.2.0
```

## Tag the Release Locally

Create a Git tag corresponding to the new version and push it to the remote repository.

```sh
git tag v0.2.0
git push origin v0.2.0
```

## Create GitHub Release

Create a new release on GitHub. Use the tag you just created (e.g., `v0.2.0`). Copy the relevant section from `CHANGELOG.md` into the release notes.

## Publish to pub.dev

**Final Check:** Before publishing, double-check everything (version number in `pubspec.yaml`, `CHANGELOG.md` entry, successful tests, correct formatting). Ensure no sensitive information is included.

**Publish:** Once you are confident, publish the package to `pub.dev`.

```sh
dart pub publish
```