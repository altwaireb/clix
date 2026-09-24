# Validation

Validation can be combined directly with prompts.

## Input

```dart
final email = await Input(
  prompt: 'Email',
  validator: ValidationRules()
      .required()
      .email(),
).interact();
```

## Password

A password policy can be composed from multiple rules:

```dart
final password = await Password(
  prompt: 'Password',
  validator: ValidationRules()
      .required()
      .min(8)
      .containsUppercase()
      .containsLowercase()
      .containsDigit()
      .containsSpecial(),
).interact();
```

## Static Validator

The static `Validator` API can be composed when individual rules are preferred:

```dart
final email = await Input(
  prompt: 'Email',
  validator: Validator.rules([
    (value) => Validator.required(value),
    (value) => Validator.email(value),
  ]),
).interact();
```

See [Validation](../prompts/validation/README.md) for the complete validation API.
