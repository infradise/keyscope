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
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
// import 'package:keyscope/src/core/keyscope_client.dart'; // TODO: REMOVE.
import 'package:valkey_client/valkey_client.dart';

ValkeyLogger logger = ValkeyLogger('Keyscope CLI');

void main(List<String> arguments) async {
  final setCommand = ArgParser()
    ..addOption('key', abbr: 'k', mandatory: true, help: '--key version')
    ..addOption('value', abbr: 'v', mandatory: true, help: '--value 9.0.0');

  final getCommand = ArgParser()
    ..addOption('key',
        abbr: 'k', mandatory: true, help: '--key version \n=> return 9.0.0');

  final jsonSetCommand = ArgParser()
    ..addOption('key', abbr: 'k', mandatory: true, help: '--key my_json_key')
    ..addOption('path', abbr: 'p', mandatory: true, help: r'--path "$"')
    ..addOption('value',
        abbr: 'v',
        mandatory: true,
        help: '--value \'{"name": "Alice", "age": 30}\'');

  final jsonGetCommand = ArgParser()
    ..addOption('key', abbr: 'k', mandatory: true, help: '--key my_json_key')
    ..addOption('path', abbr: 'p', mandatory: true, help: r'--path "$"');

  // Check connectivity (PING/PONG)
  final pingCommand = ArgParser();
  // ..addFlag('all', abbr: 'a', help: 'all nodes', negatable: false);

  final parser = ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: 'localhost', help: 'Target host')
    ..addOption('port', abbr: 'p', defaultsTo: '6379', help: 'Target port')
    ..addOption('username', abbr: 'u', help: 'Username')
    ..addOption('password', abbr: 'a', help: 'Password')
    ..addOption('db', help: 'Database (defaults to 0)')
    ..addFlag('ssl', help: 'SSL/TLS/mTLS', negatable: false)
    ..addFlag('silent', help: '(Silent mode) Hide all logs', negatable: false)
    ..addOption('match',
        abbr: 'm', defaultsTo: '*', help: 'Key pattern to match (for --scan)')
    ..addFlag('scan',
        help: 'Scan keys (Cursor-based iteration)', negatable: false)
    ..addCommand('set', setCommand)
    ..addCommand('get', getCommand)
    ..addCommand('json-set', jsonSetCommand)
    ..addCommand('json-get', jsonGetCommand)
    ..addCommand('ping', pingCommand)
    ..addMultiOption('set', help: '--set <key> <value>')
    ..addMultiOption('get', help: '--get <key>')
    ..addFlag('help',
        abbr: '?', help: 'Show usage information', negatable: false);

  try {
    final results = parser.parse(arguments);

    logger.setEnableValkeyLog(!(results['silent'] as bool));

    if (results['help'] as bool) {
      showUsages(parser);
      exit(0);
    }

    ValkeyClient? valkeyClient;

    try {
      final host = results['host'] as String;
      final port = int.parse(results['port'] as String);
      final username = results['username'] as String?;
      final password = results['password'] as String?;
      final db = results['db'] as int? ?? 0;
      final ssl = results['ssl'] as bool? ?? false;

      // Instantiate the repository directly (No Riverpod needed for CLI)
      // -- final repo = BasicConnectionRepository();
      // -- await repo.connect(host: host, port: port, password: password);

      final settings = ValkeyConnectionSettings(
        host: host,
        port: port,
        username: username,
        password: password,
        useSsl: ssl,
        database: db,
      );

      valkeyClient = ValkeyClient.fromSettings(settings);

      // Connect
      await connect(valkeyClient);

      // Handle Commands
      switch (results.command?.name) {
        case 'ping':
          await ping(valkeyClient);
          await close(valkeyClient);
          break;
        case 'set':
          final key = results.command?['key'] as String;
          final value = results.command?['value'] as String;
          await set(valkeyClient, key, value);
          break;
        case 'get':
          final key = results.command?['key'] as String;
          await get(valkeyClient, key);
          break;
        case 'json-set':
          final key = results.command?['key'] as String;
          final path = results.command?['path'] as String;
          final value = results.command?['value'] as String; // as dynamic;
          await jsonSet(valkeyClient, key: key, path: path, data: value);
          break;
        case 'json-get':
          final key = results.command?['key'] as String;
          final path = results.command?['path'] as String;
          await jsonGet(valkeyClient, key: key, path: path);
          break;
        case 'scan':
          break;
        default:
          // Handle Options
          //
          // if (results['ping'] as bool) {}
          //
          if (results.wasParsed('set')) {
            final optionValues =
                List<String>.from(results['set'] as List<String>);
            final rest = results.rest;
            final values = [...optionValues, ...rest];

            if (values.length >= 2) {
              final key = values[0];
              final value = values[1];
              await set(valkeyClient, key, value);
            } else {
              logger.info(parser.usage);
            }
          } else if (results.wasParsed('get')) {
            final values = results['get'] as List<String>;
            if (values.isNotEmpty) {
              final key = values[0];
              await get(valkeyClient, key);
            } else {
              logger.info(parser.usage);
            }
          } else if (results.wasParsed('scan')) {
            final match = results['match'] as String? ?? '*';
            final count = results['count'] as int? ?? 20;
            final type = results['type'] as String? ?? '';
            await scan(valkeyClient, match, count, type);
          } else {
            showUsages(parser);
          }
          break;
      }
    } on FormatException catch (e) {
      logger.info(e.message);
      showUsages(parser);
    } catch (e) {
      logger.error('❌ Error: $e');
      exit(1);
    } finally {
      // Cleanup
      if (valkeyClient != null) {
        await close(valkeyClient);
      }
    }
  } catch (e) {
    logger.error('❌ Invalid arguments: $e'); // Args Error
    exit(1);
  }
}

Future<String> ping(ValkeyClient client) async {
  logger.info('🏓 PING');
  try {
    final response = await client.ping();
    logger.info('RESPONSE: '
        '${response.toString() == 'PONG' ? 'PONG' : 'NOT PONG ($response)'}');
    // logger.info('✅ Connection Status: OK');
    return response;
  } catch (e) {
    logger.error('❌ Connection Failed: $e');
    return ''; // OR exit(1);
  }
}

Future<void> connect(ValkeyClient client) async {
  final config = client.currentConnectionConfig;
  logger.info('Target host: ${config?.host}');
  logger.info('Target port: ${config?.port}');

  logger.info('🔌 Connecting to ${config?.host}:${config?.port}...');
  await client.connect();
}

// Future<void> showCurrentConnectedHostAndPort(ValkeyClient client) async {
//   final config = client.currentConnectionConfig;
//   logger.info(client.isConnected);
//   if (client.isConnected && config != null) {
//     logger.info('Connected host: ${config.host}');
//     logger.info('Connected port: ${config.port}');
//   } else {
//     logger.info('No connection');
//   }
// }

Future<void> close(ValkeyClient client) async {
  await client.close();
}

Future<String?> get(ValkeyClient client, String key) async {
  final value = await client.get(key); // unawaited(client.get(key));
  logger.info('GET: key: $key, value: $value');
  return value;
}

Future<void> set(ValkeyClient client, String key, String value) async {
  logger.info('SET: key: $key, value: $value');
  await client.set(key, value); // unawaited(client.set(key, value));
}

Future<dynamic> jsonGet(ValkeyClient client,
    {required String key, String path = r'$'}) async {
  final value = await client.jsonGet(key: key, path: path);
  logger.info('GET: key: $key, path: $path, value: $value');
  return value;
}

Future<void> jsonSet(ValkeyClient client,
    {required String key, String path = r'$', required String data}) async {
  logger.info('SET: key: $key, path: $path, data: $data');
  await client.jsonSet(key: key, path: path, data: jsonDecode(data));
}

// ⚠️ When no command specified:
void showUsages(ArgParser parser) {
  print('Keyscope CLI - Diagnostic and CI Tool\n');
  print('Usage: keyscope <command> [options]\n');
  print('Commands:');
  parser.commands.forEach((name, cmd) {
    print('\n$name:');
    print(cmd.usage);
  });
  print('\nOptions:');
  print(parser.usage);
}

Future<void> scan(
    ValkeyClient client, String? match, int? count, String? type) async {
  logger.info('🔍 Scanning keys (MATCH: "$match", COUNT: 20)...');

  final result =
      await client.scan(cursor: '0', match: match ?? '*', count: count ?? 20);

  // logger.info('----------------------------------------');
  // logger.info('Next Cursor : ${result.cursor}');
  // logger.info('Found Keys  : ${result.keys.length}');
  // logger.info('----------------------------------------');
  logger.info('Found ${result.keys.length} keys. '
      'Next cursor: ${result.cursor}');

  if (result.keys.isEmpty) {
    logger.info('(No keys found)');
  } else {
    for (var key in result.keys) {
      logger.info('- $key');
    }
  }

  if (result.cursor == '0') {
    logger.info('----------------------------------------');
    logger.info('✅ Full iteration completed (Cursor returned to 0).');
  } else {
    logger.info('----------------------------------------');
    logger.info('👉 More keys available. '
        'Use cursor "${result.cursor}" to continue.');
  }
}
