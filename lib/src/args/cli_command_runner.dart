// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../core/context/cli_context.dart';
import '../core/style/theme.dart';
import 'cli_arg_parser_exception.dart';
import 'cli_arg_results.dart';
import 'cli_help_command.dart';
import 'cli_parser.dart';
import 'cli_usage_exception.dart';
import 'cli_utils.dart';

export 'cli_usage_exception.dart';

part 'cli_command_runner_layout.dart';

/// A class for invoking [CliCommand]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [CliCommand.run] and
/// [CliCommandRunner.run]; it can be omitted if you're not using the return
/// values.
class CliCommandRunner<T> {
  /// The name of the executable being run.
  ///
  /// Used for error reporting and [usage].
  final String executableName;

  /// A short description of this executable.
  final String description;

  /// A single-line template for how to invoke this executable.
  ///
  /// Defaults to `"$executableName <command> [arguments]"` (if there is no
  /// default command) or `"$executableName [<command>] [arguments]"` (otherwise).
  ///
  /// Subclasses can override this for a more specific template.
  String get invocation {
    var command = '<command>';

    if (argParser.defaultCommand != null) {
      command = '[$command]';
    }

    return '$executableName $command [arguments]';
  }

  /// Generates a string displaying usage information for the executable.
  ///
  /// This includes usage for the global arguments as well as a list of
  /// top-level commands.
  String get usage => _wrap('$description\n\n') + _usageWithoutDescription;

  /// An optional footer for [usage].
  ///
  /// If a subclass overrides this to return a string, it will automatically be
  /// added to the end of [usage].
  String? get usageFooter => null;

  /// Returns [usage] with [description] removed from the beginning.
  String get _usageWithoutDescription {
    return _getCommandUsage(
      _commands,
      lineLength: argParser.usageLineLength,
      defaultCommand: argParser.defaultCommand,
      invocation: invocation,
      optionsUsage: argParser.usage,
      optionsTitle: 'Global options:',
      footerHint:
          'Run "$executableName help <command>" for more information about a command.',
      usageFooter: usageFooter,
      renderer: _layout,
    );
  }

  /// An unmodifiable view of all top-level commands defined for this runner.
  Map<String, CliCommand<T>> get commands => UnmodifiableMapView(_commands);
  final _commands = <String, CliCommand<T>>{};

  /// The top-level argument parser.
  ///
  /// Global options should be registered with this parser; they'll end up
  /// available via [CliCommand.globalResults]. Commands should be registered with
  /// [addCommand] rather than directly on the parser.
  CliParser get argParser => _argParser;
  final CliParser _argParser;

  /// The maximum edit distance allowed when suggesting possible intended
  /// commands.
  ///
  /// Set to `0` in order to disable suggestions, defaults to `2`.
  final int suggestionDistanceLimit;

  final CliCommandRunnerLayout _layout;

  CliCommandRunner(
    this.executableName,
    this.description, {
    CliCommandRunnerLayout? layout,
    int? usageLineLength,
    this.suggestionDistanceLimit = 2,
  }) : _layout = layout ?? CliCommandRunnerLayout(),
       _argParser = CliParser(usageLineLength: usageLineLength) {
    argParser.addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    );
    addCommand(CliHelpCommand<T>());
  }

  /// Prints the usage information for this runner.
  ///
  /// This is called internally by [run] and can be overridden by subclasses to
  /// control how output is displayed or integrate with a logging system.
  void printUsage() => print(usage);

  /// Throws a [CliUsageException] with [message].
  Never usageException(String message) =>
      throw CliUsageException(message, _usageWithoutDescription);

  /// Adds [CliCommand] as a top-level command to this runner.
  ///
  /// If [isDefault] is `true` then added command will be designated as a
  /// default one. Default command is selected if no other sibling command
  /// matches. Only a single leaf-command can be designated as a default.
  void addCommand(CliCommand<T> command, {bool isDefault = false}) {
    if (isDefault && command.subcommands.isNotEmpty) {
      throw ArgumentError('default command must be a leaf command');
    }
    if (isDefault && argParser.defaultCommand != null) {
      throw StateError('default command already defined');
    }
    var names = [command.name, ...command.aliases];
    for (var name in names) {
      _commands[name] = command;
      argParser.addCommand(name, command.argParser);
    }
    if (isDefault) {
      argParser.defaultCommand = command.name;
    }
    command._runner = this;
  }

  /// Parses [args] and invokes [CliCommand.run] on the chosen command.
  ///
  /// This always returns a [Future] in case the command is asynchronous. The
  /// [Future] will throw a [CliUsageException] if [args] was invalid.
  Future<T?> run(Iterable<String> args) =>
      Future.sync(() => runCommand(parse(args)));

  /// Parses [args] and returns the result, converting an [CliArgParserException]
  /// to a [CliUsageException].
  ///
  /// This is notionally a protected method. It may be overridden or called from
  /// subclasses, but it shouldn't be called externally.
  CliArgResults parse(Iterable<String> args) {
    try {
      return argParser.parse(args);
    } on CliArgParserException catch (error) {
      if (error.commands.isEmpty) usageException(error.message);

      var command = commands[error.commands.first]!;
      for (var commandName in error.commands.skip(1)) {
        command = command.subcommands[commandName]!;
      }

      command.usageException(error.message);
    }
  }

  /// Runs the command specified by [topLevelResults].
  ///
  /// This is notionally a protected method. It may be overridden or called from
  /// subclasses, but it shouldn't be called externally.
  ///
  /// It's useful to override this to handle global flags and/or wrap the entire
  /// command in a block. For example, you might handle the `--verbose` flag
  /// here to enable verbose logging before running the command.
  ///
  /// This returns the return value of [CliCommand.run].
  Future<T?> runCommand(CliArgResults topLevelResults) async {
    var argResults = topLevelResults;
    var commands = _commands;
    CliCommand<T>? command;
    var commandString = executableName;

    while (commands.isNotEmpty) {
      if (argResults.command == null) {
        if (argResults.rest.isEmpty) {
          if (command == null) {
            // No top-level command was chosen.
            printUsage();
            return null;
          }

          command.usageException('Missing subcommand for "$commandString".');
        } else {
          var requested = argResults.rest[0];

          // Build up a help message containing similar commands, if found.
          var similarCommands = _similarCommandsText(
            requested,
            commands.values,
          );

          if (command == null) {
            usageException(
              'Could not find a command named "$requested".$similarCommands',
            );
          }

          command.usageException(
            'Could not find a subcommand named '
            '"$requested" for "$commandString".$similarCommands',
          );
        }
      }

      // Step into the command.
      argResults = argResults.command!;
      command = commands[argResults.name]!;
      command._globalResults = topLevelResults;
      command._argResults = argResults;
      commands = command._subcommands;
      commandString += ' ${argResults.name}';

      if (argResults.options.contains('help') && argResults.flag('help')) {
        command.printUsage();
        return null;
      }
    }

    if (topLevelResults.flag('help')) {
      command!.printUsage();
      return null;
    }

    // Make sure there aren't unexpected arguments.
    if (!command!.takesArguments && argResults.rest.isNotEmpty) {
      command.usageException(
        'Command "${argResults.name}" does not take any arguments.',
      );
    }

    return await command.run();
  }

  // Returns help text for commands similar to `name`, in sorted order.
  String _similarCommandsText(String name, Iterable<CliCommand<T>> commands) {
    if (suggestionDistanceLimit <= 0) return '';
    var distances = <CliCommand<T>, int>{};
    var candidates = SplayTreeSet<CliCommand<T>>((a, b) {
      final distanceComparison = distances[a]!.compareTo(distances[b]!);

      if (distanceComparison != 0) {
        return distanceComparison;
      }

      return a.name.compareTo(b.name);
    });
    for (var command in commands) {
      if (command.hidden) continue;
      for (var alias in [
        command.name,
        ...command.aliases,
        ...command.suggestionAliases,
      ]) {
        var distance = _editDistance(name, alias);
        if (distance <= suggestionDistanceLimit) {
          distances[command] = math.min(
            distances[command] ?? distance,
            distance,
          );
          candidates.add(command);
        }
      }
    }
    if (candidates.isEmpty) return '';

    var similar = StringBuffer();
    similar
      ..writeln()
      ..writeln()
      ..writeln('Did you mean one of these?');
    for (var command in candidates) {
      similar.writeln('  ${command.name}');
    }

    return similar.toString();
  }

  String _wrap(String text, {int? hangingIndent}) => wrapText(
    text,
    length: argParser.usageLineLength,
    hangingIndent: hangingIndent,
  );
}

/// A single command.
///
/// A command is known as a "leaf command" if it has no subcommands and is meant
/// to be run. Leaf commands must override [run].
///
/// A command with subcommands is known as a "branch command" and cannot be run
/// itself. It should call [addSubcommand] (often from the constructor) to
/// register subcommands.
abstract class CliCommand<T> {
  /// The name of this command.
  String get name;

  /// A description of this command, included in [usage].
  String get description;

  /// A short description of this command, included in [parent]'s
  /// [CliCommandRunner.usage].
  ///
  /// This defaults to the first line of [description].
  String get summary => description.split('\n').first;

  /// The command's category.
  ///
  /// Displayed in [parent]'s [CliCommandRunner.usage]. Commands with categories
  /// will be grouped together, and displayed after commands without a category.
  String get category => '';

  /// A single-line template for how to invoke this command (e.g. `"pub get
  /// `package`"`).
  String get invocation {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    var invocation = parents.reversed.join(' ');
    if (argParser.defaultCommand != null) {
      return '$invocation [<subcommand>] [arguments]';
    } else if (_subcommands.isNotEmpty) {
      return '$invocation <subcommand> [arguments]';
    } else {
      return '$invocation [arguments]';
    }
  }

  /// The command's parent command, if this is a subcommand.
  ///
  /// This will be `null` until [addSubcommand] has been called with
  /// this command.
  CliCommand<T>? get parent => _parent;
  CliCommand<T>? _parent;

  /// The command runner for this command.
  ///
  /// This will be `null` until [CliCommandRunner.addCommand] has been called with
  /// this command or one of its parents.
  CliCommandRunner<T>? get runner {
    if (parent == null) return _runner;
    return parent!.runner;
  }

  CliCommandRunner<T>? _runner;

  /// The parsed global argument results.
  ///
  /// This will be `null` until just before [CliCommand.run] is called.
  CliArgResults? get globalResults => _globalResults;
  CliArgResults? _globalResults;

  /// The parsed argument results for this command.
  ///
  /// This will be `null` until just before [CliCommand.run] is called.
  CliArgResults? get argResults => _argResults;
  CliArgResults? _argResults;

  /// The argument parser for this command.
  ///
  /// Options for this command should be registered with this parser (often in
  /// the constructor); they'll end up available via [argResults]. Subcommands
  /// should be registered with [addSubcommand] rather than directly on the
  /// parser.
  ///
  /// This can be overridden to change the arguments passed to the `CliParser`
  /// constructor.
  CliParser get argParser => _argParser;
  final _argParser = CliParser();

  /// Generates a string displaying usage information for this command.
  ///
  /// This includes usage for the command's arguments as well as a list of
  /// subcommands, if there are any.
  String get usage => _wrap('$description\n\n') + _usageWithoutDescription;

  /// An optional footer for [usage].
  ///
  /// If a subclass overrides this to return a string, it will automatically be
  /// added to the end of [usage].
  String? get usageFooter => null;

  String _wrap(String text, {int? hangingIndent}) {
    return wrapText(
      text,
      length: argParser.usageLineLength,
      hangingIndent: hangingIndent,
    );
  }

  /// Returns [usage] with [description] removed from the beginning.
  String get _usageWithoutDescription {
    return _getCommandUsage(
      _subcommands,
      isSubcommand: true,
      lineLength: argParser.usageLineLength,
      defaultCommand: argParser.defaultCommand,
      invocation: invocation,
      optionsUsage: argParser.usage,
      footerHint: 'Run "${runner!.executableName} help" to see global options.',
      usageFooter: usageFooter,
      renderer: runner!._layout,
    );
  }

  /// An unmodifiable view of all sublevel commands of this command.
  Map<String, CliCommand<T>> get subcommands =>
      UnmodifiableMapView(_subcommands);
  final _subcommands = <String, CliCommand<T>>{};

  /// Whether or not this command should be hidden from help listings.
  ///
  /// This is intended to be overridden by commands that want to mark themselves
  /// hidden.
  ///
  /// By default, leaf commands are always visible. Branch commands are visible
  /// as long as any of their leaf commands are visible.
  bool get hidden {
    // Leaf commands are visible by default.
    if (_subcommands.isEmpty) return false;

    // Otherwise, a command is hidden if all of its subcommands are.
    return _subcommands.values.every((subcommand) => subcommand.hidden);
  }

  /// Whether or not this command takes positional arguments in addition to
  /// options.
  ///
  /// If false, [CliCommandRunner.run] will throw a [CliUsageException] if arguments
  /// are provided. Defaults to true.
  ///
  /// This is intended to be overridden by commands that don't want to receive
  /// arguments. It has no effect for branch commands.
  bool get takesArguments => true;

  /// Alternate names for this command.
  ///
  /// These names won't be used in the documentation, but they will work when
  /// invoked on the command line.
  ///
  /// This is intended to be overridden.
  List<String> get aliases => const [];

  /// Alternate non-functional names for this command.
  ///
  /// These names won't be used in the documentation, and also they won't work
  /// when invoked on the command line. But if an unknown command is used it
  /// will be matched against this when creating suggestions.
  ///
  /// A name does not have to be repeated both here and in [aliases].
  ///
  /// This is intended to be overridden.
  List<String> get suggestionAliases => const [];

  CliCommand() {
    if (!argParser.allowsAnything) {
      argParser.addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Print this usage information.',
      );
    }
  }

  /// Runs this command.
  ///
  /// The return value is wrapped in a `Future` if necessary and returned by
  /// [CliCommandRunner.runCommand].
  FutureOr<T>? run() {
    throw UnimplementedError(_wrap('Leaf command $this must implement run().'));
  }

  /// Adds [CliCommand] as a subcommand of this.
  ///
  /// If [isDefault] is `true` then added command will be designated as a
  /// default one. Default subcommand is selected if no other sibling subcommand
  /// matches. Only a single leaf-command can be designated as a default.
  void addSubcommand(CliCommand<T> command, {bool isDefault = false}) {
    if (isDefault && command.subcommands.isNotEmpty) {
      throw ArgumentError('default command must be a leaf command');
    }
    if (isDefault && argParser.defaultCommand != null) {
      throw StateError('default command already defined');
    }

    var names = [command.name, ...command.aliases];
    for (var name in names) {
      _subcommands[name] = command;
      argParser.addCommand(name, command.argParser);
    }
    if (isDefault) {
      argParser.defaultCommand = command.name;
    }
    command._parent = this;
  }

  /// Prints the usage information for this command.
  ///
  /// This is called internally by [run] and can be overridden by subclasses to
  /// control how output is displayed or integrate with a logging system.
  void printUsage() => print(usage);

  /// Throws a [CliUsageException] with [message].
  Never usageException(String message) =>
      throw CliUsageException(_wrap(message), _usageWithoutDescription);
}

/// Describes the information needed to display a command in usage output.
///
/// This model contains only presentation data and does not expose the
/// underlying [CliCommand].
class CliCommandInfo {
  const CliCommandInfo({required this.name, required this.summary});

  final String name;
  final String summary;
}

// Represents the presentation data for a single command usage line,
// including its summary and whether it is the default command.
class _CommandUsageLine {
  const _CommandUsageLine({required this.summary, this.isDefault = false});

  final String summary;
  final bool isDefault;
}

/// Groups commands under a category for usage output.
///
/// An empty [name] represents commands that do not belong to a named category.
class CliCommandCategory {
  const CliCommandCategory({required this.name, required this.commands});

  final String name;
  final List<CliCommandInfo> commands;
}

/// Contains the structured data required to render command usage.
///
/// [CliCommandRunner] builds this data from its registered commands and
/// [CliCommandRunnerLayout] is responsible for rendering it.
class CliCommandUsageData {
  const CliCommandUsageData({
    required this.categories,
    required this.defaultCommand,
  });

  final List<CliCommandCategory> categories;
  final String? defaultCommand;
}

// Builds the structured usage data consumed by CliCommandRunnerLayout.
//
// This method filters aliases and hidden commands, groups commands by
// category, and converts commands into presentation data without applying
// any formatting or styling.
CliCommandUsageData _buildCommandUsageData(
  Map<String, CliCommand> commands, {
  String? defaultCommand,
}) {
  // Don't include aliases.
  var names = commands.keys.where(
    (name) => !commands[name]!.aliases.contains(name),
  );

  // Filter out hidden ones, unless they are all hidden.
  var visible = names.where((name) => !commands[name]!.hidden);
  if (visible.isNotEmpty) names = visible;

  // Show names in the order they were first added.
  names = names.toList();

  // Group the commands by category.
  var commandsByCategory = SplayTreeMap<String, List<CliCommand>>();
  for (var name in names) {
    var category = commands[name]!.category;
    commandsByCategory.putIfAbsent(category, () => []).add(commands[name]!);
  }

  final categories = commandsByCategory.entries
      .map(
        (entry) => CliCommandCategory(
          name: entry.key,
          commands: entry.value
              .map(
                (command) => CliCommandInfo(
                  name: command.name,
                  summary: command.summary,
                ),
              )
              .toList(),
        ),
      )
      .toList();

  return CliCommandUsageData(
    categories: categories,
    defaultCommand: defaultCommand,
  );
}

// Builds command usage data and delegates all usage presentation to the
// provided CliCommandRunnerLayout.
//
// This method intentionally keeps formatting and styling out of the runner.
String _getCommandUsage(
  Map<String, CliCommand> commands, {
  bool isSubcommand = false,
  int? lineLength,
  String? defaultCommand,
  String? invocation,
  String? optionsUsage,
  String? optionsTitle,
  String? footerHint,
  String? usageFooter,
  required CliCommandRunnerLayout renderer,
}) {
  final data = _buildCommandUsageData(commands, defaultCommand: defaultCommand);

  return renderer.renderUsage(
    data,
    isSubcommand: isSubcommand,
    invocation: invocation,
    optionsUsage: optionsUsage,
    optionsTitle: optionsTitle,
    footerHint: footerHint,
    usageFooter: usageFooter,
    lineLength: lineLength,
  );
}

/// Returns the edit distance between `from` and `to`.
//
/// Allows for edits, deletes, substitutions, and swaps all as single cost.
///
/// See https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance#Optimal_string_alignment_distance
int _editDistance(String from, String to) {
  // Add a space in front to mimic indexing by 1 instead of 0.
  from = ' $from';
  to = ' $to';
  var distances = [
    for (var i = 0; i < from.length; i++)
      [
        for (var j = 0; j < to.length; j++)
          if (i == 0) j else if (j == 0) i else 0,
      ],
  ];

  for (var i = 1; i < from.length; i++) {
    for (var j = 1; j < to.length; j++) {
      // Removals from `from`.
      var min = distances[i - 1][j] + 1;
      // Additions to `from`.
      min = math.min(min, distances[i][j - 1] + 1);
      // Substitutions (and equality).
      min = math.min(
        min,
        distances[i - 1][j - 1] +
            // Cost is zero if substitution was not actually necessary.
            (from[i] == to[j] ? 0 : 1),
      );
      // Allows for basic swaps, but no additional edits of swapped regions.
      if (i > 1 && j > 1 && from[i] == to[j - 1] && from[i - 1] == to[j]) {
        min = math.min(min, distances[i - 2][j - 2] + 1);
      }
      distances[i][j] = min;
    }
  }

  return distances.last.last;
}
