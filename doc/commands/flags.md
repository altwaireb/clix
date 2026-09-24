# Flags

Flags are boolean command-line options.

They are useful for switches such as:

```console
--verbose
--debug
--force
```

## Adding a Flag

Use `addFlag()`:

```dart
class BuildCommand extends CliCommand<void> {
  BuildCommand() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Enable verbose output.',
    );
  }

  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    if (argResults.flag('verbose')) {
      print('Verbose mode enabled.');
    }
  }
}
```

The flag can be enabled with:

```console
myapp build --verbose
```

## Short Flags

When an abbreviation is defined:

```dart
argParser.addFlag(
  'verbose',
  abbr: 'v',
);
```

Users can write:

```console
myapp build -v
```

## Default Flag Value

Flags default to `false` unless another default is specified.

You can explicitly define the default:

```dart
argParser.addFlag(
  'verbose',
  defaultsTo: false,
);
```

Or enable a flag by default:

```dart
argParser.addFlag(
  'verbose',
  defaultsTo: true,
);
```

## Negatable Flags

Flags are negatable by default.

For example:

```dart
argParser.addFlag(
  'color',
  defaultsTo: true,
);
```

Users can explicitly disable it:

```console
myapp build --no-color
```

And enable it again with:

```console
myapp build --color
```

## Non-Negatable Flags

Disable negation with `negatable: false`:

```dart
argParser.addFlag(
  'verbose',
  negatable: false,
);
```

The command then accepts:

```console
myapp build --verbose
```

but does not expose `--no-verbose`.

## Hiding the Negated Form

You can keep a flag negatable while hiding the negated form from generated usage:

```dart
argParser.addFlag(
  'color',
  hideNegatedUsage: true,
);
```

The parser still supports the negated form.

## Reading a Flag

Use `argResults.flag()`:

```dart
final verbose = argResults.flag('verbose');
```

The result is a `bool`.

## Flag Groups

Short flags can be grouped:

```console
myapp build -vd
```

when `v` and `d` are registered as boolean flags.

This provides a compact command-line form for multiple switches.

## Checking Explicit Parsing

Use `wasParsed()` if you need to distinguish an explicitly supplied flag from its default:

```dart
if (argResults.wasParsed('verbose')) {
  print('Verbose was explicitly selected.');
}
```

## What's Next?

Continue with [Multiple Options](multi-options.md) for options that accept more than one value.
