
# Commands

## `ping`

Returns `PONG` as String

```sh
keyscope ping
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