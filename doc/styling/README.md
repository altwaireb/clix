# Styling

Clix's styling system is built from `CliColor`, `CliStyle`, and `CliTheme`.
These types are shared by the logger and other interactive terminal components.

## Main Types

- `CliColor` — foreground/background RGB colors.
- `CliStyle` — colors plus text effects.
- `CliTheme` — semantic styles such as `info`, `warn`, `error`, `success`, `primary`, and `secondary`.
- `Spacing` — spaces between elements.
- `Padding` — spaces around text.
- `LineSpacing` — vertical spacing between lines.
- `HintSymbol` — symbols used with hints.
- `IndentLevel` — two-space indentation levels from 0 through 5.
- `TreeSymbol` — Unicode tree branches for hierarchical output.

## Direct Styling

```dart
print(CliColor.cyan('Hello'));

final style = CliStyle()
    .withColor(CliColor.cyan)
    .makeBold();

print(style('Important'));
```

## Theme Styling

```dart
final theme = CliTheme.defaultTheme();

print(theme.primaryText('Primary text'));
print(theme.secondaryText('Secondary text'));
```

## Related Guides

- [Colors](colors.md)
- [Styles](styles.md)
- [Themes](themes.md)
- [Spacing](spacing.md)
- [Padding](padding.md)
- [Line Spacing](line-spacing.md)
- [Hints](hints.md)
- [Indentation](indentation.md)
