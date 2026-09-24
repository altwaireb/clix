# Styles

`CliStyle` combines foreground/background colors with terminal text effects.

## Create a Style

```dart
final style = CliStyle(
  color: CliColor.white,
  backgroundColor: CliColor.error,
  bold: true,
  underline: true,
);

print(style('Critical error'));
```

## Style Modifiers

Modifiers return a new `CliStyle`, so they can be chained:

```dart
final style = CliStyle()
    .withColor(CliColor.cyan)
    .makeBold()
    .makeUnderline();
```

Available modifiers:

- `withColor()`
- `withBackgroundColor()`
- `makeBold()`
- `makeItalic()`
- `makeUnderline()`
- `makeStrikethrough()`
- `makeDim()`
- `makeBlink()`
- `makeReverse()`

## Apply a Style

```dart
print(style('Styled text'));
```

`CliStyle` is callable; `style.call('Styled text')` is equivalent.

## Plain Style

```dart
final plain = CliStyle.plain();
```

`plain()` creates a style with no color, background, or effects.

## Built-in Symbols

`CliStyle` also exposes symbols used by interactive terminal UI, including selection, checkbox, radio, navigation, progress, and status symbols.

Examples:

```dart
CliStyle.selectedPrefix // ❯
CliStyle.checkedBox     // ☑
CliStyle.radioSelected  // ●
CliStyle.upArrow        // ↑
CliStyle.filledProgress // █
CliStyle.completed      // ✓
```
