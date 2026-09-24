# Validator

`Validator` is a collection of static validation methods.

Every validator receives a `String` and returns:

- `null` when valid.
- `String` containing an error message when invalid.

## Basic Usage

```dart
final error = Validator.required(value);

if (error != null) {
  print(error);
}
```

## Custom Error Messages

Every validation method accepts an optional `message`:

```dart
final error = Validator.email(
  value,
  message: 'Enter a valid email address.',
);
```

When supplied, the custom message is returned instead of the default message.

## Required

Requires a non-empty value after trimming whitespace.

```dart
Validator.required('hello'); // null
Validator.required('');      // error
Validator.required('   ');   // error
```

```dart
Validator.required(value);
```

Default message:

```text
This field is required
```

## Minimum Length

Requires at least `minLength` characters:

```dart
Validator.min('hello', 3); // null
Validator.min('hi', 3);    // error
```

Default message:

```text
Must be at least 3 characters
```

## Maximum Length

Requires no more than `maxLength` characters:

```dart
Validator.max('hello', 10); // null
Validator.max('hello', 3);  // error
```

Default message:

```text
Must be no more than 3 characters
```

## Email

Validates an email using Clix's email regular expression:

```dart
Validator.email('user@example.com');
```

Default message:

```text
Please enter a valid email address
```

## Pattern

Requires the value to match a supplied `RegExp`:

```dart
Validator.pattern(
  value,
  RegExp(r'^[A-Z]+$'),
);
```

Default message:

```text
Invalid format
```

## Alphabetic

Allows letters only:

```dart
Validator.alpha('hello');    // null
Validator.alpha('hello123'); // error
```

Default message:

```text
Only letters are allowed
```

## Alphanumeric

Allows letters and numbers:

```dart
Validator.alphaNumeric('hello123'); // null
Validator.alphaNumeric('hello@123'); // error
```

Default message:

```text
Only letters and numbers are allowed
```

## Numeric

Allows numbers only:

```dart
Validator.numeric('12345'); // null
Validator.numeric('123abc'); // error
```

Default message:

```text
Only numbers are allowed
```

## URL

Requires an HTTP or HTTPS URL with a non-empty host:

```dart
Validator.url('https://example.com'); // null
Validator.url('invalid-url');          // error
```

Default message:

```text
Please enter a valid URL
```

## Starts With

Requires a specific prefix:

```dart
Validator.startsWith(
  'https://example.com',
  'https://',
);
```

Default message:

```text
Must start with "https://"
```

## Ends With

Requires a specific suffix:

```dart
Validator.endsWith(
  'report.pdf',
  '.pdf',
);
```

Default message:

```text
Must end with ".pdf"
```

## Contains

Requires the value to contain a substring:

```dart
Validator.contains(
  'hello@example.com',
  '@',
);
```

Default message:

```text
Must contain "@"
```

## Not Contains

Requires the value not to contain a substring:

```dart
Validator.notContains(
  'username',
  ' ',
);
```

Default message:

```text
Must not contain " "
```

## In List

Requires the value to be one of the supplied strings:

```dart
Validator.inList(
  'red',
  ['red', 'green', 'blue'],
);
```

Default message:

```text
Must be one of: red, green, blue
```

## Not In List

Requires the value not to be one of the supplied strings:

```dart
Validator.notInList(
  'admin',
  ['admin', 'root'],
);
```

Default message:

```text
Cannot be one of: admin, root
```

## Alpha Dash

Allows letters, numbers, dashes, and underscores:

```dart
Validator.alphaDash('hello_world-123'); // null
Validator.alphaDash('hello@world');     // error
```

Default message:

```text
Only letters, numbers, dashes, and underscores are allowed
```

## Lowercase

Requires the value to equal its lowercase representation:

```dart
Validator.lowercase('hello world'); // null
Validator.lowercase('Hello World'); // error
```

Default message:

```text
Must be lowercase
```

## Uppercase

Requires the value to equal its uppercase representation:

```dart
Validator.uppercase('HELLO WORLD'); // null
Validator.uppercase('Hello World'); // error
```

Default message:

```text
Must be uppercase
```

## Contains Uppercase

Requires a minimum number of uppercase ASCII letters.

```dart
Validator.containsUppercase(
  'Hello',
  min: 1,
);
```

Arguments:

- `min` — minimum count; defaults to `1`.
- `max` — optional maximum count.

Examples:

```dart
Validator.containsUppercase('Hello'); // null
Validator.containsUppercase('hello'); // error
Validator.containsUppercase('HELLO', max: 2); // error
```

## Contains Lowercase

Requires a minimum number of lowercase ASCII letters.

```dart
Validator.containsLowercase(
  'Hello',
  min: 1,
);
```

Arguments:

- `min` — minimum count; defaults to `1`.
- `max` — optional maximum count.

## Contains Digit

Requires a minimum number of digits:

```dart
Validator.containsDigit(
  'hello123',
  min: 2,
);
```

Arguments:

- `min` — minimum count; defaults to `1`.
- `max` — optional maximum count.

## Contains Special

Counts characters that are not ASCII letters or digits:

```dart
Validator.containsSpecial(
  'hello!@',
  min: 1,
);
```

Arguments:

- `min` — minimum count; defaults to `1`.
- `max` — optional maximum count.

## Length Between

Requires the value length to be within an inclusive range:

```dart
Validator.lengthBetween(
  'hello',
  3,
  8,
);
```

Both boundaries are inclusive.

Default message:

```text
Must be between 3 and 8 characters
```

## Equals

Requires exact string equality:

```dart
Validator.equals(
  'password',
  'password',
);
```

Default message:

```text
Values do not match
```

## Not Equals

Requires the value to differ from the forbidden string:

```dart
Validator.notEquals(
  'username',
  'admin',
);
```

Default message:

```text
Value cannot be "admin"
```

## Combining Validators

`Validator.rules()` creates one validator from several validators.

The validators run in order and the first error is returned:

```dart
final validateEmail = Validator.rules([
  (value) => Validator.required(value),
  (value) => Validator.email(value),
]);

final error = validateEmail('invalid');
```

This is useful when a prompt needs several independent checks.

## Using with a Prompt

```dart
final email = await Input(
  prompt: 'Email',
  validator: Validator.rules([
    (value) => Validator.required(value),
    (value) => Validator.email(value),
  ]),
).interact();
```

## What's Next?

For fluent validation chains, see [ValidationRules](validation-rules.md).
