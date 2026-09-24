# Suggestions

Clix can suggest commands when a user enters a command name that does not exist.

For example, if the application defines:

```text
build
clean
publish
```

and the user types:

```console
myapp buil
```

Clix can suggest:

```text
Did you mean "build"?
```

## Command Suggestions

Suggestions are based on the similarity between the supplied command and registered command names.

This helps users recover from simple typing mistakes.

## Suggestion Distance

`CliCommandRunner` provides `suggestionDistanceLimit`:

```dart
final runner = CliCommandRunner<void>(
  'myapp',
  'My application.',
  suggestionDistanceLimit: 2,
);
```

The value controls how far a command can differ from a registered command while still being considered for a suggestion.

## Disabling Suggestions

Suggestions can be disabled by setting the distance limit appropriately for the application.

When no suitable suggestion is available, Clix reports the unknown command through its usage exception.

## Suggestion Aliases

Commands can provide aliases that participate in suggestions without becoming executable aliases:

```dart
@override
List<String> get suggestionAliases => [
  'compile',
];
```

These are different from `aliases`.

- `aliases` are executable.
- `suggestionAliases` are used for suggestions only.

## Hidden Commands

Hidden commands do not appear as normal command choices and are excluded from command suggestions.

This allows internal commands to remain available without being promoted through the normal command interface.

## What's Next?

Continue with [Help](help.md).
