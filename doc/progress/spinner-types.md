# Spinner Types

`SpinnerType` controls the animated frames used by `Spinner` and `MultiSpinner`.

## `dots`

Braille dot animation:

```text
⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.dots,
);
```

## `line`

Classic ASCII line spinner:

```text
- \ | /
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.line,
);
```

## `pipe`

Box-drawing animation:

```text
┤ ┘ ┴ └ ├ ┌ ┬ ┐
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.pipe,
);
```

## `clock`

Clock emoji animation:

```text
🕛 🕧 🕐 🕜 🕑 🕝 ...
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.clock,
);
```

## `arrow`

Directional arrows:

```text
← ↖ ↑ ↗ → ↘ ↓ ↙
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.arrow,
);
```

## `triangle`

Geometric triangle animation:

```text
◢ ◣ ◤ ◥
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.triangle,
);
```

## `square`

Filled and empty square animation:

```text
■ □ ▪ ▫
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.square,
);
```

## `circle`

Circular animation:

```text
◐ ◓ ◑ ◒
```

```dart
Spinner(
  'Loading...',
  type: SpinnerType.circle,
);
```

## MultiSpinner

The same `SpinnerType` values are available for `MultiSpinner`:

```dart
final spinner = MultiSpinner(
  type: SpinnerType.line,
);
```
