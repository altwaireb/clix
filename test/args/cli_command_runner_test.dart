import 'dart:async';

import 'package:clix/clix.dart';
import 'package:test/test.dart';

import '../helpers/test_utils.dart';

class HelloCommand extends CliCommand<void> {
  @override
  String get name => 'hello';

  @override
  String get description => 'Say hello.';

  @override
  FutureOr<void> run() {
    print('Hello!');
  }
}

class GreetCommand extends CliCommand<String> {
  @override
  String get name => 'greet';

  @override
  String get description => 'Greet a user.';

  @override
  CliParser get argParser => CliParser()
    ..addOption('name', abbr: 'n', help: 'The name to greet.', mandatory: true);

  @override
  FutureOr<String> run() {
    final name = argResults!.option('name')!;
    return 'Hello, $name!';
  }
}

class VerboseCommand extends CliCommand<void> {
  bool get verbose => argResults!.flag('verbose');

  @override
  String get name => 'verbose';

  @override
  String get description => 'Run with verbose output.';

  @override
  CliParser get argParser =>
      CliParser()
        ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.');

  @override
  FutureOr<void> run() {
    if (verbose) {
      print('Verbose mode enabled.');
    }
  }
}

class NoArgumentsCommand extends CliCommand<void> {
  @override
  String get name => 'no-args';

  @override
  String get description => 'A command that accepts no arguments.';

  @override
  bool get takesArguments => false;

  @override
  FutureOr<void> run() {}
}

class AliasCommand extends CliCommand<void> {
  @override
  String get name => 'remove';

  @override
  List<String> get aliases => ['rm', 'delete'];

  @override
  String get description => 'Remove something.';

  @override
  FutureOr<void> run() {}
}

class ParentCommand extends CliCommand<void> {
  @override
  String get name => 'config';

  @override
  String get description => 'Manage configuration.';

  ParentCommand() {
    addSubcommand(ConfigGetCommand());
  }

  @override
  FutureOr<void> run() {}
}

class ConfigGetCommand extends CliCommand<void> {
  @override
  String get name => 'get';

  @override
  String get description => 'Get configuration.';

  @override
  FutureOr<void> run() {}
}

void main() {
  group('CliCommandRunner', () {
    test('runs a command', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand());

      final output = await TestUtils.captureOutput(() => runner.run(['hello']));

      expect(output, contains('Hello!'));
    });

    test('runs a command with options', () async {
      final runner = CliCommandRunner<String>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(GreetCommand());

      final result = await runner.run(['greet', '--name', 'Clix']);

      expect(result, equals('Hello, Clix!'));
    });

    test('runs a command with abbreviated options', () async {
      final runner = CliCommandRunner<String>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(GreetCommand());

      final result = await runner.run(['greet', '-n', 'Clix']);

      expect(result, equals('Hello, Clix!'));
    });

    test('runs a command with a flag', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      final command = VerboseCommand();
      runner.addCommand(command);

      final output = await TestUtils.captureOutput(
        () => runner.run(['verbose', '--verbose']),
      );

      expect(command.verbose, isTrue);
      expect(output, contains('Verbose mode enabled.'));
    });

    test('supports commands with aliases', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      final command = AliasCommand();
      runner.addCommand(command);

      await runner.run(['rm']);

      expect(runner.commands['remove'], same(command));
      expect(runner.commands['rm'], same(command));
      expect(runner.commands['delete'], same(command));
    });

    test('supports nested subcommands', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      final parent = ParentCommand();
      runner.addCommand(parent);

      await runner.run(['config', 'get']);

      expect(parent.subcommands['get'], isA<ConfigGetCommand>());
    });

    test('rejects arguments when takesArguments is false', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(NoArgumentsCommand());

      expect(
        () => runner.run(['no-args', 'unexpected']),
        throwsA(isA<CliUsageException>()),
      );
    });

    test('prints usage when command is missing', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      final output = await TestUtils.captureOutput(() => runner.run([]));

      expect(output, contains('Clix command-line toolkit.'));
      expect(output, contains('Usage: clix <command> [arguments]'));
    });

    test('throws when command is unknown', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand());

      expect(() => runner.run(['unknown']), throwsA(isA<CliUsageException>()));
    });

    test('suggests similar commands', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand());

      try {
        await runner.run(['hell']);
        fail('Expected CliUsageException.');
      } on CliUsageException catch (error) {
        expect(error.message, contains('Did you mean one of these?'));
        expect(error.message, contains('hello'));
      }
    });

    test('supports the built-in help command', () async {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand());

      final output = await TestUtils.captureOutput(
        () => runner.run(['help', 'hello']),
      );

      expect(output, contains('Say hello.'));
      expect(output, contains('Usage: clix hello [arguments]'));
    });

    test('exposes usage information', () {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand());

      expect(runner.usage, contains('Usage:'));
      expect(runner.usage, contains('Global options:'));
      expect(runner.usage, contains('Available commands:'));
      expect(runner.usage, contains('hello'));
    });

    test('supports a default command', () async {
      final runner = CliCommandRunner<String>(
        'clix',
        'Clix command-line toolkit.',
      );

      final command = GreetCommand();
      runner.addCommand(command, isDefault: true);

      final result = await runner.run(['--name', 'Clix']);

      expect(result, equals('Hello, Clix!'));
    });

    test('rejects multiple default commands', () {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      runner.addCommand(HelloCommand(), isDefault: true);

      expect(
        () => runner.addCommand(GreetCommand(), isDefault: true),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects a branch command as a default command', () {
      final runner = CliCommandRunner<void>(
        'clix',
        'Clix command-line toolkit.',
      );

      final parent = ParentCommand();

      expect(
        () => runner.addCommand(parent, isDefault: true),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
