# Prompts

Clix provides interactive terminal prompts for collecting and validating user input.

The prompt API is built around the generic `Prompt<T>` class. Each prompt returns a typed result through `interact()`.

## Available Prompts

- `Input` — text input
- `Password` — hidden password input
- `Confirm` — yes/no confirmation
- `Select` — single selection
- `MultiSelect` — multiple selection
- `Number` — integer input
- `Decimal` — decimal (`double`) input
- `Search` — searchable selection

## Basic Usage

Prompts expose an `interact()` method:

```dart
import 'package:clix/clix.dart';

Future<void> main() async {
  final name = await Input(
    prompt: 'What is your name?',
  ).interact();

  print('Hello, $name!');
}
```

When no I/O or theme is passed to `interact()`, Clix uses the current defaults from `CliContext`.

## Typed Results

Every prompt extends `Prompt<T>`, where `T` is the result type.

Examples:

```dart
final String name = await Input(
  prompt: 'Name',
).interact();

final bool confirmed = await Confirm(
  prompt: 'Continue?',
).interact();

final int age = await Number(
  prompt: 'Age',
).interact();

final double price = await Decimal(
  prompt: 'Price',
).interact();

final int framework = await Select(
  prompt: 'Framework',
  options: ['Flutter', 'Dart', 'Laravel'],
).interact();

final List<int> features = await MultiSelect(
  prompt: 'Features',
  options: ['API', 'Auth', 'Testing'],
).interact();
```

## Prompt I/O and Themes

The base `Prompt<T>` API accepts optional `CliIO` and `CliTheme` values through `interact()`:

```dart
final result = await Input(
  prompt: 'Name',
).interact(
  customIO,
  customTheme,
);
```

When either argument is omitted, the corresponding value is taken from the current `CliContext`.

The base prompt API is:

```dart
abstract class Prompt<T> {
  Future<T> run(CliIO io, CliTheme theme);

  Future<T> interact([CliIO? io, CliTheme? theme]);
}
```

## Configure Clix Defaults

Clix provides a central context for the default I/O and theme used by prompts.

Configure them through `Clix.configure()`:

```dart
Clix.configure(
  io: customIO,
  theme: customTheme,
);
```

After configuration, prompts that call `interact()` without explicit arguments use these values.

You can also access the current defaults through:

```dart
Clix.io
Clix.theme
```

The underlying context is available through `CliContext` when direct context access is needed.

## Prompt Documentation

- [Input](input.md)
- [Password](password.md)
- [Confirm](confirm.md)
- [Select](select.md)
- [Multiple Select](multiple-select.md)
- [Number](number.md)
- [Decimal](decimal.md)
- [Search](search.md)

## What's Next?

Continue with the [Logger](../logger/README.md) documentation after exploring the prompts.
