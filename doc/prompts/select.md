# Select

`Select` provides an interactive single-choice menu.

It extends `Prompt<int>` and returns the **zero-based index** of the selected option.

## Basic Selection

```dart
final selected = await Select(
  prompt: 'Choose a framework:',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
).interact();
```

If the user selects `Dart`, the result is:

```text
1
```

because the options are zero-based:

```text
0 → Flutter
1 → Dart
2 → Laravel
```

## Default Selection

Use `defaultIndex` to choose the initially highlighted option:

```dart
final selected = await Select(
  prompt: 'Choose a framework:',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  defaultIndex: 1,
).interact();
```

`Dart` is initially selected.

The default index is clamped to the available options. For example, with three options, values below `0` select the first option and values above `2` select the last option.

## Interactive Display

While navigating, the selected option is marked with `❯`:

```text
Choose a framework:
    Flutter
  ❯ Dart
    Laravel

↑↓ Navigate • ↵ Enter to confirm
```

The selected option uses the primary theme style.

After pressing Enter, the selected option is marked with `✓`:

```text
Choose a framework:
    Flutter
  ✓ Dart
    Laravel
```

The help text is hidden after confirmation.

## Keyboard Navigation

The selection menu uses the terminal keyboard:

- `↑` — move up
- `↓` — move down
- `Enter` — confirm the selection

Navigation is circular. Moving down from the last option returns to the first option, and moving up from the first option moves to the last option.

## Help

Help text is enabled by default:

```text
↑↓ Navigate • ↵ Enter to confirm
```

By default, it appears below the options.

Use `helpPosition` to display it above the options:

```dart
final selected = await Select(
  prompt: 'Choose a framework:',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  helpPosition: CliHelpPromptPosition.top,
).interact();
```

To disable the help text:

```dart
final selected = await Select(
  prompt: 'Choose a framework:',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  help: false,
).interact();
```

`CliHelpPromptPosition` is available from the public Clix API.

## Empty Options

`Select` requires at least one option.

Passing an empty list throws a `StateError`:

```dart
Select(
  prompt: 'Choose a framework:',
  options: [],
);
```

## Custom Keyboard

A custom `CliKeyboard` can be provided when you need to control keyboard input:

```dart
final selected = await Select(
  prompt: 'Choose a framework:',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  keyboard: customKeyboard,
).interact();
```

## Result

`Select` extends:

```dart
Prompt<int>
```

The returned integer is the selected option's zero-based index.

To retrieve the selected value:

```dart
final options = [
  'Flutter',
  'Dart',
  'Laravel',
];

final index = await Select(
  prompt: 'Choose a framework:',
  options: options,
).interact();

final selected = options[index];
```

## Constructor

The constructor accepts the prompt, options, and optional selection, help, and keyboard settings:

```dart
Select({
  required String prompt,
  required List<String> options,
  int defaultIndex = 0,
  bool help = true,
  CliHelpPromptPosition helpPosition = CliHelpPromptPosition.bottom,
  CliKeyboard? keyboard,
})
```

## What's Next?

Continue with [Multiple Select](multiple-select.md).
