## 🌐 Translations

### Internationalization (i18n)

Keyscope provides multilingual support through the `assets/i18n.csv` file.  

This file defines translation keys and maps them to localized values across multiple languages (English, Korean, Japanese, Chinese, Indonesian, Vietnamese, Thai, German, French, Italian, Spanish, Russian, Portuguese, etc.).

Each row defines a translation key (e.g., `welcome`, `languageTitle`) and its corresponding localized strings. 
For example:

- `welcome` → "Welcome %name$s!" in English, "%name$s님, 환영합니다!" in Korean, "ようこそ、%name$sさん！" in Japanese, etc.

During the build process, this CSV is compiled into `lib/i18n.dart`, ensuring that Keyscope can dynamically render UI text in the user’s preferred language.

### Language Order

The columns in `assets/i18n.csv` follow this order:

```
keys,en,ko,ja,zh_CN,zh_TW,id,vi,th,de,de_CH,fr,it,es,ru,pt_PT,pt_BR
```

For instance, the `languageTitle` row maps each language name to its localized form:

```
languageTitle,English,한국어,日本語,简体中文,繁體中文,Bahasa Indonesia,Tiếng Việt,ภาษาไทย,Deutsch,Schweizerdeutsch,Français,Italiano,Español,Русский,Português (Portugal),Português (Brasil)
```

