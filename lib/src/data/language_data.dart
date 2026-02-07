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

class Language {
  final String code;
  final String name;
  final String region;

  const Language(
      {required this.code, required this.name, required this.region});
}

const List<Language> allLanguages = [
  Language(code: 'en', name: 'English', region: 'Global'),
  Language(code: 'ko', name: '한국어', region: 'Asia'),
  Language(code: 'ja', name: '日本語', region: 'Asia'),

  Language(code: 'de', name: 'Deutsch', region: 'Europe'),
  Language(code: 'de_CH', name: 'Schweizerdeutsch', region: 'Europe'),

  Language(code: 'ru', name: 'Русский', region: 'Europe'),
  Language(code: 'fr', name: 'Français', region: 'Europe'),
  Language(code: 'pt_BR', name: 'Português do Brasil', region: 'Europe'),

  // Language(code: 'zh-Hans', name: '简体中文', region: 'Asia'), // It works!
  Language(code: 'zh_CN', name: '简体中文', region: 'Asia'), // It works!

  Language(code: 'it', name: 'Italiano', region: 'Europe'),
  Language(code: 'pt_PT', name: 'Português de Portugal', region: 'Europe'),

  // Language(code: 'zh-Hant', name: '繁體中文', region: 'Asia'), // -- It does not work :(
  Language(code: 'zh_TW', name: '繁體中文', region: 'Asia'), // It works!
  Language(code: 'es', name: 'Español', region: 'Europe'),
  // Language(code: 'ar', name: 'العربية', region: 'Middle East'),
  // Language(code: 'hi', name: 'हिन्दी', region: 'Asia'),
  Language(code: 'id', name: 'Bahasa Indonesia', region: 'Asia'),
  Language(code: 'vi', name: 'Tiếng Việt', region: 'Asia'),
  Language(code: 'th', name: 'ภาษาไทย', region: 'Asia'),
  // Language(code: 'tr', name: 'Türkçe', region: 'Europe'),
  // Language(code: 'nl', name: 'Nederlands', region: 'Europe'),
  // Language(code: 'sv', name: 'Svenska', region: 'Europe'),
  // Language(code: 'fi', name: 'Suomi', region: 'Europe'),
  // Language(code: 'da', name: 'Dansk', region: 'Europe'),
  // Language(code: 'no', name: 'Norsk', region: 'Europe'),
  // Language(code: 'pl', name: 'Polski', region: 'Europe'),
  // Language(code: 'cs', name: 'Čeština', region: 'Europe'),
  // Language(code: 'el', name: 'Ελληνικά', region: 'Europe'),
  // Language(code: 'he', name: 'עברית', region: 'Middle East'),
  // Language(code: 'ms', name: 'Bahasa Melayu', region: 'Asia'),
  // Language(code: 'ro', name: 'Română', region: 'Europe'),
  // Language(code: 'sk', name: 'Slovenčina', region: 'Europe'),
  // Language(code: 'uk', name: 'Українська', region: 'Europe'),
  // Language(code: 'hu', name: 'Magyar', region: 'Europe'),
  // Language(code: 'af', name: 'Afrikaans', region: 'Africa'),
  // Language(code: 'sq', name: 'Shqip', region: 'Europe'),
  // Language(code: 'hy', name: 'Հայերեն', region: 'Asia'),
  // Language(code: 'az', name: 'Azərbaycan dili', region: 'Asia'),
  // Language(code: 'eu', name: 'Euskara', region: 'Europe'),
  // Language(code: 'be', name: 'Беларуская мова', region: 'Europe'),
  // Language(code: 'bn', name: 'বাংলা', region: 'Asia'),
  // Language(code: 'bs', name: 'Bosanski', region: 'Europe'),
  // Language(code: 'bg', name: 'Български език', region: 'Europe'),
  // Language(code: 'ca', name: 'Català', region: 'Europe'),
  // Language(code: 'hr', name: 'Hrvatski jezik', region: 'Europe'),
  // Language(code: 'et', name: 'Eesti', region: 'Europe'),
  // Language(code: 'gl', name: 'Galego', region: 'Europe'),
  // Language(code: 'ka', name: 'ქართული', region: 'Asia'),
  // Language(code: 'is', name: 'Íslenska', region: 'Europe'),
  // Language(code: 'kk', name: 'Қазақ тілі', region: 'Asia'),
  // Language(code: 'km', name: 'ភាសាខ្មែរ', region: 'Asia'),
  // Language(code: 'lt', name: 'Lietuvių kalba', region: 'Europe'),
  // Language(code: 'lv', name: 'Latviešu valoda', region: 'Europe'),
  // Language(code: 'mk', name: 'Македонски јазик', region: 'Europe'),
];
