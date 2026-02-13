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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../i18n.dart' show I18n, I18nDelegate;

import 'providers/language_provider.dart';
import 'ui/connection/connection_dialog.dart';
import 'ui/connection/repository/connection_repository.dart'
    show connectionRepositoryProvider;

import 'ui/widgets/language_widget.dart' show AdvancedLanguageSelectorSheet;

/// The root widget of the application.
/// Responsible for setting up the MaterialApp, Theme, and Routing.
class KeyscopeApp extends ConsumerWidget {
  const KeyscopeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(
      languageProvider.select((p) => p.languageCode),
    );

    Locale? locale;
    if (languageCode.contains('_') || languageCode.contains('-')) {
      final parts = languageCode.split(RegExp('[_-]'));
      locale = Locale(parts[0], parts[1]);
    } else {
      locale = Locale(languageCode);
    }

    return MaterialApp(
      title: 'Keyscope',
      debugShowCheckedModeBanner: false,
      // Apply a Dark Theme
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1F22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3574F0), // Keyscope Blue
          surface: Color(0xFF2B2D30),
        ),
        // Set the home screen to a separate widget to ensure a valid Context.
        // Setup Dialog Theme globally
        // dialogTheme: DialogTheme(
        //   backgroundColor: const Color(0xFF2B2D30),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(8)
        //   ),
        // ),
      ),
      home: const HomeScreen(),

      locale: locale,
      localizationsDelegates: [
        const I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: I18nDelegate.supportedLocals, // FYI: typo of thirdparty
    );
  }
}

/// The main screen of the application.
/// This widget is a child of MaterialApp, so it can access
/// MaterialLocalizations.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the injected repository implementation.
    // final repo =
    ref.watch(connectionRepositoryProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Keyscope',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              I18n.of(context).languageTitle,
              style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            // TODO: add ssh tunneling
            // Text('SSH Supported: ${repo.isSshSupported}'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                // repo.connect(host: 'localhost', port: 6379);
                showDialog<Dialog>(
                  context: context,
                  builder: (context) => const ConnectionDialog(),
                );
              },
              child: Text(I18n.of(context).openConnectionManager),
            ),

            // TODO: ThemeCycleIconButton
            IconButton(
              icon: const Icon(Icons.language),
              tooltip: I18n.of(context).changeLanguage,
              onPressed: () async => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const AdvancedLanguageSelectorSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
