# Basic Commands

A command in Clix is a class that extends `CliCommand<T>`.

A command defines three main things:

- Its name
- Its description
- Its execution logic

## Creating a Command

Create a command by extending `CliCommand<T>`:

```dart
import 'dart:async';

import 'package:clix/clix.dart';

class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  FutureOr<void> run() {
    print('Building project...');
  }
}
```

## Registering a Command

Create a `CliCommandRunner` and register the command:

```dart
import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'myapp',
    'My command-line application.',
  );

  runner.addCommand(BuildCommand());

  await runner.run(args);
}
```

The command can now be executed with:

```console
myapp build
```

## Command Name

The `name` getter defines the command name:

```dart
@override
String get name => 'build';
```

The name is what users type after the executable name:

```console
myapp build
```

## Command Description

The `description` getter provides information about the command:

```dart
@override
String get description => 'Build the project.';
```

The description is displayed in command usage and help output.

## Command Summary

Clix derives the command summary from the first line of the description.

For example:

```dart
@override
String get description => '''
Build the project.

This command compiles the project and generates the required files.
''';
```

The command summary is:

```text
Build the project.
```

## Command Results

Commands are generic:

```dart
CliCommand<T>
```

The type parameter represents the command result.

### No Result

Use `void` when the command does not return a value:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    print('Build complete.');
  }
}
```

### Returning a Value

Use another type when the command needs to return a value:

```dart
class VersionCommand extends CliCommand<String> {
  @override
  String get name => 'version';

  @override
  String get description => 'Print the application version.';

  @override
  String run() {
    return '2.0.0';
  }
}
```

The runner receives the returned value:

```dart
final runner = CliCommandRunner<String>(
  'myapp',
  'My application.',
);

runner.addCommand(VersionCommand());

final result = await runner.run(['version']);
```

`result` contains:

```text
2.0.0
```

## Synchronous Commands

A command can return its result synchronously:

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

## Asynchronous Commands

A command can also perform asynchronous work:

```dart
class BuildCommand extends CliCommand<int> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  Future<int> run() async {
    await buildProject();

    return 0;
  }
}
```

Both forms are supported by Clix.

## Process Exit Codes

When a command returns an `int`, the application can use that value as its process exit code.

```dart
import 'dart:io';

final result = await runner.run(args);

if (result != null) {
  exit(result);
}
```

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

A failing command could return another code:

```dart
class BuildCommand extends CliCommand<int> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  int run() {
    return 1;
  }
}
```

Clix returns the value to the application. The application is responsible for deciding whether to pass it to `exit()`.

## What's Next?

Continue with [Arguments](arguments.md) to learn how to accept positional values from users.
