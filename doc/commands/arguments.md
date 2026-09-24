# Arguments

Arguments are positional values passed to a Clix command.

They are available through the command's `CliArgResults`.

## Accessing Arguments

A command can access its parsed arguments through `argResults`:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    final arguments = argResults.rest;

    print(arguments);
  }
}
```

`rest` contains positional values that remain after option and command parsing.

For example:

```console
myapp build lib test
```

The command receives:

```text
lib
test
```

## Arguments and Options

Arguments are different from named options.

An argument is positional:

```console
myapp build lib
```

An option is named:

```console
myapp build --output lib
```

Clix keeps both concepts separate so commands can define a clear command-line interface.

## Reading Positional Arguments

The `CliArgResults` object exposes the remaining positional arguments through `rest`:

```dart
final arguments = argResults.rest;
```

You can inspect them normally:

```dart
if (argResults.rest.isEmpty) {
  print('No arguments supplied.');
  return;
}

final path = argResults.rest.first;
print('Building $path');
```

## Arguments in a Command

A command can accept positional arguments without adding an option:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build a project path.';

  @override
  void run() {
    final path = argResults.rest.firstOrNull;

    if (path == null) {
      print('A project path is required.');
      return;
    }

    print('Building $path');
  }
}
```

For commands that require a specific number or structure of positional arguments, validate them in the command or application logic.

## Rejecting Arguments

Commands can disable positional arguments by overriding `takesArguments`:

```dart
class VersionCommand extends CliCommand<void> {
  @override
  String get name => 'version';

  @override
  String get description => 'Print the application version.';

  @override
  bool get takesArguments => false;

  @override
  void run() {
    print('2.0.0');
  }
}
```

If positional arguments are supplied to this command, the command runner rejects them.

## Arguments with Subcommands

Arguments can be used together with nested commands:

```console
myapp package build lib
```

The command hierarchy handles `package` and `build` as commands, while `lib` remains a positional argument for the leaf command.

## What's Next?

Continue with [Options](options.md) to learn how to define named values such as `--output` and `--name`.
