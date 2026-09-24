# Colors

`CliColor` represents an RGB terminal color and can be used as a function to wrap text with ANSI color codes.

## RGB

```dart
final purple = CliColor.rgb(128, 0, 128);
print(purple('Purple text'));
```

The RGB components are integers from 0 to 255.

## Hex

```dart
final orange = CliColor.hex('#FF5733');
final blue = CliColor.hex('0066CC');
```

The hex value must contain exactly six hexadecimal characters after removing `#`. Invalid length throws `ArgumentError`.

## Foreground Color

```dart
print(CliColor.success('Done'));
print(CliColor.error('Failed'));
```

## Background Color

```dart
print(CliColor.warning.background('Warning'));
```

## Foreground + Background

```dart
print(CliColor.withBackground(
  'Important',
  textColor: CliColor.white,
  backgroundColor: CliColor.error,
));
```

If both colors are omitted, the original text is returned unchanged.

## Predefined Colors

### Brand

`primary`, `secondary`

### Basic

`red`, `green`, `blue`, `yellow`, `cyan`, `magenta`, `white`, `black`

### Extended

`orange`, `purple`, `pink`, `brown`, `gray`, `darkGray`, `lightGray`

### Semantic

`success`, `warning`, `error`, `info`

### High Contrast

`brightYellow`, `brightCyan`, `lightYellow`, `darkCyan`

### Red Variants

`darkRed`, `deepRed`, `maroon`
