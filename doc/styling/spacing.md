# Spacing

`Spacing` controls horizontal gaps between terminal elements.

| Value | Spaces |
|---|---:|
| `none` | 0 |
| `small` | 2 |
| `medium` | 4 |
| `large` | 6 |
| `extraLarge` | 8 |
| `huge` | 10 |

## Apply a Gap

```dart
final text = Spacing.medium.apply('Status:', 'Ready');
```

## Custom Separator

```dart
final text = Spacing.small.applyWithSeparator(
  'Status:',
  'Ready',
  '→',
);
```

Use `gap` when only the spaces are needed.
