# Keyscope CLI Diagnostic Tool

Keyscope includes a built-in CLI tool for diagnosing connectivity issues with Redis and Valkey servers. This is useful for verifying SSH tunneling, network reachability, and authentication without launching the GUI.

## Installation

```sh
dart pub global activate --source path .
```

Use this:
```sh
keyscope --help
```

## Non-installation

### Dart Run
```sh
dart run bin/keyscope.dart
```

```
dart run bin/keyscope.dart --help
```

Or,

### Dart Build 

```sh
dart build cli --target=bin/keyscope.dart -o bin/keyscope
```

Generated files on macOS:
```sh
# bin/keyscope/bundle/bin/keyscope
# bin/keyscope/bundle/lib/objective_c.dylib
```

```sh
./bin/keyscope/bundle/bin/keyscope --help
```

## Usage

Check connection status (PING):

The default host is `localhost` (i.e., `127.0.0.1`) and port `6379`.

```sh
keyscope --ping
```

OR

```sh
keyscope --host localhost --port 6379 --ping
```

Scan all keys:

```sh
keyscope --scan
```

Scan some keys with some patterns:

```sh
keyscope --scan --match "some_patterns"
```

Scan all keys with some patterns as prefix:

```sh
keyscope --scan --match "some_pattern*"
```

---

# Commands

## `ping`

Returns `PONG` as String

```sh
keyscope ping
```

```sh
dart run bin/keyscope.dart ping --port 6379 --tls --insecure --silent
PONG
```

```sh
dart run bin/keyscope.dart ping --tls --insecure --silent
PONG
```

```sh
dart run bin/keyscope.dart ping --port 6379 --ssl --insecure --silent
PONG
```

```sh
dart run bin/keyscope.dart ping --ssl --insecure --silent
PONG
```

## `set`

```sh
keyscope set --key my_key --value my_value
```
OR
```sh
keyscope set -k my_key -v my_value
```

## `get`

Returns `my_value`

```sh
keyscope get --key my_key
```
OR
```sh
keyscope get -k my_key
```

## `json-set`

Sets a JSON value.
Required: `--path` (usually `$` for root).

```sh
keyscope json-set --key my_json_key --path "$" --value '{"name": "Alice", "age": 30}'
```
OR
```sh
keyscope json-set -k my_json_key -p "$" -v '{"name": "Alice", "age": 30}'
```

## `json-get`

Gets a JSON value.

```sh
keyscope json-get --key my_json_key --path "$"
# keyscope json-get --key user:100 --path '$.name'
```
OR
```sh
keyscope json-get -k my_json_key
# (If path is omitted, default to "$")
```

# Options

## `--slient`

Silent mode. No logs to show.

```sh
keyscope --silent
```

## `--set`

```sh
keyscope --set my_key my_value
```

## `--get`

Returns `my_value`

```sh
keyscope --get my_key
```

## `--scan`

```sh
keyscope --scan --match "some_patterns"
```

## `--match`

```sh
keyscope --scan --match "some_pattern*"
```

## `--db`

The default is 0.

```sh
keyscope --db 1
```

## `--ssl`

The default is empty.

```sh
keyscope --ssl
```

## `--host`

The default is `localhost` (i.e., `127.0.0.1`).

```sh
keyscope --host localhost --ping
```

## `--port`

The default is `6379`.

```sh
keyscope --port 6379 --ping
```

## `--username`

The default is empty.

```sh
keyscope --username MY_ANONYMOUS_USERNAME --ping
```

## `--password`

The default is empty.

```sh
keyscope --password MY_VERY_STRONG_PASSWORD --ping
```

## `--help`

Show all options.

---

To see the help:
```sh
keyscope --help
```
```sh
Usage: keyscope [options]
-h, --host     (defaults to "localhost")
-p, --port     (defaults to "6379")
-m, --match    (defaults to "*")
    --ping     
    --scan     
-?, --help
```

### Options

| Option | Abbr. | Description | Default |
| --- | --- | --- | --- |
| `--host` | `-h` | Target host address | `localhost` |
| `--port` | `-p` | Target port number | `6379` |
| `--ping` |  | Check connectivity (PING/PONG) | `false` |
| `--scan` |  | Scan all keys | `false` |
| `--match` |  | Scan all keys with patterns | `false` |
| `--help` | `-?` | Show usage information |  |

## Troubleshooting

- If you encounter `command not found`, ensure your system path includes the pub cache bin directory.

- Check out the output logs:

```sh
dart build cli --target=bin/keyscope.dart -o bin/keyscope > output.txt 2>&1
```

- The following command does not work. Do not use:

```sh
dart compile exe bin/keyscope.dart -o bin/keyscope
```

- General commands
- 
```sh
dart pub global run keyscope
dart pub global list
dart pub global deactivate keyscope
rm ~/.pub-cache/bin/keyscope
```

## Uninstallation

```sh
dart pub global deactivate keyscope
```