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

import 'dart:convert';
// import 'dart:typed_data';

/// Enum to define how the data should be displayed in the UI.
enum ContentType {
  text, // Use Text Viewer
  binary, // Use Hex Viewer
  json, // Use JSON Viewer
}

class ContentAnalyzer {
  final String content;
  ContentAnalyzer(this.content);

  /// Analyzes raw bytes and returns the appropriate content type.
  static ContentType analyze(List<int> bytes) {
    // 1. Treat empty data as text.
    if (bytes.isEmpty) return ContentType.text;

    // 2. Check for Null Byte (0x00).
    // This is a strong indicator of binary data (e.g., Bitmap, images,
    // compression).
    // Null bytes rarely appear in the middle of standard text files.
    if (bytes.contains(0)) {
      return ContentType.binary;
    }

    // 3. Attempt UTF-8 decoding.
    try {
      // Set 'allowMalformed: false' to throw an exception if
      // any invalid byte sequence is found.
      // This ensures we strictly identify binary data that isn't valid UTF-8
      // (like 0x80 in BITMAPs).
      final text = utf8.decode(bytes, allowMalformed: false);

      // (Optional) Check if the decoded text is valid JSON.
      if (_isJson(text)) return ContentType.json;

      return ContentType.text;
    } catch (e) {
      // Decoding failed (FormatException) -> Treat as Binary.
      return ContentType.binary;
    }
  }

  /// Helper to check if a string is a valid JSON object or array.
  static bool _isJson(String text) {
    text = text.trim();
    // Quick check for JSON brackets before attempting full decode
    if ((text.startsWith('{') && text.endsWith('}')) ||
        (text.startsWith('[') && text.endsWith(']'))) {
      try {
        jsonDecode(text);
        return true;
      } catch (_) {
        // Not valid JSON
      }
    }
    return false;
  }
}
