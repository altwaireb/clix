# Log Levels

`LogLevel` defines the logger's filtering levels.

| Level | Priority |
|---|---:|
| `plain` | 0 |
| `debug` | 1 |
| `info` | 2 |
| `warning` | 3 |
| `error` | 4 |
| `success` | 5 |

A message is emitted when its level's priority is greater than or equal to the logger's `minimumLevel`.

## Example

```dart
final logger = CliLogger(
  minimumLevel: LogLevel.info,
);
```

With this configuration, `debug()` messages are filtered while `info()`, `warn()`, `error()`, and `success()` can be emitted.
