# Options

Options are named command-line values.

They are useful when a command needs a value that should be identified by a name.

Examples:

```console
myapp build --output build/
myapp greet --name Abdulmajeed
```

Clix provides `addOption()` for single-value options and `addMultiOption()` for options that can accept multiple values.

## Adding an Option

Use `addOption()` on a command's `argParser`:

```dart
class GreetCommand extends CliCommand<void> {
  GreetCommand() {
    argParser.addOption(
      'name',
      help: 'The name to greet.',
    );
  }

  @override
  String get name => 'greet';

  @override
  String get description => 'Greet a user.';

  @override
  void run() {
    final name = argResults.option('name');

    print('Hello, $name!');
  }
}
```

The option can then be supplied as:

```console
myapp greet --name Abdulmajeed
```

## Short Abbreviations

Options can have a short abbreviation:

```dart
argParser.addOption(
  'name',
  abbr: 'n',
  help: 'The name to greet.',
);
```

Users can then write:

```console
myapp greet --name Abdulmajeed
```

or:

```console
myapp greet -n Abdulmajeed
```

## Attached Values

A short option can also receive its value directly:

```console
myapp greet -nAbdulmajeed
```

An equals sign is also supported:

```console
myapp greet -n=Abdulmajeed
```

Long options support equals syntax as well:

```console
myapp greet --name=Abdulmajeed
```

## Default Values

An option can define a default value:

```dart
argParser.addOption(
  'output',
  defaultsTo: 'build',
  help: 'The output directory.',
);
```

If the user does not provide the option, the default value is available through the results:

```dart
final output = argResults.option('output');
```

## Mandatory Options

An option can be required:

```dart
argParser.addOption(
  'name',
  mandatory: true,
  help: 'The name to use.',
);
```

The command must then receive:

```console
myapp greet --name Abdulmajeed
```

If the mandatory option is missing, Clix reports a parser error.

## Allowed Values

Limit an option to a set of allowed values:

```dart
argParser.addOption(
  'format',
  allowed: ['json', 'yaml', 'xml'],
  help: 'The output format.',
);
```

Valid:

```console
myapp export --format json
```

Invalid values are rejected by the parser.

## Allowed Value Descriptions

Use `allowedHelp` to describe allowed values:

```dart
argParser.addOption(
  'format',
  allowed: ['json', 'yaml'],
  allowedHelp: {
    'json': 'Output JSON data.',
    'yaml': 'Output YAML data.',
  },
  help: 'The output format.',
);
```

The descriptions are included in generated usage information.

## Hidden Options

An option can be hidden from usage output:

```dart
argParser.addOption(
  'internal',
  hide: true,
);
```

The option remains available to the parser but is omitted from normal usage information.

## Reading an Option

Use `argResults.option()`:

```dart
final name = argResults.option('name');
```

The returned value is nullable because an option may not have been supplied and may not have a default value.

## Checking Whether an Option Was Parsed

Use `wasParsed()` when you need to know whether the user explicitly supplied an option:

```dart
if (argResults.wasParsed('name')) {
  print('The user supplied a name.');
}
```

`wasParsed()` tells you whether the option was explicitly provided by the
user.

This is different from checking the option's value because a value may come from a default.

## Multiple Values

Do not use `addOption()` for multiple values.

Use `addMultiOption()` instead:

```dart
argParser.addMultiOption(
  'define',
  abbr: 'D',
  help: 'Define one or more values.',
);
```

See [Multiple Options](multi-options.md) for details.

## What's Next?

Continue with [Flags](flags.md) to learn how to define boolean switches.
