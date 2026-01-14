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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valkey_client/valkey_client.dart';

/// Abstract class defining the contract for connection operations.
///
/// This repository handles the low-level connection logic to Redis/Valkey servers.
abstract class ConnectionRepository {
  /// The active client instance.
  /// Returns [ValkeyClient] or null if not connected.
  ValkeyClient? get client;

  /// Establishes a connection to the specified host and port.
  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  });

  /// Fetches server information using the INFO command.
  Future<Map<String, String>> getInfo();

  /// Closes the current connection.
  Future<void> disconnect();

  /// Indicates whether SSH Tunneling is supported.
  bool get isSshSupported;
}

/// [OSS Version] Default implementation of ConnectionRepository (valkey_client)
///
/// This implementation provides basic connectivity without advanced Enterprise
/// features like SSH Tunneling or dedicated support.
class BasicConnectionRepository implements ConnectionRepository {
  ValkeyClient? _client;

  @override
  ValkeyClient? get client => _client;

  @override
  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  }) async {
    print('🔌 [OSS] Connecting to $host:$port using valkey_client...');

    // valkey_client supports 3 authentication modes via settings:
    // - No Auth
    // - Password only (Legacy)
    // - Username + Password (ACL)
    final newClient = ValkeyClient(
      host: host,
      port: port,
      username: username,
      password: password,
      connectTimeout: const Duration(seconds: 5),
      commandTimeout: const Duration(seconds: 5),
      // useSsl: false, // Default
    );

    try {
      // (Optional) Authenticate if password is provided
      // if (password != null && password.isNotEmpty) {
      //   // If username is provided, use ACL style AUTH (Redis 6+ / Valkey)
      //   if (username != null && username.isNotEmpty) {
      //      await newClient.send(['AUTH', username, password]);
      //   } else {
      //      // Legacy AUTH
      //      await newClient.send(['AUTH', password]);
      //   }
      // }

      // Passing settings here makes it a "Flexible Client"
      await newClient.connect();

      // 4. Store the active client on success
      _client = newClient;
      print('✅ [OSS] Connected successfully to $host:$port');

      // (Optional) Test command using 'execute' (NOT 'send')
      final response = await newClient.execute(['PING']);
      print('🏓 PING response: $response');
    } catch (e) {
      print('❌ [OSS] Connection failed: $e');
      // Cleanup if connection failed
      await newClient.close();

      rethrow; // Pass error to UI to show SnackBar
    }
  }

  @override
  Future<Map<String, String>> getInfo() async {
    if (_client == null) {
      throw Exception('Not connected');
    }

    try {
      // Execute INFO command
      // Assuming 'execute' returns the raw RESP response (String or BulkString)
      final result = await _client!.execute(['INFO']);

      // Parse the INFO string into a Map
      return _parseInfo(result.toString());
    } catch (e) {
      print('❌ [OSS] Failed to fetch INFO: $e');
      rethrow;
    }
  }

  Map<String, String> _parseInfo(String rawInfo) {
    final infoMap = <String, String>{};
    final lines = rawInfo.split('\r\n');

    // String? currentSection;
    for (final line in lines) {
      if (line.isEmpty) continue;
      if (line.startsWith('#')) {
        // currentSection = line.substring(1).trim();
        continue;
      }

      final parts = line.split(':');
      if (parts.length >= 2) {
        final key = parts[0];
        // Handle values containing ':'
        final value = parts.sublist(1).join(':');
        infoMap[key] = value;
        // Optionally prepend section name:
        // infoMap['$currentSection.$key'] = value;
      }
    }
    return infoMap;
  }

  @override
  Future<void> disconnect() async {
    if (_client != null) {
      await _client!.close();
      _client = null;
      print('🔌 [OSS] Disconnected.');
    }
  }

  @override
  bool get isSshSupported => false;
}

/// A global provider for [ConnectionRepository].
///
/// Returns [BasicConnectionRepository] by default.
/// In the Pro/Enterprise version, this provider can be overridden to inject
/// a more capable implementation (e.g., one supporting SSH/TLS).
final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  // Dispose logic: Disconnect when the app is closed or provider is disposed.
  // Ensure we clean up connections when the app logic is disposed.
  ref.onDispose(() {
    // Resources are typically cleaned up by the UI or explicit disconnect
  });
  return BasicConnectionRepository();
});
