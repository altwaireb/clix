# Usage

Clix generates usage information for commands and their options.

Usage information is available through the command and runner APIs and is also used by built-in help and usage exceptions.

## Command Usage

A command exposes its usage through:

```dart
final usage = command.usage;
```

The generated usage describes how the command should be invoked.

## Runner Usage

A command runner can print its usage:

```dart
runner.printUsage();
```

The runner usage includes the application's commands and global options.

## Usage Line Length

`CliCommandRunner` accepts an optional `usageLineLength`:

```dart
final runner = CliCommandRunner<void>(
  'myapp',
  'My application.',
  usageLineLength: 80,
);
```

This value controls the line length used when formatting generated usage.

## Option Usage

Options can contribute the following information to usage:

- Short abbreviations
- Long names
- Value placeholders
- Mandatory markers
- Help text
- Allowed values
- Allowed value descriptions
- Default values

For example:

```dart
argParser.addOption(
  'output',
  abbr: 'o',
  valueHelp: 'directory',
  defaultsTo: 'build',
  help: 'The output directory.',
);
```

The generated usage describes the option and its default.

## Flag Usage

Flags are shown according to their configuration.

A negatable flag can expose both forms:

```text
--color
--no-color
```

A non-negatable flag only exposes its positive form.

The `hideNegatedUsage` option can hide the negated form from generated usage while keeping negation supported by the parser.

## Mandatory Options

Mandatory options are marked in usage:

```dart
argParser.addOption(
  'name',
  mandatory: true,
);
```

This makes the requirement visible to users before they execute the command.

## Allowed Values

Allowed values and their descriptions can be included in generated usage:

```dart
argParser.addOption(
  'format',
  allowed: ['json', 'yaml'],
  allowedHelp: {
    'json': 'JSON output.',
    'yaml': 'YAML output.',
  },
);
```

## Defaults

Default values are shown in usage when configured.

For example:

```dart
argParser.addOption(
  'output',
  defaultsTo: 'build',
);
```

The usage indicates that `build` is the default value.

## Hidden Options

Options configured with `hide: true` are omitted from normal usage output.

This is useful for internal or advanced options that should not be displayed as part of the standard interface.

## Separators

Argument parsers can contain separators to organize related options into groups.

Separators affect the visual structure of generated usage without creating command-line arguments themselves.

## Usage Exceptions

Invalid command-line input can result in a `CliUsageException`.

Usage exceptions can include the error and relevant usage information so users can understand how to correct the command.

## What's Next?

The Commands documentation is now complete. Continue with the [Prompts](../prompts/README.md) section.
