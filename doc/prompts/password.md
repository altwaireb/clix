# Password

`Password` collects hidden terminal input and returns a `String`.

## Basic Password

```dart
final password = await Password(
  prompt: 'Password',
).interact();
```

The entered characters are not echoed normally to the terminal.

## Default Value

Use `defaultValue` when an empty password should use a predefined value:

```dart
final password = await Password(
  prompt: 'Password',
  defaultValue: 'secret',
).interact();
```

## Validation

`Password` accepts a `validator` to validate the entered password.

For a simple custom rule:

```dart
final password = await Password(
  prompt: 'Password',
  validator: (value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  },
).interact();
```

For a password policy with multiple rules, use `ValidationRules`:

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

The rules are evaluated in order and the first validation error is returned.

For the complete validation API, see [Validation](validation/README.md).

## Confirmation

Enable `confirmation` when the password must be entered twice:

```dart
final password = await Password(
  prompt: 'Password',
  confirmation: true,
).interact();
```

Clix compares the two values and asks again when they do not match.

## Custom Confirmation Prompt

Use `confirmPrompt` to customize the second question:

```dart
final password = await Password(
  prompt: 'Password',
  confirmation: true,
  confirmPrompt: 'Repeat password',
).interact();
```

## Custom Confirmation Error

Use `confirmError` to customize the mismatch message:

```dart
final password = await Password(
  prompt: 'Password',
  confirmation: true,
  confirmError: 'The passwords are different.',
).interact();
```

## Result

`Password` extends:

```dart
Prompt<String>
```

## What's Next?

Continue with [Confirm](confirm.md).
