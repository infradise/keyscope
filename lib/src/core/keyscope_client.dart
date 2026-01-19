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

/// Pure Dart Client Logic
/// No Flutter dependencies allowed here.
library;

import 'package:valkey_client/valkey_client.dart';

class ScanResult {
  final String cursor;
  final List<String> keys;
  ScanResult(this.cursor, this.keys);
}

class KeyscopeClient {
  ValkeyClient? _client;

  bool get isConnected => _client != null;

  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  }) async {
    // Pure Dart logic using valkey_client
    final newClient = ValkeyClient(
      host: host,
      port: port,
      username: username,
      password: password,
      connectTimeout: const Duration(seconds: 5),
      commandTimeout: const Duration(seconds: 5),
    );

    await newClient.connect();
    _client = newClient;
  }

  // TODO: Same with `ui`. Need to dedup and use valkey_client.
  Future<ScanResult> scanKeys({
    required String cursor,
    String match = '*',
    int count = 100,
  }) async {
    if (_client == null) throw Exception('Not connected');

    try {
      // Execute SCAN command: SCAN <cursor> MATCH <pattern> COUNT <count>
      final result = await _client!
          .execute(['SCAN', cursor, 'MATCH', match, 'COUNT', count.toString()]);
      // TODO: add these to valkey_client

      // Result is typically a list: [nextCursor, [key1, key2, ...]]
      if (result is List && result.length == 2) {
        final nextCursor = result[0].toString();
        final rawKeys = result[1];

        var keys = <String>[];
        if (rawKeys is List) {
          keys = rawKeys.map((e) => e.toString()).toList();
        }

        return ScanResult(nextCursor, keys);
      } else {
        throw Exception('Unexpected SCAN response format');
      }
    } catch (e) {
      print('❌ [OSS] Failed to SCAN keys: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _client?.close();
    _client = null;
  }
}
