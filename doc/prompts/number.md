# Number

`Number` collects an integer from the user.

It extends `Prompt<int>` and returns an `int`.

## Basic Number

```dart
final age = await Number(
  prompt: 'Age',
).interact();
```

The result is an `int`:

```dart
final int age = await Number(
  prompt: 'Age',
).interact();
```

The input is parsed using Dart's `int.tryParse`.

## Minimum Value

Use `min` to require a minimum value:

```dart
final age = await Number(
  prompt: 'Age',
  min: 18,
).interact();
```

Values below `18` are rejected and the prompt is shown again.

When `min` is configured, the prompt displays the configured range:

```text
Age (Range: 18 to ∞)
```

## Maximum Value

Use `max` to require a maximum value:

```dart
final age = await Number(
  prompt: 'Age',
  max: 120,
).interact();
```

Values above `120` are rejected and the prompt is shown again.

The prompt displays:

```text
Age (Range: -∞ to 120)
```

## Range

Use both `min` and `max` to define an accepted range:

```dart
final age = await Number(
  prompt: 'Age',
  min: 18,
  max: 120,
).interact();
```

Values below `18` or above `120` are rejected.

The prompt displays:

```text
Age (Range: 18 to 120)
```

## Default Value

Use `defaultValue` to provide a value that is returned when the user presses Enter without entering a value:

```dart
final age = await Number(
  prompt: 'Age',
  defaultValue: 30,
).interact();
```

The prompt displays the default value:

```text
Age [30]
```

Pressing Enter returns `30`.

The default value is returned directly when Enter is pressed; it is not passed through the `min` or `max` checks.

## Combining Range and Default Value

You can combine `min`, `max`, and `defaultValue`:

```dart
final age = await Number(
  prompt: 'Age',
  min: 18,
  max: 120,
  defaultValue: 30,
).interact();
```

The prompt displays:

```text
Age (Range: 18 to 120) [30]
```

## Prompt Formatting

`Number` does not automatically add `:` to the prompt.

For example:

```dart
Number(
  prompt: 'Age',
);
```

The prompt ends with a space:

```text
Age 
```

If you want punctuation at the end of your prompt, include it yourself:

```dart
Number(
  prompt: 'Age:',
);
```

The supplied colon is preserved:

```text
Age: 
```

## Invalid Input

Input is parsed using Dart's `int.tryParse`.

Values that cannot be parsed as an integer are rejected and the prompt is shown again.

For example:

```text
Age abc
Invalid integer number. Please try again.
Age 
```

## Values Outside the Range

When `min` is configured, values below the minimum produce an error:

```text
Number must be at least 18
```

When `max` is configured, values above the maximum produce an error:

```text
Number must be at most 120
```

The prompt is then shown again.

## Result

`Number` extends:

```dart
Prompt<int>
```

Therefore, the result can be assigned directly to an `int`:

```dart
final int age = await Number(
  prompt: 'Age',
).interact();
```

## Constructor

The constructor accepts the prompt text and optional numeric constraints:

```dart
Number({
  required String prompt,
  int? min,
  int? max,
  int? defaultValue,
})
```

For example:

```dart
final age = Number(
  prompt: 'Age',
  min: 18,
  max: 120,
  defaultValue: 30,
);
```

## What's Next?

Continue with [Decimal](decimal.md).
