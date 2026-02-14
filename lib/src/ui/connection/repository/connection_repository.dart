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

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyscope_client/keyscope_client.dart';

// import '../../../core/keyscope_client.dart' show KeyscopeClient;

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

/// Abstract class defining the contract for connection operations.
///
/// This repository handles the low-level connection logic to Redis/Valkey servers.
//
abstract class ConnectionRepository {
  /// The active client instance.
  /// Returns [KeyscopeClient] or null if not connected.
  KeyscopeClient? get _client;

  // final KeyscopeClient _client = KeyscopeClient();
  // Expose the raw client (optional)
  // KeyscopeClient? get rawClient => _client.rawClient;

  bool get isConnected => _client?.isConnected ?? false;

  /// Establishes a connection to the specified host and port.
  Future<void> connect({
    required String host,
    required int port,
    String? username,
    String? password,
  }) async =>
      {};
  //   print(password);
  //   // UI-specific logging can stay here
  //   print('🔌 [GUI] Connecting to $host:$port...');
  //   await _client?.connect(
  //     host: host,
  //     port: port,
  //     username: username,
  //     password: password,
  //   );
  //   print('✅ [GUI] Connected.');
  // }

  Future<KeyDetail> getKeyDetail(String key);

  /// Fetches server information using the INFO command.
  Future<Map<String, String>> getInfo() async => {};
  // {
  //   throw UnimplementedError('');
  // }

  Future<void> deleteKey(String key) async => {};
  Future<void> setStringValue(String key, String value, {int? ttl}) async => {};

  Future<void> createKey({
    required String key,
    required String type,
    required dynamic value,
    int? ttl,
  }) async =>
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

  Future<void> setHashField(String key, String field, String value) async {}
  Future<void> deleteHashField(String key, String field) async {}
  Future<void> addListItem(String key, String value) async {}
  Future<void> updateListItem(String key, int index, String value) async {}
  Future<void> removeListValue(String key, String value) async {}
  Future<void> addSetMember(String key, String member) async {}
  Future<void> removeSetMember(String key, String member) async {}
  Future<void> addZSetMember(String key, num score, String member) async {}
  Future<void> removeZSetMember(String key, String member) async {}
}

/// [OSS Version] Default implementation of ConnectionRepository
///
/// This implementation provides basic connectivity without advanced Enterprise
/// features like SSH Tunneling or dedicated support.
class BasicConnectionRepository implements ConnectionRepository {
  @override
  KeyscopeClient? _client = KeyscopeClient();
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
    print('🔌 Connecting to $host:$port using KeyscopeClient...');

    // KeyscopeClient supports 3 authentication modes via settings:
    // - No Auth
    // - Password only (Legacy)
    // - Username + Password (ACL)
    final client = KeyscopeClient(
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
      await client.connect();

      // 4. Store the active client on success
      _client = client;
      print('✅ Connected successfully to $host:$port');

      final response = await client.ping();
      print('🏓 PING response: $response');
    } catch (e) {
      print('❌ Connection failed: $e');
      // Cleanup if connection failed
      await client.close();

      rethrow; // Pass error to UI to show SnackBar
    }
  }

  /// Fetch detailed information for a specific key
  @override
  Future<KeyDetail> getKeyDetail(String key) async {
    if (_client == null) throw Exception('Not connected');

    // 1. Get Type
    final typeRes = await _client!.type(key);
    final type = typeRes.toString(); // "string", "hash", etc.

    // 2. Get TTL
    final ttl = await _client!.ttl(key); // -1

    // 3. Get Value based on Type
    dynamic value;
    try {
      switch (type) {
        case 'string':
          value = await _client!.get(key);
          break;
        case 'hash':
          final res = await _client!.hGetAll(key);
          value = Map<String, String>.from(res);
          break;
        case 'list':
          // Get full list (warning: large lists should be paginated in v0.4.0)
          value = await _client!.lRange(key, 0, -1);
          break;
        case 'set':
          value = await _client!.sMembers(key);
          break;
        case 'zset':
          // Get list with scores
          value = await _client!.zRange(key, 0, -1, withScores: true);
          break;
        case 'ReJSON-RL':
          value = await _client!.jsonGet(key: key);
        default:
          value = 'Unsupported type: $type';
      }
    } catch (e) {
      value = 'Error fetching value: $e';
    }

    return KeyDetail(key: key, type: type, ttl: ttl, value: value);
  }

  @override
  Future<Map<String, String>> getInfo() async {
    if (_client == null) {
      throw Exception('Not connected');
    }

    try {
      final result = await _client!.info();

      // Parse the INFO string into a Map
      return _parseInfo(result.toString());
    } catch (e) {
      print('❌ Failed to fetch INFO: $e');
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
    await _client!.del([key]);
  }

  /// Update the value of a String type key.
  /// Note: v0.4.0 currently focuses on String type updates.
  @override
  Future<void> setStringValue(String key, String value, {int? ttl}) async {
    if (_client == null) throw Exception('Not connected');

    await _client!.set(key, value);

    // Restore TTL if it was set
    if (ttl != null && ttl > 0) {
      await _client!.expire(key, ttl);
    }
  }

  // TODO: Add update methods for Hash, List, Set, etc. here.

  @override
  Future<ScanResult> scanKeys({
    required String cursor,
    String match = '*',
    int count = 100,
  }) async {
    if (_client == null) throw Exception('Not connected');
    return _client!.scanCli(cursor: cursor, match: match, count: count);
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
        await _client!.set(key, value.toString());
        break;

      case 'hash':
        // HSET key field value
        if (value is! Map || value.isEmpty) {
          throw Exception('Hash requires at least one field-value');
        }
        // final args = ['HSET', key];
        // value.forEach((f, v) {
        //   // value as Map
        //   args.add(f.toString());
        //   args.add(v.toString());
        // });
        // await _client!.execute(args);
        await _client!.hSet(key, value as Map<String, String>);
        break;

      case 'list':
        await _client!.rPush(key, [value.toString()]);
        break;

      case 'set':
        await _client!.sAdd(key, [value.toString()]);
        break;

      case 'zset':
        // ZADD key score member
        if (value is! Map || value.isEmpty) {
          throw Exception('ZSet requires score and member');
        }
        // value map: { "member": score }
        final entry = value.entries.first; // value as Map

        // final raw = entry.value;
        // final score = raw is num ? raw.toDouble() :
        // double.tryParse(raw.toString()) ??
        //   (throw Exception('Invalid score'));

        await _client!.zAdd(key, {entry.key.toString(): entry.value as num});
        break;

      default:
        throw Exception('Unsupported type: $type');
    }

    // 2. Set TTL if provided
    if (ttl != null && ttl > 0) {
      await _client!.expire(key, ttl);
    }
  }

  @override
  Future<void> disconnect() async {
    if (_client != null) {
      await _client!.close();
      _client = null;
      print('🔌 Disconnected.');
    }
  }

  @override
  bool get isSshSupported => false;

  // --- Hash Operations ---

  /// Set a field in a Hash.
  @override
  Future<int> setHashField(String key, String field, String value) async {
    if (_client == null) throw Exception('Not connected');
    return _client!.hSet(key, {field: value}); // changed counts
  }

  /// Delete a field from a Hash.
  @override
  Future<int> deleteHashField(String key, String field) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.hDel(key, [field]);
    return _client!.hDel(key, [field]); // deleted counts
  }

  // --- List Operations ---

  /// Append an item to a List (Right Push).
  @override
  Future<void> addListItem(String key, String value) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.rPush(key, [value]);
  }

  /// Update a List item by index.
  @override
  Future<void> updateListItem(String key, int index, String value) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.lSet(key, index, value);
  }

  /// Remove items from a List.
  /// LREM key count value (count 0 means remove all occurrences).
  @override
  Future<void> removeListValue(String key, String value) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.lRem(key, 0, value);
  }

  // --- Set Operations ---

  /// Add a member to a Set.
  @override
  Future<void> addSetMember(String key, String member) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.sAdd(key, [member]);
  }

  /// Remove a member from a Set.
  @override
  Future<void> removeSetMember(String key, String member) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.sRem(key, [member]);
  }

  // --- Sorted Set (ZSet) Operations ---

  /// Add or Update a member in a ZSet.
  @override
  Future<void> addZSetMember(String key, num score, String member) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.zAdd(key, {member: score.toDouble()});
  }

  /// Remove a member from a ZSet.
  @override
  Future<void> removeZSetMember(String key, String member) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.zRem(key, [member]);
  }
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
