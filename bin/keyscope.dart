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

import 'dart:io';
import 'package:args/args.dart';
// import 'package:keyscope/keyscope.dart'; // TODO: keyscope_cli.dart
// import 'package:valkey_client/valkey_client.dart';
import 'package:keyscope/src/core/keyscope_client.dart';

void main(List<String> arguments) async {
  // e.g., keyscope --ping
  final parser = ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: 'localhost', help: 'Target host')
    ..addOption('port', abbr: 'p', defaultsTo: '6379', help: 'Target port')
    ..addOption('password', abbr: 'a', help: 'Password')
    ..addOption('match',
        abbr: 'm', defaultsTo: '*', help: 'Key pattern to match (for --scan)')
    ..addFlag('ping', help: 'Check connectivity (PING/PONG)', negatable: false)
    ..addFlag('scan',
        help: 'Scan keys (Cursor-based iteration)', negatable: false)
    ..addFlag('help',
        abbr: '?', help: 'Show usage information', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('Keyscope CLI - Diagnostic Tool\n');
      print('Usage: keyscope [options]');
      print(parser.usage);
      exit(0);
    }

    final host = results['host'] as String;
    final port = int.parse(results['port'] as String);
    final password = results['password'] as String?;
    final match = results['match'] as String;

    // 1. Instantiate the repository directly (No Riverpod needed for CLI)
    // final repo = BasicConnectionRepository();
    // TODO: Use client instead of repo for now.
    // Use the Pure Dart Client
    final client = KeyscopeClient();

    try {
      // 2. Connect
      // print('🔌 Connecting to $host:$port...');
      // await repo.connect(host: host, port: port, password: password);
      // print('✅ Connected.');

      // 3. Handle Commands
      if (results['ping'] as bool) {
        // [PING Test]
        // await _runPingTest(host, port);
        // Since we are connected, basic connectivity is already proven.
        // We can optionally check info or just print OK.
        // print('🏓 PING Test: OK (Connection established)');

        print('🔌 Connecting to $host:$port...');
        await client.connect(host: host, port: port, password: password);
        print('✅ PING: OK (Connection Established)');
      } else if (results['scan'] as bool) {
        print('🔌 Connecting to $host:$port...');
        await client.connect(host: host, port: port, password: password);

        // [SCAN Test]
        // print('🔍 Scanning keys (MATCH: "$match")...');
        print('🔍 Scanning keys (MATCH: "$match", COUNT: 20)...');

        final result =
            await client.scanKeys(cursor: '0', match: match, count: 20);

        // print('----------------------------------------');
        // print('Next Cursor : ${result.cursor}');
        // print('Found Keys  : ${result.keys.length}');
        // print('----------------------------------------');
        print(
            'Found ${result.keys.length} keys. Next cursor: ${result.cursor}');

        if (result.keys.isEmpty) {
          print('(No keys found)');
        } else {
          for (var key in result.keys) {
            print('- $key');
          }
        }

        if (result.cursor == '0') {
          print('----------------------------------------');
          print('✅ Full iteration completed (Cursor returned to 0).');
        } else {
          print('----------------------------------------');
          print('👉 More keys available. Use cursor "${result.cursor}" to '
              'continue.');
        }
      } else {
        // print('No command specified. Use --help for usage.');
        // print('⚠️ No command. Use --ping or --scan');
        print(
            '⚠️ No command specified. Use --ping or --scan. Otherwise, --help '
            'for usage.');
        print(parser.usage);
      }
    } catch (e) {
      print('❌ Error: $e');
      exit(1);
    } finally {
      // Cleanup
      await client.disconnect();
    }
  } catch (e) {
    // print('Error: $e');
    // print('❌ Args Error: $e');
    print('❌ Invalid arguments: $e');
    print(parser.usage);
    exit(1);
  }
}

// Future<void> _runPingTest(String host, int port) async {
//   print('Running PING test on $host:$port...');

//   // Here we use the Repository logic defined in lib/
//   // Since we are in CLI (no Riverpod), we instantiate the repository directly.
//   final repo = BasicConnectionRepository();

//   try {
//     // In the future, this will return real connection status
//     await repo.connect(host: host, port: port);
//     print('✅ Connection Status: OK');
//     // TODO: Implement actual PING command via valkey_client
//   } catch (e) {
//     print('❌ Connection Failed: $e');
//     exit(1);
//   }
// }
