# Confirm

`Confirm` is a boolean prompt for collecting a yes/no decision.

It extends `Prompt<bool>` and returns a `bool`.

## Basic Confirmation

```dart
final confirmed = await Confirm(
  prompt: 'Continue?',
).interact();
```

Without a default value, the prompt displays:

```text
Continue? (y/n)
```

Enter `y` or `yes` to return `true`.

Any other input returns `false`.

## Default Yes

Set `defaultValue` to `true`:

```dart
final confirmed = await Confirm(
  prompt: 'Save changes?',
  defaultValue: true,
).interact();
```

The prompt displays:

```text
Save changes? (Y/n)
```

Pressing Enter returns `true`.

Entering `y` or `yes` also returns `true`.

Any other input returns `false`.

## Default No

Set `defaultValue` to `false`:

```dart
final confirmed = await Confirm(
  prompt: 'Delete file?',
  defaultValue: false,
).interact();
```

The prompt displays:

```text
Delete file? (y/N)
```

Pressing Enter returns `false`.

Entering `y` or `yes` returns `true`.

Any other input returns `false`.

## Default Value

The `defaultValue` parameter is nullable:

```dart
bool? defaultValue
```

Its behavior is:

| `defaultValue` | Prompt | Enter |
| --- | --- | --- |
| `null` | `(y/n)` | `false` |
| `true` | `(Y/n)` | `true` |
| `false` | `(y/N)` | `false` |

## Input

Input is trimmed and compared case-insensitively.

The following values return `true`:

```text
y
yes
Y
YES
```

An empty input uses `defaultValue` when one is provided.

Any other input returns `false`.

## Prompt Formatting

`Confirm` does not automatically add `:` to the prompt.

For example:

```dart
Confirm(
  prompt: 'Continue?',
);
```

The prompt ends with a space:

```text
Continue? (y/n) 
```

If you want punctuation at the end of your prompt, include it yourself:

```dart
Confirm(
  prompt: 'Continue:',
);
```

The supplied colon is preserved:

```text
Continue: (y/n) 
```

## Result

`Confirm` extends:

```dart
Prompt<bool>
```

Therefore, the result can be assigned directly to a `bool`:

```dart
final bool confirmed = await Confirm(
  prompt: 'Continue?',
).interact();
```

## Constructor

The constructor requires `prompt` and optionally accepts `defaultValue`:

```dart
Confirm({
  required String prompt,
  bool? defaultValue,
})
```

For example:

```dart
final confirm = Confirm(
  prompt: 'Are you sure?',
  defaultValue: true,
);
```

## What's Next?

Continue with [Select](select.md).
