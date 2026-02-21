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

import 'dart:math' show Random;

import 'package:uuid/uuid.dart' show Uuid;

/// Represents the configuration for a single Redis/Valkey/Dragonfly connection.
class ConnectionConfig {
  final String id;
  final String uuid;
  String name;
  String host;
  int port;
  String? username;
  String? password;
  bool useSsh;
  bool useTls;
  bool useUuid;

  ConnectionConfig({
    required this.id,
    String? name, // Previously, this.name = 'New Connection',
    this.host = '127.0.0.1',
    this.port = 6379,
    this.username,
    this.password,
    this.useSsh = false,
    this.useTls = false,
    String? uuid, // Previously, this.uuid,
    this.useUuid = true,
  })  : name = name ?? GenerateRandomName(useUuid: useUuid).getName(),
        uuid = uuid ?? const Uuid().v4().substring(0, 8);

  ConnectionConfig copyWith({
    String? id,
    String? uuid,
    String? name,
    String? host,
    int? port,
    String? username,
    String? password,
    bool? useSsh,
    bool? useTls,
    bool? useUuid,
  }) =>
      ConnectionConfig(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        host: host ?? this.host,
        port: port ?? this.port,
        username: username ?? this.username,
        password: password ?? this.password,
        useSsh: useSsh ?? this.useSsh,
        useTls: useTls ?? this.useTls,
        useUuid: useTls ?? this.useUuid,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'host': host,
        'port': port,
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        'useSsh': useSsh,
        'useTls': useTls,
        'useUuid': useUuid,
      };

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) =>
      ConnectionConfig(
        id: json['id'] as String,
        uuid: json['uuid'] as String? ?? const Uuid().v4().substring(0, 8),
        name: json['name'] as String? ?? GenerateRandomName().getName(),
        host: json['host'] as String? ?? '127.0.0.1',
        port: json['port'] as int? ?? 6379,
        username: json['username'] as String?,
        password: json['password'] as String?,
        useSsh: json['useSsh'] as bool? ?? false,
        useTls: json['useTls'] as bool? ?? false,
        useUuid: json['useUuid'] as bool? ?? true,
      );
}

class GenerateRandomName {
  final bool useUuid;
  GenerateRandomName({this.useUuid = false});

  final serverOptions = [...redisAlternatives];
  final geoOptions = [...usCities];
  final rand = Random();

  String get server => serverOptions[rand.nextInt(serverOptions.length)];
  String get geo => geoOptions[rand.nextInt(geoOptions.length)];

  String getName() => '$server-$geo-$suffix';

  Object get suffix => switch (useUuid) {
        true => const Uuid().v4().substring(0, 8),
        _ => rand.nextInt(10000)
      };
}

final redisAlternatives = [
  'Redis',
  'Valkey',
  'Dragonfly',
  'KeyDB',
  'Amazon MemoryDB',
  'Garnet',
  'Redict',
  'Apache Kvrocks',
  'Upstash',
  'Azure Cache for Redis',
  'Google Cloud Memorystore',
  'Alibaba Cloud Tair'
];
// In-Memory DB: 'Memcached', 'Hazelcast', 'MongoDB', 'RethinkDB', 'SAP HANA'

final usCities = [
  'New York',
  'Los Angeles',
  'Chicago',
  'Houston',
  'Phoenix',
  'Philadelphia',
  'San Antonio',
  'San Diego',
  'Dallas',
  'San Jose',
  'Jacksonville',
  'Austin',
  'Fort Worth',
  'Columbus',
  'Charlotte',
  'Indianapolis',
  'San Francisco',
  'Seattle',
  'Denver',
  'Oklahoma City',
  'Nashville',
  'Washington',
  'El Paso',
  'Las Vegas',
  'Boston',
  'Detroit',
  'Portland',
  'Memphis',
  'Louisville',
  'Milwaukee',
  'Baltimore',
  'Albuquerque',
  'Fresno',
  'Sacramento',
  'Mesa',
  'Kansas City',
  'Atlanta',
  'Colorado Springs',
  'Omaha',
  'Raleigh',
  'Miami',
  'Long Beach',
  'Virginia Beach',
  'Oakland',
  'Minneapolis',
  'Tulsa',
  'Arlington',
  'New Orleans',
  'Wichita',
  'Tampa',
  'Cleveland',
  'Bakersfield',
  'Aurora',
  'Anaheim',
  'Honolulu',
  'Santa Ana',
  'Riverside',
  'Corpus Christi',
  'Lexington',
  'Stockton',
  'Henderson',
  'Saint Paul',
  'St. Louis',
  'Cincinnati',
  'Pittsburgh',
  'Greensboro',
  'Anchorage',
  'Plano',
  'Lincoln',
  'Orlando',
  'Irvine',
  'Newark',
  'Durham',
  'Chula Vista',
  'Toledo',
  'Fort Wayne',
  'St. Petersburg',
  'Laredo',
  'Jersey City',
  'Chandler',
  'Madison',
  'Buffalo',
  'Lubbock',
  'Scottsdale',
  'Reno',
  'Glendale',
  'Gilbert',
  'Winston-Salem',
  'North Las Vegas',
  'Norfolk',
  'Chesapeake',
  'Garland',
  'Irving',
  'Hialeah',
  'Fremont',
  'Boise',
  'Richmond',
  'Baton Rouge',
  'Spokane',
  'Des Moines'
];