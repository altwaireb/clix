# ValidationRules

`ValidationRules` provides a fluent builder for composing validation rules.

It supports two usage patterns:

1. Build a reusable validator.
2. Provide a value in the constructor and validate while chaining.

## Reusable Validator

Create a rule chain without a value:

```dart
final validator = ValidationRules()
    .required()
    .min(8)
    .email();
```

Because `ValidationRules` is callable, use it as a validator:

```dart
final error = validator(value);
```

This is especially useful with prompts:

```dart
final email = await Input(
  prompt: 'Email',
  validator: ValidationRules()
      .required()
      .email(),
).interact();
```

## Direct Validation

A value can be supplied to the constructor:

```dart
final result = ValidationRules('user@example.com')
    .required()
    .email();
```

When a value is provided, rules execute as they are added and return the first validation error when one occurs.

## Rule Methods

`ValidationRules` provides fluent versions of the `Validator` methods:

```text
required()
min()
max()
email()
pattern()
alpha()
alphaNumeric()
numeric()
url()
startsWith()
endsWith()
contains()
notContains()
inList()
notInList()
alphaDash()
lowercase()
uppercase()
containsUppercase()
containsLowercase()
containsDigit()
containsSpecial()
lengthBetween()
equals()
notEquals()
```

Each rule accepts the same validation parameters as its corresponding `Validator` method.

## Example: Password Rules

```dart
final passwordValidator = ValidationRules()
    .required()
    .min(8)
    .containsUppercase()
    .containsLowercase()
    .containsDigit()
    .containsSpecial();

final password = await Password(
  prompt: 'Password',
  validator: passwordValidator,
).interact();
```

## Custom Messages

Each built-in rule accepts an optional `message`:

```dart
final validator = ValidationRules()
    .required(message: 'Please enter a value.')
    .min(
      8,
      message: 'Use at least 8 characters.',
    );
```

## Character Count Rules

The following rules accept `min` and optional `max`:

```dart
.containsUppercase(min: 1, max: 3)
.containsLowercase(min: 1, max: 3)
.containsDigit(min: 1, max: 2)
.containsSpecial(min: 1, max: 2)
```

## Custom Rule

Use `custom()` to add your own validation function:

```dart
final validator = ValidationRules()
    .required()
    .custom((value) {
      if (value.contains('password')) {
        return 'Password cannot contain the word "password".';
      }

      return null;
    });
```

The custom function follows the same contract:

```dart
String? Function(String)
```

Return `null` for valid input or an error message for invalid input.

## Rule Order

Rules execute in the order in which they were added.

```dart
final validator = ValidationRules()
    .required()
    .min(8)
    .email();
```

If `required()` fails, the later rules are not reached for that validation.

## `ruleCount`

Returns the number of configured rules:

```dart
final validator = ValidationRules()
    .required()
    .min(8)
    .email();

print(validator.ruleCount); // 3
```

## `clear()`

Removes all configured rules and returns the same `ValidationRules` instance:

```dart
final validator = ValidationRules()
    .required()
    .min(8);

validator.clear();

print(validator.ruleCount); // 0
```

## `describe()`

Returns a human-readable description of the number of configured rules:

```dart
final validator = ValidationRules()
    .required()
    .min(8)
    .email();

print(validator.describe());
```

For three configured rules, the current implementation returns:

```text
Validation rules: 3 rules configured
```

With no rules:

```text
No validation rules
```

## Validation Result

Like `Validator`, validation returns:

```text
null
```

for valid input, or a `String` containing the first error.

## What's Next?

Return to the [Prompts](../README.md) documentation.
