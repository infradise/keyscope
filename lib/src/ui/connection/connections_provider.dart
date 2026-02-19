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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/connection_config.dart';

const _kConnectionsKey = 'saved_connections';

/// Default connections shown on first launch.
final _defaultConnections = [
  ConnectionConfig(id: '1', name: 'myRedis-Local', port: 6379),
  ConnectionConfig(id: '2', name: 'myValkey-Local', port: 6379),
  ConnectionConfig(id: '3', name: 'myDragonfly-Local', port: 6379),
  ConnectionConfig(
    id: '4',
    name: 'Production-Cluster',
    host: '127.0.0.1',
    port: 7001,
  ),
];

/// Manages the persisted list of [ConnectionConfig] entries.
class ConnectionsNotifier extends AsyncNotifier<List<ConnectionConfig>> {
  late SharedPreferences _prefs;

  @override
  Future<List<ConnectionConfig>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _load();
  }

  // --- Public API ---

  Future<void> addConnection(ConnectionConfig config) async {
    final current = state.value ?? <ConnectionConfig>[];
    final updated = [...current, config];
    await _save(updated);
    state = AsyncData(updated);
  }

  Future<void> removeConnection(String id) async {
    final current = state.value ?? <ConnectionConfig>[];
    final updated = current.where((ConnectionConfig c) => c.id != id).toList();
    await _save(updated);
    state = AsyncData(updated);
  }

  Future<void> updateConnection(ConnectionConfig updated) async {
    final current = state.value ?? <ConnectionConfig>[];
    final list = current
        .map((ConnectionConfig c) => c.id == updated.id ? updated : c)
        .toList();
    await _save(list);
    state = AsyncData(list);
  }

  // --- Private helpers ---

  List<ConnectionConfig> _load() {
    final raw = _prefs.getString(_kConnectionsKey);
    if (raw == null) return List<ConnectionConfig>.from(_defaultConnections);

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => ConnectionConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data → fall back to defaults
      return List<ConnectionConfig>.from(_defaultConnections);
    }
  }

  Future<void> _save(List<ConnectionConfig> configs) async {
    final encoded = jsonEncode(configs.map((c) => c.toJson()).toList());
    await _prefs.setString(_kConnectionsKey, encoded);
  }
}

final connectionsProvider =
    AsyncNotifierProvider<ConnectionsNotifier, List<ConnectionConfig>>(
  ConnectionsNotifier.new,
);
