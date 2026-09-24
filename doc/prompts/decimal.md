# Decimal

`Decimal` collects a decimal number from the user.

It extends `Prompt<double>` and returns a Dart `double`.

## Basic Decimal Input

```dart
final price = await Decimal(
  prompt: 'Price',
).interact();
```

The result is a `double`:

```dart
final double price = await Decimal(
  prompt: 'Price',
).interact();
```

The input is parsed using Dart's `double.tryParse`.

## Minimum Value

Use `min` to define the minimum accepted value:

```dart
final price = await Decimal(
  prompt: 'Price',
  min: 0.0,
).interact();
```

Values below `0.0` are rejected.

When `min` is configured, the prompt displays the configured range:

```text
Price (Range: 0.0 to ∞)
```

## Maximum Value

Use `max` to define the maximum accepted value:

```dart
final price = await Decimal(
  prompt: 'Price',
  max: 999.99,
).interact();
```

Values above `999.99` are rejected.

The prompt displays:

```text
Price (Range: -∞ to 999.99)
```

## Range

Combine `min` and `max` to define an accepted range:

```dart
final price = await Decimal(
  prompt: 'Price',
  min: 0.0,
  max: 999.99,
).interact();
```

Only values between `0.0` and `999.99` are accepted.

The prompt displays:

```text
Price (Range: 0.0 to 999.99)
```

## Default Value

Use `defaultValue` to provide a value that is returned when the user presses Enter without entering a value:

```dart
final price = await Decimal(
  prompt: 'Price',
  defaultValue: 19.99,
).interact();
```

The prompt displays the default value:

```text
Price [19.99]
```

Pressing Enter returns `19.99`.

When Enter is pressed, the default value is returned directly. It is not passed through the `min` or `max` checks.

## Combining Range and Default Value

You can combine `min`, `max`, and `defaultValue`:

```dart
final price = await Decimal(
  prompt: 'Price',
  min: 0.0,
  max: 999.99,
  defaultValue: 19.99,
).interact();
```

The prompt displays:

```text
Price (Range: 0.0 to 999.99) [19.99]
```

## Prompt Formatting

`Decimal` does not automatically add `:` to the prompt.

For example:

```dart
Decimal(
  prompt: 'Price',
);
```

The prompt ends with a space:

```text
Price 
```

If you want punctuation, include it in the prompt yourself:

```dart
Decimal(
  prompt: 'Price:',
);
```

This preserves the colon:

```text
Price: 
```

## Invalid Input

Values that cannot be parsed as a Dart `double` are rejected.

The prompt displays an error and asks for the value again:

```text
Invalid decimal number. Please try again.
```

For example:

```text
Price abc
Invalid decimal number. Please try again.
Price 
```

## Values Outside the Range

When `min` is configured, values below the minimum are rejected:

```text
Number must be at least 0.0
```

When `max` is configured, values above the maximum are rejected:

```text
Number must be at most 999.99
```

The prompt is then displayed again.

## Result

`Decimal` extends:

```dart
Prompt<double>
```

Therefore, the result can be assigned directly to a `double`:

```dart
final double price = await Decimal(
  prompt: 'Price',
).interact();
```

## Constructor

The constructor accepts the prompt text and optional numeric constraints:

```dart
Decimal({
  required String prompt,
  double? min,
  double? max,
  double? defaultValue,
})
```

For example:

```dart
final price = Decimal(
  prompt: 'Price',
  min: 0.0,
  max: 999.99,
  defaultValue: 19.99,
);
```

## What's Next?

Continue with [Search](search.md).
