# Line Spacing

`LineSpacing` controls empty lines between lines of terminal output.

| Value | Empty lines |
|---|---:|
| `none` | 0 |
| `single` | 1 |
| `double` | 2 |
| `triple` | 3 |

```dart
logger.lines(
  ['Build complete', 'Run tests next'],
  lineSpacing: LineSpacing.single,
);
```

Use `spacing` when a newline string is required directly.
