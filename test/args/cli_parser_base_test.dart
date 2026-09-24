import 'package:clix/src/args/cli_arg_parser_exception.dart';
import 'package:clix/src/args/cli_parser.dart';
import 'package:test/test.dart';

void main() {
  group('CliParserBase parsing', () {
    test('parses a boolean flag', () {
      final parser = CliParser()..addFlag('verbose', abbr: 'v');

      final results = parser.parse(['--verbose']);

      expect(results.flag('verbose'), isTrue);
    });

    test('parses a flag abbreviation', () {
      final parser = CliParser()..addFlag('verbose', abbr: 'v');

      final results = parser.parse(['-v']);

      expect(results.flag('verbose'), isTrue);
    });

    test('parses multiple collapsed flag abbreviations', () {
      final parser = CliParser()
        ..addFlag('verbose', abbr: 'v')
        ..addFlag('debug', abbr: 'd')
        ..addFlag('force', abbr: 'f');

      final results = parser.parse(['-vdf']);

      expect(results.flag('verbose'), isTrue);
      expect(results.flag('debug'), isTrue);
      expect(results.flag('force'), isTrue);
    });

    test('parses a single option using a long option', () {
      final parser = CliParser()..addOption('name');

      final results = parser.parse(['--name', 'Clix']);

      expect(results.option('name'), equals('Clix'));
    });

    test('parses a single option using equals syntax', () {
      final parser = CliParser()..addOption('name');

      final results = parser.parse(['--name=Clix']);

      expect(results.option('name'), equals('Clix'));
    });

    test('parses a single option using an abbreviation', () {
      final parser = CliParser()..addOption('name', abbr: 'n');

      final results = parser.parse(['-n', 'Clix']);

      expect(results.option('name'), equals('Clix'));
    });

    test('parses a single option using attached abbreviation value', () {
      final parser = CliParser()..addOption('name', abbr: 'n');

      final results = parser.parse(['-nClix']);

      expect(results.option('name'), equals('Clix'));
    });

    test(
      'parses a single option using attached abbreviation equals syntax',
      () {
        final parser = CliParser()..addOption('name', abbr: 'n');

        final results = parser.parse(['-n=Clix']);

        expect(results.option('name'), equals('Clix'));
      },
    );

    test('last single option value wins', () {
      final parser = CliParser()..addOption('name');

      final results = parser.parse(['--name', 'first', '--name', 'second']);

      expect(results.option('name'), equals('second'));
    });

    test('parses a multiple option', () {
      final parser = CliParser()..addMultiOption('tag');

      final results = parser.parse(['--tag', 'one', '--tag', 'two']);

      expect(results.multiOption('tag'), equals(['one', 'two']));
    });

    test('splits comma-separated multiple values', () {
      final parser = CliParser()..addMultiOption('tag');

      final results = parser.parse(['--tag', 'one,two,three']);

      expect(results.multiOption('tag'), equals(['one', 'two', 'three']));
    });

    test('does not split commas when splitCommas is false', () {
      final parser = CliParser()..addMultiOption('tag', splitCommas: false);

      final results = parser.parse(['--tag', 'one,two']);

      expect(results.multiOption('tag'), equals(['one,two']));
    });

    test('parses an empty value after equals', () {
      final parser = CliParser()..addOption('name');

      final results = parser.parse(['--name=']);

      expect(results.option('name'), equals(''));
    });

    test('rejects a flag with a value', () {
      final parser = CliParser()..addFlag('verbose');

      expect(
        () => parser.parse(['--verbose=true']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('should not be given a value'),
          ),
        ),
      );
    });

    test('rejects a flag with an attached abbreviation value', () {
      final parser = CliParser()..addFlag('verbose', abbr: 'v');

      expect(
        () => parser.parse(['-v=']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('is a flag and cannot handle value'),
          ),
        ),
      );
    });

    test('rejects a missing option value', () {
      final parser = CliParser()..addOption('name');

      expect(
        () => parser.parse(['--name']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Missing argument'),
          ),
        ),
      );
    });

    test('rejects a missing abbreviation option value', () {
      final parser = CliParser()..addOption('name', abbr: 'n');

      expect(
        () => parser.parse(['-n']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Missing argument'),
          ),
        ),
      );
    });

    test('parses a negated flag', () {
      final parser = CliParser()..addFlag('verbose');

      final results = parser.parse(['--no-verbose']);

      expect(results.flag('verbose'), isFalse);
    });

    test('rejects negating a non-flag option', () {
      final parser = CliParser()..addOption('name');

      expect(
        () => parser.parse(['--no-name']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Cannot negate non-flag option'),
          ),
        ),
      );
    });

    test('rejects negating a non-negatable flag', () {
      final parser = CliParser()..addFlag('verbose', negatable: false);

      expect(
        () => parser.parse(['--no-verbose']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Cannot negate option'),
          ),
        ),
      );
    });

    test('rejects an unknown long option', () {
      final parser = CliParser();

      expect(
        () => parser.parse(['--unknown']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Could not find an option named'),
          ),
        ),
      );
    });

    test('rejects an unknown abbreviation', () {
      final parser = CliParser();

      expect(
        () => parser.parse(['-x']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('Could not find an option'),
          ),
        ),
      );
    });

    test('validates allowed values', () {
      final parser = CliParser()
        ..addOption('format', allowed: ['json', 'yaml']);

      final results = parser.parse(['--format', 'json']);

      expect(results.option('format'), equals('json'));
    });

    test('rejects values outside allowed values', () {
      final parser = CliParser()
        ..addOption('format', allowed: ['json', 'yaml']);

      expect(
        () => parser.parse(['--format', 'xml']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('is not an allowed value'),
          ),
        ),
      );
    });

    test('validates every split multiple value', () {
      final parser = CliParser()
        ..addMultiOption('format', allowed: ['json', 'yaml']);

      expect(
        () => parser.parse(['--format', 'json,xml']),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            contains('"xml" is not an allowed value'),
          ),
        ),
      );
    });

    test('accepts an option alias', () {
      final parser = CliParser()..addOption('output', aliases: ['out']);

      final results = parser.parse(['--out', 'file.txt']);

      expect(results.option('output'), equals('file.txt'));
    });

    test('stops parsing at the argument terminator', () {
      final parser = CliParser()
        ..addFlag('verbose')
        ..addOption('name');

      final results = parser.parse(['--verbose', '--', '--name', 'Clix']);

      expect(results.flag('verbose'), isTrue);
      expect(results.rest, equals(['--name', 'Clix']));
    });

    test('collects trailing arguments when allowed', () {
      final parser = CliParser(allowTrailingOptions: true)..addFlag('verbose');

      final results = parser.parse(['--verbose', 'first', 'second']);

      expect(results.rest, equals(['first', 'second']));
    });

    test('stops parsing at a trailing argument when disabled', () {
      final parser = CliParser(allowTrailingOptions: false)..addFlag('verbose');

      final results = parser.parse(['first', '--verbose']);

      expect(results.rest, equals(['first', '--verbose']));
      expect(results.flag('verbose'), isFalse);
    });

    test('invokes option callback with parsed value', () {
      String? received;

      final parser = CliParser()
        ..addOption('name', callback: (value) => received = value);

      parser.parse(['--name', 'Clix']);

      expect(received, equals('Clix'));
    });

    test('invokes callback with default value when option is not parsed', () {
      String? received;

      final parser = CliParser()
        ..addOption(
          'name',
          defaultsTo: 'default',
          callback: (value) => received = value,
        );

      parser.parse([]);

      expect(received, equals('default'));
    });

    test('invokes multiple option callback with parsed values', () {
      List<String>? received;

      final parser = CliParser()
        ..addMultiOption('tag', callback: (values) => received = values);

      parser.parse(['--tag', 'one', '--tag', 'two']);

      expect(received, equals(['one', 'two']));
    });

    test('throws when a mandatory option is missing', () {
      final parser = CliParser()..addOption('name', mandatory: true);

      expect(
        () => parser.parse([]),
        throwsA(
          isA<CliArgParserException>().having(
            (error) => error.message,
            'message',
            equals('CliOption name is mandatory.'),
          ),
        ),
      );
    });

    test('accepts a mandatory option when provided', () {
      final parser = CliParser()..addOption('name', mandatory: true);

      final results = parser.parse(['--name', 'Clix']);

      expect(results.option('name'), equals('Clix'));
    });

    test('help suppresses mandatory option validation', () {
      final parser = CliParser()
        ..addFlag('help')
        ..addOption('name', mandatory: true);

      final results = parser.parse(['--help']);

      expect(results.flag('help'), isTrue);
    });

    test('parses a command before its options', () {
      final parser = CliParser();
      final command = parser.addCommand('build')..addFlag('release', abbr: 'r');

      final results = parser.parse(['build', '--release']);

      expect(results.commandName, equals('build'));
      expect(results.command, isNotNull);
      expect(results.command!.flag('release'), isTrue);
      expect(command, same(parser.commands['build']));
    });

    test('propagates command parser errors with command path', () {
      final parser = CliParser();
      parser.addCommand('build').addOption('output');

      expect(
        () => parser.parse(['build', '--unknown']),
        throwsA(
          isA<CliArgParserException>()
              .having(
                (error) => error.message,
                'message',
                contains('Could not find an option named'),
              )
              .having((error) => error.commands, 'commands', equals(['build'])),
        ),
      );
    });

    test('uses the default command when no command is specified', () {
      final parser = CliParser();
      parser.addCommand('build');
      parser.defaultCommand = 'build';

      final results = parser.parse([]);

      expect(results.commandName, equals('build'));
    });
  });
}
