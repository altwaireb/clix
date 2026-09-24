# Messages

`CliLogger` provides level-based message methods for common terminal output.

## Example

```dart
logger.success('Build completed');
```

## Message Methods

- `debug()`
- `info()`
- `warn()`
- `error()`
- `success()`
- `plain()`

Each accepts `message`, with optional `showPrefix` and `indent` parameters.

## Multiple Lines

Use `lines()` to output several messages using one `LogLevel` and shared formatting options.

```dart
logger.lines(
  ['Downloading...', 'Extracting...', 'Completed'],
  level: LogLevel.info,
);
```

## Prompt Results

- `promptResult()`
- `multiPromptResult()`

These methods display completed prompt answers using the logger's primary theme color and a success mark.

## Output Utilities

- `newLine()`
- `output()`

`newLine()` writes one or more blank lines. `output()` writes a message directly through the logger's I/O.

## Log Levels

```dart
LogLevel.plain
LogLevel.debug
LogLevel.info
LogLevel.warning
LogLevel.error
LogLevel.success
```

`minimumLevel` controls which level-based messages are emitted. A message is logged when its priority is greater than or equal to the configured minimum level.
