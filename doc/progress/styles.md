# Progress Styles

`ProgressStyle` controls how a `Progress` instance is rendered.

## `basic`

Shows a progress bar and percentage.

Example:

```text
████████░░ 80.0%
```

Usage:

```dart
final progress = Progress(
  total: 10,
  style: ProgressStyle.basic,
);
```

## `detailed`

Shows the progress bar, percentage, and current/total count.

Example:

```text
████████░░ 80.0% (8/10)
```

Usage:

```dart
final progress = Progress(
  total: 10,
  style: ProgressStyle.detailed,
);
```

## `minimal`

Shows only the percentage.

Example:

```text
80%
```

Usage:

```dart
final progress = Progress(
  total: 10,
  style: ProgressStyle.minimal,
);
```

## `clean`

Shows only the visual progress bar.

Example:

```text
████████████████████████████████████████
```

Usage:

```dart
final progress = Progress(
  total: 10,
  style: ProgressStyle.clean,
);
```

## Comparison

| Style | Bar | Percentage | Count |
|---|---:|---:|---:|
| `basic` | ✓ | ✓ | — |
| `detailed` | ✓ | ✓ | ✓ |
| `minimal` | — | ✓ | — |
| `clean` | ✓ | — | — |
