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

// import '../../../core/keyscope_client.dart' show KeyscopeClient;
// import '../../../../src/core/keyscope_client.dart';

/// Key Detail DTO
class KeyDetail {
  final String key;
  final String type; // string, hash, list, set, zset, none
  final int ttl; // -1: permanent, -2: not found
  final dynamic value; // String, Map, List, etc.

  KeyDetail({
    required this.key,
    required this.type,
    required this.ttl,
    this.value,
  });
}

/// A DTO to hold the result of a SCAN operation.
class ScanResult {
  final String cursor;
  final List<String> keys;

  ScanResult(this.cursor, this.keys);
}

/// Abstract class defining the contract for connection operations.
///
/// This repository handles the low-level connection logic to Redis/Valkey servers.
//
abstract class ConnectionRepository {
  /// The active client instance.
  /// Returns [ValkeyClient] or null if not connected.
  ValkeyClient? get _client;

  // final KeyscopeClient _client = KeyscopeClient();
  // Expose the raw client (optional)
  // ValkeyClient? get rawClient => _client.rawClient;

  bool get isConnected => _client?.isConnected ?? false;

  /// Establishes a connection to the specified host and port.
  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  }) async {
    // UI-specific logging can stay here
    print('🔌 [GUI] Connecting to $host:$port...');
    await _client?.connect(
      host: host,
      port: port,
      username: username,
      password: password,
    );
    print('✅ [GUI] Connected.');
  }

  Future<KeyDetail> getKeyDetail(String key);

  /// Fetches server information using the INFO command.
  Future<Map<String, String>> getInfo() async => {};
  // {
  //   throw UnimplementedError('');
  // }

  Future<void> deleteKey(String key) async => {};
  Future<void> setStringValue(String key, String value, {int? ttl}) async => {};

  Future<void> createKey(
          {required String key,
          required String type,
          required dynamic value,
          int? ttl}) async =>
      {};

  /// Scans keys incrementally to avoid blocking the server.
  /// [cursor]: The cursor to start from (use '0' for the start).
  /// [match]: The pattern to match (default '*').
  /// [count]: Approximate number of keys to return per batch.
  Future<ScanResult> scanKeys({
    required String cursor,
    String match = '*',
    int count = 100,
  });

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
  @override
  ValkeyClient? _client = ValkeyClient();
  // KeyscopeClient _client = KeyscopeClient();

  @override
  bool get isConnected => _client?.isConnected ?? false;

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
      // final response = await newClient.execute(['PING']);
      final response = await newClient.ping();
      print('🏓 PING response: $response');
    } catch (e) {
      print('❌ [OSS] Connection failed: $e');
      // Cleanup if connection failed
      await newClient.close();

      rethrow; // Pass error to UI to show SnackBar
    }
  }

  /// Fetch detailed information for a specific key
  @override
  Future<KeyDetail> getKeyDetail(String key) async {
    if (_client == null) throw Exception('Not connected');

    // 1. Get Type
    final typeRes = await _client!.execute(['TYPE', key]);
    // TODO: add type() to valkey_client
    final type = typeRes.toString(); // "string", "hash", etc.

    // 2. Get TTL
    // final ttlRes = await _client!.execute(['TTL', key]);
    // final ttl = (ttlRes is int) ? ttlRes : -1;
    final ttl = await _client!.ttl(key);

    // 3. Get Value based on Type
    dynamic value;
    try {
      switch (type) {
        case 'string':
          // value = await _client!.execute(['GET', key]);
          value = await _client!.get(key);
          break;
        case 'hash':
          // Returns list [key, val, key, val...] -> Convert to Map
          final res = await _client!.execute(['HGETALL', key]);
          // final res = await _client!.hgetall(key);
          // TODO: change execute to hgetall
          if (res is List) {
            final map = <String, String>{};
            for (var i = 0; i < res.length; i += 2) {
              map[res[i].toString()] = res[i + 1].toString();
            }
            value = map;
          }
          break;
        case 'list':
          // Get full list (warning: large lists should be paginated in v0.4.0)
          // execute(['LRANGE', key, '0', '-1']);
          value = await _client!.lrange(key, 0, -1);
          break;
        case 'set':
          value = await _client!.smembers(key); // execute(['SMEMBERS', key]);
          break;
        case 'zset':
          // Get list with scores
          value =
              await _client!.execute(['ZRANGE', key, '0', '-1', 'WITHSCORES']);
          // TODO: change execute to zrange
          // await _client!.zrange(key, 0, -1);
          break;
        case 'ReJSON-RL':
          value = await _client!.jsonGet(key: key);
        default:
          value = 'Unsupported type: $type';
      }
    } catch (e) {
      value = 'Error fetching value: $e';
    }

    // return KeyDetail(key: key, type: type, ttl: ttl, value: value);
    return KeyDetail(key: key, type: type, ttl: ttl, value: value);
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
      // TODO: add info() to valkey_client

      // Parse the INFO string into a Map
      return _parseInfo(result.toString());
    } catch (e) {
      print('❌ [OSS] Failed to fetch INFO: $e');
      rethrow;
    }
  }

  /// Helper for getInfo
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

  /// Delete a key from the server.
  @override
  Future<void> deleteKey(String key) async {
    if (_client == null) throw Exception('Not connected');
    // await _client!.execute(['DEL', key]);
    await _client!.del(key);
  }

  /// Update the value of a String type key.
  /// Note: v0.4.0 currently focuses on String type updates.
  @override
  Future<void> setStringValue(String key, String value, {int? ttl}) async {
    if (_client == null) throw Exception('Not connected');

    // SET key value
    // Execute SET command
    // await _client!.execute(['SET', key, value]);
    await _client!.set(key, value);

    // Restore TTL if it was set
    if (ttl != null && ttl > 0) {
      // await _client!.execute(['EXPIRE', key, ttl.toString()]);
      await _client!.expire(key, ttl);
    }
  }

  // TODO: Add update methods for Hash, List, Set, etc. here.

  // TODO: Same with `core`. Need to dedup and use valkey_client.
  @override
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

    // return _client.scanKeys(cursor: cursor, match: match, count: count);
  }

  /// Create a new key with an initial value.
  /// [type]: 'string', 'hash', 'list', 'set', 'zset'
  /// [value]: Depends on type.
  ///   - string: String
  ///   - hash: `Map<String, String>` (at least one field-value)
  ///   - list: String (initial item)
  ///   - set: String (initial member)
  ///   - zset: `Map<String, num>` (member -> score)
  @override
  Future<void> createKey({
    required String key,
    required String type,
    required dynamic value,
    int? ttl,
  }) async {
    if (_client == null) throw Exception('Not connected');

    // 1. Create Key based on Type
    switch (type) {
      case 'string':
        // execute(['SET', key, value.toString()]);
        await _client!.set(key, value.toString());
        break;

      case 'hash':
        // HSET key field value
        if (value is! Map || value.isEmpty) {
          throw Exception('Hash requires at least one field-value');
        }
        final args = ['HSET', key];
        value.forEach((f, v) {
          // value as Map
          args.add(f.toString());
          args.add(v.toString());
        });
        await _client!.execute(args);
        // TODO: change to hset()
        break;

      case 'list':
        // RPUSH key item
        // execute(['RPUSH', key, value.toString()]);
        await _client!.rpush(key, value.toString());
        break;

      case 'set':
        // SADD key member
        // await _client!.execute(['SADD', key, value.toString()]);
        await _client!.sadd(key, value.toString());
        break;

      case 'zset':
        // ZADD key score member
        if (value is! Map || value.isEmpty) {
          throw Exception('ZSet requires score and member');
        }
        // value map: { "member": score }
        final entry = value.entries.first; // value as Map
        await _client!.execute(
            ['ZADD', key, entry.value.toString(), entry.key.toString()]);
        // await _client!.zadd(
        //     key, entry.value as double, entry.key.toString());
        // TODO: change to zadd() / check zset
        break;

      default:
        throw Exception('Unsupported type: $type');
    }

    // 2. Set TTL if provided
    if (ttl != null && ttl > 0) {
      // execute(['EXPIRE', key, ttl.toString()]);
      await _client!.expire(key, ttl);
    }
  }

  @override
  Future<void> disconnect() async {
    if (_client != null) {
      await _client!.close();
      _client = null;
      print('🔌 [OSS] Disconnected.');
    }
  }

  // Future<void> disconnect() async {
  //   await _client.disconnect();
  // }

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

  // return ConnectionRepository();
});
