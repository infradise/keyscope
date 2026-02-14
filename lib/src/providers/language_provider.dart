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

import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import 'package:keyscope/repositories/language_repository.dart';

import '../data/language_data.dart';

class LanguageRepository with ChangeNotifier {
  String _languageCode = 'en';
  final Queue<Language> _recentLanguages = Queue();

  String get languageCode => _languageCode;
  List<Language> get recentLanguages => _recentLanguages.toList();

  Language get currentLanguage => allLanguages.firstWhere(
        (lang) => lang.code == _languageCode,
        orElse: () => allLanguages.first,
      );

  void changeLanguage(String newCode) {
    if (_languageCode != newCode) {
      _languageCode = newCode;

      final newLang = allLanguages.firstWhere((lang) => lang.code == newCode);
      _recentLanguages.removeWhere((lang) => lang.code == newCode);
      _recentLanguages.addFirst(newLang);
      if (_recentLanguages.length > 3) {
        _recentLanguages.removeLast();
      }

      notifyListeners();
    }
  }
}

final languageProvider = ChangeNotifierProvider<LanguageRepository>(
  (ref) => LanguageRepository(),
);
