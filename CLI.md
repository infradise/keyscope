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

## Uninstallation

```sh
dart pub global deactivate keyscope
```