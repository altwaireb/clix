# Colors and Backgrounds

`CliLogger` provides direct foreground-color methods and background-color methods.

## Foreground Example

```dart
logger.primary('Building Clix...');
```

## Foreground Methods

- `result()`
- `primary()`
- `secondary()`
- `white()`
- `red()`
- `green()`
- `blue()`
- `yellow()`
- `cyan()`

## Background Example

```dart
logger.onError(
  'Build failed',
  padding: Padding.horizontal(1),
);
```

## Background Methods

- `onBackground()`
- `onRed()`
- `onGreen()`
- `onBlue()`
- `onYellow()`
- `onWhite()`
- `onBlack()`
- `onCyan()`
- `onMagenta()`
- `onSuccess()`
- `onError()`
- `onWarn()`
- `onInfo()`
- `onPrimary()`
- `onDarkRed()`
- `onDeepRed()`
- `onMaroon()`

## Important Distinction

These methods are output helpers. When you only need to color a value that will be embedded in another message, use the color/theme API directly instead of logging only to apply color.

For example, color a value first and use it in a message only when a log call is actually needed:

```dart
final packageName = theme.primary('clix');
logger.info('Building $packageName');
```
