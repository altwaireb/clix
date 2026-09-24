# Themes

`CliTheme` groups semantic `CliStyle` values for consistent terminal output.

## Default Theme

```dart
final theme = CliTheme.defaultTheme();
```

The default styles are:

| Style | Default |
|---|---|
| `plain` | white |
| `debug` | gray |
| `info` | cyan |
| `warn` | yellow + bold |
| `error` | red + bold |
| `success` | green |
| `primary` | `CliColor.primary` |
| `secondary` | `CliColor.secondary` |

## Custom Theme

```dart
final theme = CliTheme(
  info: CliStyle().withColor(CliColor.blue),
  success: CliStyle().withColor(CliColor.green).makeBold(),
);
```

Unspecified styles use their defaults.

## Primary and Secondary Colors

```dart
final primary = theme.primaryColor;
final secondary = theme.secondaryColor;
```

These return the configured foreground color, falling back to `CliColor.primary` and `CliColor.secondary` when the style has no color.

## Applying Primary and Secondary Styles

```dart
print(theme.primaryText('Primary'));
print(theme.secondaryText('Secondary'));
```
