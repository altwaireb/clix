# Spinner

`Spinner` displays an animated indicator for an operation whose completion time is unknown or variable.

## Basic Usage

```dart
final spinner = Spinner('Loading...');

// Perform work...

spinner.complete();
```

The constructor automatically starts the spinner.

## Constructor

```dart
Spinner(
  String message, {
  SpinnerType type = SpinnerType.dots,
  CliLogger? logger,
  CliTheme? theme,
  Duration interval = const Duration(milliseconds: 100),
})
```

### `message`

The message displayed next to the animated frame:

```dart
final spinner = Spinner('Processing data...');
```

### `type`

Select the animation style:

```dart
final spinner = Spinner(
  'Loading...',
  type: SpinnerType.circle,
);
```

See [Spinner Types](spinner-types.md).

### `logger`

Optional `CliLogger` used for final success and failure messages.

```dart
final spinner = Spinner(
  'Building...',
  logger: logger,
);
```

### `theme`

Optional `CliTheme` used for the animated frame.

When omitted, `CliTheme.defaultTheme()` is used.

```dart
final spinner = Spinner(
  'Loading...',
  theme: CliTheme.cyan(),
);
```

### `interval`

Controls the time between animation frames.

The default is:

```dart
const Duration(milliseconds: 100)
```

## `start()`

Starts the spinner if it is not already active.

The spinner hides the terminal cursor while running.

```dart
spinner.start();
```

Because the constructor already starts the spinner, calling `start()` again while it is active has no effect.

## `update()`

Changes the current message:

```dart
spinner.update('Downloading...');
```

The new message is used by subsequent frames.

## `complete()`

Completes the spinner successfully:

```dart
spinner.complete();
```

You can provide a final message:

```dart
spinner.complete('Build completed');
```

When no logger is supplied, the success output uses a green `✓`.

The elapsed time is included in the success output.

## `fail()`

Completes the spinner with a failure state:

```dart
spinner.fail();
```

Or provide a final message:

```dart
spinner.fail('Build failed');
```

When no logger is supplied, the failure output uses a red `✗`.

## `cancel()`

Stops the spinner and clears its current line without displaying a completion message:

```dart
spinner.cancel();
```

## `stop()`

Stops the animation and restores the terminal cursor:

```dart
spinner.stop();
```

## Elapsed Time

The spinner tracks its start time and displays elapsed time while running.

On successful completion, the elapsed time is also included in the final message.

## Lifecycle

```text
Spinner()
   │
   ├── automatically starts
   │
   ├── update()
   │
   ├── complete()
   │
   ├── fail()
   │
   └── cancel()
```
