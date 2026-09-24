# Help

Clix provides built-in help support for commands.

Every `CliCommandRunner` and `CliCommand` has a help flag, and the runner also provides a `help` command.

## Help Flag

The standard help flag is:

```console
myapp --help
```

Commands also support:

```console
myapp build --help
```

The help flag prints usage information for the relevant command.

## Help Abbreviation

The help flag has the `-h` abbreviation:

```console
myapp -h
```

and:

```console
myapp build -h
```

## Help Command

Clix registers a built-in `help` command:

```console
myapp help
```

This displays the application's main usage information.

## Command Help

Pass a command name to the help command:

```console
myapp help build
```

This displays the usage information for `build`.

## Nested Command Help

Nested commands can be addressed through the complete command hierarchy:

```console
myapp help package build
```

The help command walks the hierarchy and displays the usage for the requested command.

## Unknown Commands

If the requested help command does not exist:

```console
myapp help unknown
```

Clix reports a usage error.

## Extra Help Arguments

A leaf command cannot receive additional command names through the help command.

For example:

```console
myapp help build extra
```

is rejected when `build` is a leaf command.

## Command Usage

Help output is generated from the command's parser and registered subcommands.

Options, flags, allowed values, defaults, and command descriptions are included according to their configuration.

See [Usage](usage.md) for details.
