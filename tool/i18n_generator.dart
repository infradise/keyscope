/*
 * Copyright 2025-2026 Infradise Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Keyscope Multilingual Translator
///
library;

import 'dart:io' show File, exit;

// TODO: check if key is alphanumberic.
//       valueUpdate1 : 1 means '!'
//       deleteKey2 : 2 means '?'

void main() async {
  // 1. Define file paths
  const inputFile = 'assets/i18n.csv';
  const outputFile = 'lib/i18n.dart';

  final file = File(inputFile);
  if (!await file.exists()) {
    print('❌ Error: CSV file not found at $inputFile');
    return;
  }

  // 2. Read file content
  final input = await file.readAsString();

  // 3. Parse CSV manually (No external package dependency)
  final rows = _parseCsv(input);

  if (rows.length < 3) {
    print('❌ Error: CSV file format is invalid (rows < 3).');
    return;
  }

  // 4. Process data
  // Assumes the first row is the header: keys, en, ko, ja, ...
  final headerRow = rows[0].map((e) => e.trim()).toList();

  // The first column is 'keys', so we slice from index 1
  // to get locales. (English at index 1)
  final locales = headerRow.sublist(1); // Exclude 'keys' column

  // Validate English values and process rows
  final keyDataList = _processRows(rows, locales);

  // 5. Generate content
  final buffer = StringBuffer();
  _writeHeader(buffer);
  _writeClass(buffer, keyDataList);
  _writeStaticMaps(buffer, locales, keyDataList);
  _writeConstructorAndHelpers(buffer, locales);
  _writeDelegate(buffer, locales);

  final newContent = buffer.toString();

  // 6. Diff Check & Write
  // Only write to file if content has changed to prevent unnecessary rebuilds.
  final outputFileObj = File(outputFile);
  if (await outputFileObj.exists()) {
    final existingContent = await outputFileObj.readAsString();
    if (existingContent == newContent) {
      print('⚡ No changes detected. Skipping write for $outputFile');
      return;
    }
  }

  await outputFileObj.writeAsString(newContent);
  print('✅ Successfully generated $outputFile (Changes detected)');
}

/// Parses CSV content character by character to handle quotes and newlines
/// correctly.
/// Returns a List of rows, where each row is a List of Strings.
List<List<String>> _parseCsv(String text) {
  final rows = <List<String>>[];
  var currentRow = <String>[];
  final buffer = StringBuffer();
  var inQuote = false;

  // Start from index 1 to skip header
  for (var i = 0; i < text.length; i++) {
    final char = text[i];

    if (inQuote) {
      if (char == '"') {
        // Check for escaped quote ("") in CSV
        if (i + 1 < text.length && text[i + 1] == '"') {
          buffer.write('"');
          i++; // Skip the next quote
        } else {
          inQuote = false;
        }
      } else {
        buffer.write(char);
      }
    } else {
      if (char == '"') {
        inQuote = true;
      } else if (char == ',') {
        currentRow.add(buffer.toString());
        buffer.clear();
      } else if (char == '\n' || char == '\r') {
        // Handle line breaks (CRLF or LF)
        if (char == '\r' && i + 1 < text.length && text[i + 1] == '\n') {
          i++; // Skip \n
        }
        currentRow.add(buffer.toString());
        rows.add(currentRow);
        currentRow = [];
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
  }

  // Add the last row if buffer is not empty
  if (buffer.isNotEmpty || currentRow.isNotEmpty) {
    currentRow.add(buffer.toString());
    rows.add(currentRow);
  }

  return rows;
}

/// Processes parsed CSV rows into structured data.
/// Validates 'en' values and applies fallback.
List<Map<String, dynamic>> _processRows(
  List<List<String>> rows,
  List<String> locales,
) {
  final result = <Map<String, dynamic>>[];

  // Start from index 1 to skip header
  for (var i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;

    final key = row[0].trim();
    if (key.isEmpty) continue;

    // The English value is usually at index 1. We use this to detect arguments.
    //
    // Use English value (index 1) to detect arguments like %name$s
    // Safety check: ensure row has enough columns
    //
    // Based on the format: keys, en, ko, ...
    // English is at index 1.
    final englishValue = row.length > 1 ? row[1] : '';

    // [VALIDATION] English value must exist (mandatory)
    if (englishValue.isEmpty) {
      print('❌ Error: English value is missing for key "$key" (Row ${i + 1}).');
      print('   English is the default language and must be provided.');
      exit(1);
    }

    // Store values for each locale
    final values = <String, String>{};
    for (var j = 0; j < locales.length; j++) {
      // +1 for key column offset
      // +1 because row index 0 is the key
      final val = (j + 1 < row.length) ? row[j + 1] : '';
      values[locales[j]] = val;
    }

    result.add({
      'key': key,
      'args': _extractArgs(englishValue), // e.g., ['name'] for "%name$s"
      'en_value': englishValue, // Store English value separately for fallback
      'values': values,
    });
  }
  return result;
}

/// Extracts arguments from a string format (e.g., "%name$s" -> "name").
/// Returns a list of argument names (e.g., ['name']).
List<String> _extractArgs(String text) {
  // Regex to match pattern %variableName$s
  final regex = RegExp(r'%([a-zA-Z0-9_]+)\$s');
  final matches = regex.allMatches(text);
  if (matches.isEmpty) return [];
  return matches.map((m) => m.group(1)!).toList();
}

/// Writes file headers and imports.
///
/// Writes file headers with split ignore rules to avoid lint errors.
void _writeHeader(StringBuffer buffer) {
  buffer.writeln('''
/*
 * Copyright 2025-2026 Infradise Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
  ''');
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln('//');
  // Split ignores to keep lines under 80 characters
  buffer.writeln(
    '// ignore_for_file: public_member_api_docs, prefer_single_quotes',
  );
  buffer.writeln(
    '// ignore_for_file: avoid_escaping_inner_quotes, prefer_const_constructors',
  );
  buffer.writeln(
    '// ignore_for_file: sort_constructors_first, always_specify_types',
  );
  buffer.writeln('// ignore_for_file: non_constant_identifier_names');
  // buffer.writeln('// ignore_for_file: lines_longer_than_80_chars');
  buffer.writeln();
  buffer.writeln("import 'dart:async';");
  buffer.writeln();
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln();
}

/// Writes the I18n class definition.
///
/// Writes the I18n class and its getters/methods.
void _writeClass(StringBuffer buffer, List<Map<String, dynamic>> keyDataList) {
  // Updated class documentation
  buffer.writeln(
    '/// Auto-generated localization class. Do not edit manually.',
  );
  buffer.writeln('class I18n {');

  // --- Getters & Methods ---
  for (var data in keyDataList) {
    final key = data['key'];
    final args = data['args'] as List<String>;

    if (args.isEmpty) {
      // Simple getter for plain text
      buffer.writeln('  String get $key => _getText("$key");');
    } else {
      // Method for strings with arguments
      // final args = argsStr.split(',');
      final methodArgs = args.map((a) => 'required String $a').join(', ');

      buffer.write('  String $key({$methodArgs}) =>\n');
      buffer.write('      _getText("$key")');
      for (var arg in args) {
        // Replaces %name$s with the variable value
        buffer.write('.replaceAll(r"%$arg\$s", $arg)');
      }
      buffer.writeln(';');
    }
    buffer.writeln();
  }
}

/// Writes static maps for each locale.
///
/// Writes static maps with fallback logic and raw string handling.
/// Fallback: If a value is empty, use English value.
void _writeStaticMaps(
  StringBuffer buffer,
  List<String> locales,
  List<Map<String, dynamic>> keyDataList,
) {
  // --- Static Map Definitions ---
  buffer.writeln('  static late Map<String, String> _localizedValues;');
  buffer.writeln();

  for (var locale in locales) {
    // Convert 'zh_CN' to '_zhCNValues'
    final varName = '_${locale.replaceAll('_', '')}Values';
    buffer.writeln('  static const $varName = {');

    for (var data in keyDataList) {
      final key = data['key'];
      final values = data['values'] as Map<String, String>;
      final englishValue = data['en_value'] as String;

      var val = values[locale] ?? '';

      // [FALLBACK] If value is empty (e.g., translation is missing),
      //            use English value.
      if (val.isEmpty) {
        val = englishValue;
      }

      // Use raw strings (r"...") if the value contains special characters like $ or \
      // This prevents unwanted string interpolation in Dart.
      String quotedValue;
      // Use raw string if special characters exist
      // (checking the final 'val', which might be the English fallback)

      // 1. If value contains '$' or '\', use raw string (r"...")
      //    (e.g., r"Welcome, %name$s!")
      if (val.contains(r'$') || val.contains(r'\')) {
        quotedValue = 'r"$val"';
      } else {
        // val.contains('"')
        // 2. Otherwise use standard string ("...")
        //    Escape double quotes just in case
        quotedValue = '"${val.replaceAll('"', r'\"')}"';
      }

      buffer.writeln('    "$key": $quotedValue,');
    }
    buffer.writeln('  };');
    buffer.writeln();
  }

  // --- All Values Map ---
  // Map linking locales to their value maps
  buffer.writeln('  static const _allValues = {');
  for (var locale in locales) {
    final varName = '_${locale.replaceAll('_', '')}Values';
    buffer.writeln('    "$locale": $varName,');
  }
  buffer.writeln('  };');
  buffer.writeln();
}

/// Writes constructor and helper methods.
///
/// Writes constructor, load method, and helper properties.
void _writeConstructorAndHelpers(StringBuffer buffer, List<String> locales) {
  buffer.writeln(r'''
  I18n(Locale locale) : _locale = locale {
    _localizedValues = {};
  }

  final Locale _locale;

  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, I18n)!;

  String _getText(String key) => _localizedValues[key] ?? '** $key not found';

  Locale get currentLocale => _locale;

  String get currentLanguage => _locale.languageCode;

  static Future<I18n> load(Locale locale) async {
    final translations = I18n(locale);
    _localizedValues = _allValues[locale.toString()]!;
    return translations;
  }
}
''');
}

/// Writes the Delegate class.
///
/// Writes the LocalizationsDelegate class.
void _writeDelegate(StringBuffer buffer, List<String> locales) {
  buffer.writeln('class I18nDelegate extends LocalizationsDelegate<I18n> {');
  buffer.writeln('  const I18nDelegate();');
  buffer.writeln();
  buffer.writeln('  static final Set<Locale> supportedLocals = {');

  for (var locale in locales) {
    if (locale.contains('_')) {
      final parts = locale.split('_');
      // e.g., zh_CN -> Locale('zh', 'CN')
      buffer.writeln("    Locale('${parts[0]}', '${parts[1]}'),");
    } else {
      // e.g., en -> Locale('en')
      buffer.writeln("    Locale('$locale'),");
    }
  }

  buffer.writeln('  };');
  buffer.writeln();
  buffer.writeln('''
  @override
  bool isSupported(Locale locale) => supportedLocals.contains(locale);

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(I18nDelegate old) => false;
}
''');
}
