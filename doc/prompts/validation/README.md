# Validation

Clix includes validation utilities designed to work directly with interactive prompts.

The validation API has two complementary parts:

- `Validator` — static validation methods.
- `ValidationRules` — a fluent builder for composing reusable validation rules.

Both return `null` when the value is valid and an error message when it is invalid.

## Using Validation with Prompts

The most common use is passing a validator to a prompt:

```dart
final email = await Input(
  prompt: 'Email',
  validator: (value) => Validator.email(value),
).interact();
```

You can also compose several rules:

```dart
final password = await Input(
  prompt: 'Password',
  validator: ValidationRules()
      .required()
      .min(8)
      .containsUppercase()
      .containsDigit()
      .containsSpecial(),
).interact();
```

`ValidationRules` is callable, so it can be supplied directly where a validator function is expected.

## Validation Result

Validation functions use this convention:

```dart
null
```

means the value is valid.

A `String` means validation failed:

```dart
'This field is required'
```

Custom messages can be supplied to individual rules.

## API

- [Validator](validator.md)
- [ValidationRules](validation-rules.md)

## Rule Categories

### Basic

- `required`
- `min`
- `max`
- `lengthBetween`

### Format

- `email`
- `url`
- `pattern`

### Character Content

- `alpha`
- `alphaNumeric`
- `numeric`
- `alphaDash`
- `lowercase`
- `uppercase`
- `containsUppercase`
- `containsLowercase`
- `containsDigit`
- `containsSpecial`

### String Relationships

- `startsWith`
- `endsWith`
- `contains`
- `notContains`
- `equals`
- `notEquals`

### Lists

- `inList`
- `notInList`

### Composition

- `Validator.rules()`
- `ValidationRules.custom()`

## Related Prompts

Validation is designed to work with interactive prompts. See the prompt documentation for practical examples:

- [Input](../input.md) — text input with custom and reusable validation.
- [Password](../password.md) — password policies using `ValidationRules`.
- [Search](../search.md) — validation of the selected result.

## What's Next?

Return to the [Prompts](../README.md) documentation.
