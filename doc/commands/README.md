# Commands

Clix provides a complete command-line command system for building structured CLI applications.

Commands let you define:

- Commands and subcommands
- Arguments
- Options
- Flags
- Multiple-value options
- Aliases
- Default commands
- Command suggestions
- Built-in help
- Usage information

Commands are built around `CliCommandRunner<T>` and `CliCommand<T>`.

## Command Structure

A Clix application typically starts with a command runner:

```dart
import 'package:clix/clix.dart';

void main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'myapp',
    'My command-line application.',
  );

  runner.addCommand(BuildCommand());
  runner.addCommand(CleanCommand());

  await runner.run(args);
}
```

Each command is represented by a class extending `CliCommand<T>`:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    // Build logic.
  }
}
```

## Command Result Types

`CliCommand<T>` is generic. The generic type represents the value returned by the command.

For example:

```dart
class BuildCommand extends CliCommand<int> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  int run() {
    return 0;
  }
}
```

Commands can return synchronous or asynchronous results.

### Synchronous

```dart
int run() {
  return 0;
}
```

### Asynchronous

```dart
Future<int> run() async {
  await buildProject();

  return 0;
}
```

The command contract uses `FutureOr<T>`, so both forms are supported.

The result can also be used by the application as a process exit code:

```dart
final result = await runner.run(args);

if (result != null) {
  exit(result);
}
```

Clix does not automatically terminate the process. The application decides how to use the command result.

## Command Runner

`CliCommandRunner<T>` manages the application's commands and executes them based on the command-line arguments.

```dart
final runner = CliCommandRunner<void>(
  'myapp',
  'My command-line application.',
);
```

Register commands with `addCommand()`:

```dart
runner.addCommand(BuildCommand());
runner.addCommand(CleanCommand());
```

Then execute the runner:

```dart
await runner.run(args);
```

## Command Topics

The Commands documentation is divided into the following sections:

- [Basic Commands](basic-commands.md)
- [Arguments](arguments.md)
- [Options](options.md)
- [Flags](flags.md)
- [Multiple Options](multi-options.md)
- [Subcommands](subcommands.md)
- [Aliases](aliases.md)
- [Default Commands](default-commands.md)
- [Suggestions](suggestions.md)
- [Help](help.md)
- [Usage](usage.md)
