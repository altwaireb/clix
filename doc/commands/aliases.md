# Aliases

Aliases provide alternative names for commands.

They are useful when a command should be accessible through a shorter or familiar name.

## Defining Aliases

Override the `aliases` getter:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  List<String> get aliases => ['b'];

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    print('Building...');
  }
}
```

The command can now be invoked as:

```console
myapp build
```

or:

```console
myapp b
```

Both names execute the same command.

## Multiple Aliases

A command can have more than one alias:

```dart
@override
List<String> get aliases => [
  'b',
  'compile',
];
```

The following commands then refer to the same command:

```console
myapp build
myapp b
myapp compile
```

## Alias Hierarchies

Aliases also work with nested commands.

For example:

```text
myapp package build
```

can have aliases:

```text
package → pkg
build   → b
```

Users can then invoke:

```console
myapp pkg b
```

The complete command hierarchy is resolved through the aliases.

## Aliases Are Executable

Functional aliases are actual command names.

If `b` is an alias for `build`, running:

```console
myapp b
```

executes `BuildCommand`.

## Aliases in Usage

Aliases are intended for command invocation and are not listed as separate commands in generated usage documentation.

The canonical command name remains the documented command name.

## Suggestion Aliases

Clix also supports `suggestionAliases`.

These aliases are used only when generating suggestions and are not executable command names.

For example:

```dart
@override
List<String> get suggestionAliases => [
  'compile',
];
```

The alias can help command suggestions without creating another executable command.

## What's Next?

Continue with [Default Commands](default-commands.md).
