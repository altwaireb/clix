# Input

`Input` collects text from the user.

It extends `Prompt<String>` and returns a `String`.

## Basic Input

```dart
final name = await Input(
  prompt: 'What is your name?',
).interact();

print(name);
```

The entered value is trimmed before it is returned.

## Default Value

Use `defaultValue` to provide a value when the user submits an empty response:

```dart
final name = await Input(
  prompt: 'Name',
  defaultValue: 'Guest',
).interact();
```

The prompt displays the default value:

```text
Name [Guest]
```

Pressing Enter returns:

```text
Guest
```

## Validation

Use `validator` to validate the resulting value.

The validator has this type:

```dart
String? Function(String)
```

Return:

- `null` when the value is valid
- an error message when the value is invalid

```dart
final username = await Input(
  prompt: 'Username',
  validator: (value) {
    if (value.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    return null;
  },
).interact();
```

When validation fails, the error is displayed and the prompt is shown again.

## Default Value with Validation

When `defaultValue` is provided and the user submits an empty response, the default value is passed to the validator:

```dart
final username = await Input(
  prompt: 'Username',
  defaultValue: 'guest',
  validator: (value) {
    return value.length < 3 ? 'Too short.' : null;
  },
).interact();
```

This allows the default value to be validated using the same validator as manually entered values.

## Reusable Validation Rules

For reusable or multiple validation rules, use `ValidationRules`:

```dart
final username = await Input(
  prompt: 'Username',
  validator: ValidationRules()
      .required()
      .min(3)
      .max(20),
).interact();
```

You can also use the static `Validator` API:

```dart
final email = await Input(
  prompt: 'Email',
  validator: Validator.rules([
    (value) => Validator.required(value),
    (value) => Validator.email(value),
  ]),
).interact();
```

For the complete validation API, see [Validation](validation/README.md).

## Prompt Formatting

`Input` does not automatically add `:` to the prompt.

For example:

```dart
Input(
  prompt: 'Name',
);
```

The prompt ends with a space:

```text
Name [Guest] 
```

If you want punctuation at the end of your prompt, include it yourself:

```dart
Input(
  prompt: 'Name:',
);
```

The supplied colon is preserved:

```text
Name: [Guest] 
```

## Result

`Input` extends:

```dart
Prompt<String>
```

Therefore, the result can be assigned directly to a `String`:

```dart
final String value = await Input(
  prompt: 'Value',
).interact();
```

## Constructor

The constructor accepts the prompt text and optional default value and validator:

```dart
Input({
  required String prompt,
  String? defaultValue,
  String? Function(String)? validator,
})
```

For example:

```dart
final username = Input(
  prompt: 'Username',
  defaultValue: 'guest',
  validator: (value) {
    if (value.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    return null;
  },
);
```

## What's Next?

Continue with [Password](password.md).
