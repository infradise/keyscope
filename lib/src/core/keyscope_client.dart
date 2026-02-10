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

import 'package:keyscope_client/keyscope_client.dart' as engine;

class KeyscopeClient {
  engine.KeyscopeClient? _client;

  bool get isConnected => _client != null;

  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  }) async {
    final newClient = engine.KeyscopeClient(
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

  Future<engine.ScanResult> scanKeys({
    required String cursor,
    String match = '*',
    int count = 100,
  }) async {
    if (_client == null) throw Exception('Not connected');
    return _client!.scanCli(cursor: cursor, match: match, count: count);
  }

  Future<void> disconnect() async {
    await _client?.close();
    _client = null;
  }
}
