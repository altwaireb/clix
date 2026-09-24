# Subcommands

Subcommands let you build hierarchical CLI applications.

For example:

```console
myapp package build
myapp package publish
myapp package clean
```

Here, `package` is a command and `build`, `publish`, and `clean` are subcommands.

## Creating a Subcommand

Create a command normally:

```dart
class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  void run() {
    print('Building...');
  }
}
```

Then add it to another command:

```dart
class PackageCommand extends CliCommand<void> {
  PackageCommand() {
    addSubcommand(BuildCommand());
  }

  @override
  String get name => 'package';

  @override
  String get description => 'Manage packages.';

  @override
  void run() {}
}
```

Register the parent command:

```dart
runner.addCommand(PackageCommand());
```

Users can now run:

```console
myapp package build
```

## Multiple Subcommands

A command can contain multiple subcommands:

```dart
class PackageCommand extends CliCommand<void> {
  PackageCommand() {
    addSubcommand(BuildCommand());
    addSubcommand(PublishCommand());
    addSubcommand(CleanCommand());
  }

  @override
  String get name => 'package';

  @override
  String get description => 'Manage packages.';

  @override
  void run() {}
}
```

This produces a command structure such as:

```text
myapp
└── package
    ├── build
    ├── publish
    └── clean
```

## Nested Subcommands

Subcommands can contain their own subcommands.

```text
myapp
└── package
    └── build
        └── web
```

Users can then run:

```console
myapp package build web
```

This allows Clix applications to model complex command hierarchies.

## Command Arguments

Arguments belong to the command that receives them.

For example:

```console
myapp package build lib
```

`package` and `build` are commands, while `lib` is a positional argument for the leaf command.

See [Arguments](arguments.md) for more information.

## Default Subcommands

A command can define a default subcommand:

```dart
addSubcommand(
  BuildCommand(),
  isDefault: true,
);
```

When the parent command is used without an explicit subcommand, the default command is selected.

See [Default Commands](default-commands.md).

## Command Help

Every command includes help support.

For example:

```console
myapp package --help
```

or:

```console
myapp help package
```

Nested commands can also be inspected:

```console
myapp help package build
```

See [Help](help.md) for more information.

## What's Next?

Continue with [Aliases](aliases.md) to give commands alternative names.
