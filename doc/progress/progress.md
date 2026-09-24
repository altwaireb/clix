# Progress

`Progress` displays determinate progress when the total amount of work is known.

## Basic Usage

```dart
final progress = Progress(
  total: 100,
);

for (var i = 0; i <= 100; i++) {
  progress.update(i);
}

progress.complete();
```

The default configuration uses:

```text
total: required
width: 40
style: ProgressStyle.basic
theme: CliTheme.defaultTheme()
```

## Constructor

```dart
Progress({
  CliIO? io,
  required int total,
  int width = 40,
  ProgressStyle style = ProgressStyle.basic,
  CliTheme? theme,
})
```

### `io`

Optional `CliIO` used for output.

When omitted, `ConsoleIO()` is used.

```dart
final progress = Progress(
  io: myIO,
  total: 100,
);
```

### `total`

The maximum value representing 100% completion.

```dart
final progress = Progress(total: 50);
```

### `width`

The character width of the progress bar.

```dart
final progress = Progress(
  total: 100,
  width: 40,
);
```

### `style`

Controls the progress representation.

```dart
final progress = Progress(
  total: 100,
  style: ProgressStyle.detailed,
);
```

See [Progress Styles](styles.md).

### `theme`

Optional `CliTheme`.

When omitted, `CliTheme.defaultTheme()` is used.

```dart
final progress = Progress(
  total: 100,
  theme: CliTheme.cyan(),
);
```

## `update()`

Set the current progress value:

```dart
progress.update(25);
```

The displayed percentage is calculated from `_current / total` and clamped to `0.0..100.0`.

## `increment()`

Increase the current value by one:

```dart
progress.increment();
```

## `complete()`

Set the current value to `total`, render the final state, and write a newline:

```dart
progress.complete();
```

## Rendering

The progress bar uses:

- `CliStyle.filledProgress` for the filled portion.
- `CliStyle.emptyProgress` for the empty portion.
- the configured theme's primary color for the visual bar.

The displayed percentage depends on the selected `ProgressStyle`.

## Important

`Progress` does not run its own timer. Your application controls when progress is updated.

## What's Next?

See [Progress Styles](styles.md).
