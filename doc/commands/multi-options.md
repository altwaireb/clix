# Multiple Options

Multiple options accept more than one value.

Use `addMultiOption()` when a command needs a list of values.

## Adding a Multiple Option

```dart
class BuildCommand extends CliCommand<void> {
  BuildCommand() {
    argParser.addMultiOption(
      'define',
      abbr: 'D',
      help: 'Define one or more values.',
    );
  }

  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    final defines = argResults.multiOption('define');

    print(defines);
  }
}
```

The option can be repeated:

```console
myapp build --define debug --define release
```

The result is:

```text
debug
release
```

## Repeating an Option

A multiple option can be supplied more than once:

```console
myapp build -D debug -D release
```

All values are collected into a list.

## Comma-Separated Values

By default, `addMultiOption()` supports comma-separated values:

```console
myapp build --define debug,release,profile
```

The result contains three values:

```text
debug
release
profile
```

## Disabling Comma Splitting

Set `splitCommas` to `false` when commas should remain part of the value:

```dart
argParser.addMultiOption(
  'define',
  splitCommas: false,
  help: 'Define values without comma splitting.',
);
```

For example:

```console
myapp build --define "debug,release"
```

The comma remains inside the value.

## Default Values

Multiple options can define default values:

```dart
argParser.addMultiOption(
  'define',
  defaultsTo: ['debug', 'profile'],
);
```

When no values are supplied, the defaults are returned.

## Allowed Values

Multiple options can restrict their values:

```dart
argParser.addMultiOption(
  'format',
  allowed: ['json', 'yaml', 'xml'],
  help: 'One or more output formats.',
);
```

Every supplied value must satisfy the allowed-value restriction.

## Allowed Value Descriptions

Use `allowedHelp` to describe the available values:

```dart
argParser.addMultiOption(
  'format',
  allowed: ['json', 'yaml'],
  allowedHelp: {
    'json': 'Output JSON data.',
    'yaml': 'Output YAML data.',
  },
);
```

These descriptions are included in usage output.

## Reading Multiple Values

Use `argResults.multiOption()`:

```dart
final formats = argResults.multiOption('format');
```

The result is a `List<String>`.

## When to Use `addMultiOption()`

Use `addMultiOption()` whenever an option represents a collection of values.

For example:

```console
myapp build --define debug --define release
```

Do not use `addOption()` with an `allowMultiple` parameter. Clix 2.0.0 intentionally separates single-value options from multiple-value options:

```dart
argParser.addOption('name');

argParser.addMultiOption('define');
```

This makes the intended option behavior explicit.

## What's Next?

Continue with [Subcommands](subcommands.md) to build command hierarchies.
