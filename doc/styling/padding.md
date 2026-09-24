# Padding

`Padding` controls spaces on both sides of text.

| Value | Spaces per side |
|---|---:|
| `none` | 0 |
| `small` | 1 |
| `medium` | 2 |
| `large` | 3 |
| `extraLarge` | 4 |
| `huge` | 5 |

```dart
final text = Padding.medium.apply('Hello');
```

Use `leftPadding` or `rightPadding` when only one side is required.
