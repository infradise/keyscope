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

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // TODO: update riverpod legacy to latest
import '../../connection/repository/connection_repository.dart';
// import '../../../core/keyscope_client.dart'; // For ScanResult

/// State for the Key Browser
class KeyBrowserState {
  final bool isLoading;
  final List<String> keys;
  final String
      cursor; // '0' means end of iteration if we started from 0 and came back
  final String matchPattern;
  final Object? error;

  KeyBrowserState({
    this.isLoading = false,
    this.keys = const [],
    this.cursor = '0',
    this.matchPattern = '*',
    this.error,
  });

  KeyBrowserState copyWith({
    bool? isLoading,
    List<String>? keys,
    String? cursor,
    String? matchPattern,
    Object? error,
  }) =>
      KeyBrowserState(
        isLoading: isLoading ?? this.isLoading,
        keys: keys ?? this.keys,
        cursor: cursor ?? this.cursor,
        matchPattern: matchPattern ?? this.matchPattern,
        error: error, // Clear error if not provided
      );
}

/// Controller for SCAN operations
class KeyBrowserController extends StateNotifier<KeyBrowserState> {
  final ConnectionRepository _repository;

  KeyBrowserController(this._repository) : super(KeyBrowserState());

  /// Initial load or refresh
  Future<void> refresh({String pattern = '*'}) async {
    state = KeyBrowserState(isLoading: true, matchPattern: pattern);
    try {
      // Start from cursor 0
      final result = await _repository.scanKeys(
        cursor: '0',
        match: pattern,
        count: 50,
      );
      // TODO: add this to user-defined preferences

      state = state.copyWith(
        isLoading: false,
        keys: result.keys,
        cursor: result.cursor,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Load more keys (Infinite Scroll)
  Future<void> loadMore() async {
    // If cursor is '0' (and we already have data), scan is complete.
    if (state.cursor == '0' && state.keys.isNotEmpty) return;
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.scanKeys(
        cursor: state.cursor,
        match: state.matchPattern,
        count: 50,
      );

      state = state.copyWith(
        isLoading: false,
        keys: [...state.keys, ...result.keys], // Append keys
        cursor: result.cursor,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final keyBrowserProvider =
    StateNotifierProvider<KeyBrowserController, KeyBrowserState>((ref) {
  final repo = ref.watch(connectionRepositoryProvider);
  return KeyBrowserController(repo);
});
