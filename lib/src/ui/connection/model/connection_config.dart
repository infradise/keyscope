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

/// Represents the configuration for a single Redis/Valkey/Dragonfly connection.
class ConnectionConfig {
  final String id;
  String name;
  String host;
  int port;
  String? username;
  String? password;
  bool useSsh;
  bool useTls;

  ConnectionConfig({
    required this.id,
    this.name = 'New Connection', // No need to translate.
    this.host = '127.0.0.1',
    this.port = 6379,
    this.username,
    this.password,
    this.useSsh = false,
    this.useTls = false,
  });

  ConnectionConfig copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? username,
    String? password,
    bool? useSsh,
    bool? useTls,
  }) =>
      ConnectionConfig(
        id: id ?? this.id,
        name: name ?? this.name,
        host: host ?? this.host,
        port: port ?? this.port,
        username: username ?? this.username,
        password: password ?? this.password,
        useSsh: useSsh ?? this.useSsh,
        useTls: useTls ?? this.useTls,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'host': host,
        'port': port,
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        'useSsh': useSsh,
        'useTls': useTls,
      };

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) =>
      ConnectionConfig(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'New Connection',
        host: json['host'] as String? ?? '127.0.0.1',
        port: json['port'] as int? ?? 6379,
        username: json['username'] as String?,
        password: json['password'] as String?,
        useSsh: json['useSsh'] as bool? ?? false,
        useTls: json['useTls'] as bool? ?? false,
      );
}
