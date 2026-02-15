## 🔨 Build

To build **Keyscope**, you need to generate the `i18n.dart` file first.

This can be done by running:

```sh
dart run setup.dart
```

Alternatively, you can use the dedicated i18n generator:

```sh
dart run tool/i18n_generator.dart
```

The i18n generator compiles all translation resources into `lib/i18n.dart`, ensuring proper multi-language support.  
This file is required for a successful build.
