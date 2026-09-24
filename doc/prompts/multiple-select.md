# Multiple Select

`MultiSelect` provides an interactive menu for selecting multiple options.

It extends `Prompt<List<int>>` and returns a `List<int>` containing the selected option indexes.

## Basic Multiple Selection

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Authentication',
    'Database',
    'Testing',
  ],
).interact();
```

If the user selects `API` and `Testing`, the result is:

```text
[0, 3]
```

The returned indexes are zero-based.

## Default Selections

Use `defaults` to preselect options by their indexes:

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Authentication',
    'Database',
    'Testing',
  ],
  defaults: [0, 3],
).interact();
```

`API` and `Testing` start selected.

## Interactive Display

During selection, the current option is marked with `❯` and selected options use `◉`:

```text
Choose features:
  ❯ ◉ API
    ○ Authentication
    ◉ Database
    ○ Testing

↑↓ Navigate • ␣ Space to select  • ↵ Enter to confirm
```

The current option uses the primary theme style.

After pressing Enter, the prompt is rendered as a confirmed list:

```text
Choose features:
  ✓ API
    Authentication
  ✓ Database
    Testing
```

Selected options use a success check mark and primary text. Unselected options use the gray theme style.

## Help

Help is enabled by default.

The default position is `top`:

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Database',
    'Testing',
  ],
).interact();
```

To display help below the options:

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Database',
    'Testing',
  ],
  helpPosition: CliHelpPromptPosition.bottom,
).interact();
```

To disable help:

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Database',
    'Testing',
  ],
  help: false,
).interact();
```

`CliHelpPromptPosition` is available from the public Clix API.

## Minimum Selections

Use `minimumOptions` to require a minimum number of selected options before Enter can confirm the prompt.

The default is `0`:

```dart
final selected = await MultiSelect(
  prompt: 'Choose at least two features:',
  options: [
    'API',
    'Authentication',
    'Database',
    'Testing',
  ],
  minimumOptions: 2,
).interact();
```

When fewer than two options are selected, pressing Enter does not confirm the prompt.

## Maximum Selections

Use `maximumOptions` to limit the number of selected options:

```dart
final selected = await MultiSelect(
  prompt: 'Choose up to two features:',
  options: [
    'API',
    'Authentication',
    'Database',
    'Testing',
  ],
  maximumOptions: 2,
).interact();
```

When the maximum number of selections has been reached, selecting another unselected option has no effect.

Already selected options can still be deselected.

By default, there is no maximum:

```dart
maximumOptions: null
```

## Minimum and Maximum Together

You can combine `minimumOptions` and `maximumOptions`:

```dart
final selected = await MultiSelect(
  prompt: 'Choose two to four features:',
  options: [
    'API',
    'Authentication',
    'Database',
    'Testing',
    'Caching',
  ],
  minimumOptions: 2,
  maximumOptions: 4,
).interact();
```

The constructor rejects invalid configurations where:

- `minimumOptions` is less than `0`
- `maximumOptions` is less than `0`
- `minimumOptions` is greater than `maximumOptions`
- `maximumOptions` is greater than the number of options

These validations are performed when the `MultiSelect` instance is created.

## Keyboard Controls

The menu supports:

- `↑` — move up
- `↓` — move down
- `Space` — toggle the current option
- `Enter` — confirm the selection

Navigation is circular. Moving down from the last option returns to the first option, and moving up from the first option moves to the last option.

When `maximumOptions` has been reached, Space cannot select another unselected option, but it can still deselect the current selected option.

When `minimumOptions` has not been reached, Enter does not confirm the selection.

## Result

`MultiSelect` extends:

```dart
Prompt<List<int>>
```

The returned indexes are zero-based.

To retrieve the selected values:

```dart
final options = [
  'API',
  'Database',
  'Testing',
];

final indexes = await MultiSelect(
  prompt: 'Choose features:',
  options: options,
).interact();

final selected = [
  for (final index in indexes) options[index],
];
```

## Empty Selection

The default `minimumOptions` is `0`, so the user can confirm without selecting an option.

In that case, the returned list is empty:

```text
[]
```

If `minimumOptions` is greater than `0`, the user must select enough options before Enter can confirm the prompt.

## Options

`options` must contain at least one item.

If `options` is empty, `MultiSelect` throws a `StateError` when the prompt runs.

## Custom Keyboard

A custom `CliKeyboard` can be provided:

```dart
final selected = await MultiSelect(
  prompt: 'Choose features:',
  options: [
    'API',
    'Database',
    'Testing',
  ],
  keyboard: customKeyboard,
).interact();
```

## Constructor

The constructor accepts the prompt, options, selection defaults, help configuration, selection limits, and an optional keyboard:

```dart
MultiSelect({
  required String prompt,
  required List<String> options,
  List<int> defaults = const [],
  bool help = true,
  CliHelpPromptPosition helpPosition = CliHelpPromptPosition.top,
  int minimumOptions = 0,
  int? maximumOptions,
  CliKeyboard? keyboard,
})
```

## What's Next?

Continue with [Number](number.md).
