# Search

`Search` provides an interactive search-and-select prompt.

It extends `Prompt<int>` and returns the index of the selected result.

## Basic Search

A static list can be supplied through `options`:

```dart
final index = await Search(
  prompt: 'Find a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
    'React',
  ],
).interact();
```

The user enters a search query, and matching values are displayed for selection.

For static options, matching is case-insensitive and uses substring matching.

For example, searching for:

```text
lar
```

can match:

```text
Laravel
```

## Dynamic Search

`options` can also be a function.

The function receives the search query and can return results synchronously or asynchronously:

```dart
final index = await Search(
  prompt: 'Find a user',
  options: (query) async {
    return searchUsers(query);
  },
).interact();
```

This allows search results to come from an API, database, or another source.

Dynamic search functions may return a `List<String>` directly or a `Future` containing a list of strings.

If the dynamic search function throws an exception, Search treats the result as empty.

## Minimum Query Length

Use `minQueryLength` to require a minimum number of characters:

```dart
final index = await Search(
  prompt: 'Find a user',
  options: searchUsers,
  minQueryLength: 2,
).interact();
```

The default is `1`.

Queries shorter than `minQueryLength` produce no results and the search starts again.

## Maximum Results

Use `maxResults` to limit the number of displayed search results:

```dart
final index = await Search(
  prompt: 'Find a user',
  options: searchUsers,
  maxResults: 5,
).interact();
```

The default is `10`.

The limit is applied to both static and dynamic search results.

## Default Result

Use `defaultIndex` to choose the initially highlighted result:

```dart
final index = await Search(
  prompt: 'Find a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  defaultIndex: 1,
).interact();
```

The initial selection is `Dart`.

If `defaultIndex` is not provided, the first result is initially selected.

## Help

Help is enabled by default.

The default position is `bottom`:

```text
    Flutter
  ❯ Dart
    Laravel

↑↓ Navigate • ↵ Enter Select • ⇥ Tab Search Again
```

Use `helpPosition` to display help above the results:

```dart
final index = await Search(
  prompt: 'Find a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  helpPosition: CliHelpPromptPosition.top,
).interact();
```

To disable help:

```dart
final index = await Search(
  prompt: 'Find a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  help: false,
).interact();
```

Help is hidden after a result is confirmed.

## Search Controls

After results are displayed:

- `↑` — move up
- `↓` — move down
- `Enter` — select the highlighted result
- `Tab` — return to the search query and search again

Navigation is circular. Moving down from the last result returns to the first result, and moving up from the first result moves to the last result.

## No Results

When no results are found, Search displays:

```text
✗ No results found. Try a different search term.
Press Enter to search again...
```

Press Enter to return to the search query.

## Validation

`Search` accepts a `validator` to validate the selected result.

The validator has this type:

```dart
String? Function(String)
```

For a custom validation rule:

```dart
final index = await Search(
  prompt: 'Find a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  validator: (value) {
    return value == 'Laravel'
        ? 'Laravel is not allowed here.'
        : null;
  },
).interact();
```

Return `null` when the value is valid. Return an error message when it is invalid.

When validation fails, Search displays the error and asks the user to press Enter before searching again.

For example:

```text
✗ Laravel is not allowed here.
Press Enter to search again...
```

You can also use the validation API for reusable rules:

```dart
final index = await Search(
  prompt: 'Choose a framework',
  options: [
    'Flutter',
    'Dart',
    'Laravel',
  ],
  validator: ValidationRules()
      .required()
      .notEquals('Laravel'),
).interact();
```

For the complete validation API, see [Validation](validation/README.md).

## Confirmation

After selecting a result, Search displays a confirmation line before returning:

```text
✓ Find a framework Dart
```

The selected result is returned as its original index.

## Result

`Search` extends:

```dart
Prompt<int>
```

For static options, the returned index refers to the selected value's position in the original list.

```dart
final options = [
  'Flutter',
  'Dart',
  'Laravel',
];

final index = await Search(
  prompt: 'Find a framework',
  options: options,
).interact();

final selected = options[index];
```

For dynamic searches, the returned index refers to the selected value's position in the current search results.

## Prompt Formatting

`Search` writes the supplied prompt directly and does not automatically add `:`.

For example:

```dart
Search(
  prompt: 'Find a framework',
  options: ['Flutter', 'Dart'],
);
```

If you want punctuation, include it yourself:

```dart
Search(
  prompt: 'Find a framework:',
  options: ['Flutter', 'Dart'],
);
```

## Constructor

The constructor accepts the search prompt and options, with optional validation, query, result, help, and keyboard settings:

```dart
Search({
  required String prompt,
  required dynamic options,
  String? Function(String)? validator,
  int minQueryLength = 1,
  int maxResults = 10,
  int? defaultIndex,
  bool help = true,
  CliHelpPromptPosition helpPosition = CliHelpPromptPosition.bottom,
  CliKeyboard? keyboard,
})
```

## What's Next?

Continue with [Multiple Select](multiple-select.md).
