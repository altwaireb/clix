# Default Commands

Default commands allow a command or command runner to select a command when the user does not explicitly provide one.

This is useful when an application has a natural primary action.

## Default Command on the Runner

A runner can define a default command by registering a command with `isDefault: true`:

```dart
runner.addCommand(
  BuildCommand(),
  isDefault: true,
);
```

If the user runs the application without specifying a command, the default command can be selected.

## Default Subcommand

A command can also define a default subcommand:

```dart
class PackageCommand extends CliCommand<void> {
  PackageCommand() {
    addSubcommand(
      BuildCommand(),
      isDefault: true,
    );

    addSubcommand(PublishCommand());
  }

  @override
  String get name => 'package';

  @override
  String get description => 'Manage packages.';

  @override
  void run() {}
}
```

The following input:

```console
myapp package
```

can select `build` as the default subcommand.

The explicit form remains available:

```console
myapp package build
```

## Only One Default

A command level can have only one default command.

Trying to register multiple default commands at the same level is rejected.

## Default Commands and Arguments

Default commands can still receive arguments.

For example, if `build` is the default command:

```console
myapp lib
```

can be interpreted by the default command according to its argument and option configuration.

## Default Commands and Usage

Generated usage identifies the default command so users can understand which command is selected when no explicit command is supplied.

## What's Next?

Continue with [Suggestions](suggestions.md).
