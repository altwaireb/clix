import 'package:clix/clix.dart';
import 'package:test/test.dart';

void main() {
  group('CliParser', () {
    group('Options', () {
      test('parses --option=value', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name=Clix']);

        expect(results['name'], equals('Clix'));
      });

      test('parses option using abbreviation with value', () {
        final parser = CliParser()..addOption('name', abbr: 'n');

        final results = parser.parse(['-n', 'Clix']);

        expect(results['name'], equals('Clix'));
      });

      test('parses abbreviation using = syntax', () {
        final parser = CliParser()..addOption('name', abbr: 'n');

        final results = parser.parse(['-n=Clix']);

        expect(results['name'], equals('Clix'));
      });
    });

    group('Flags', () {
      test('parses flag as true', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['--verbose']);

        expect(results['verbose'], isTrue);
      });

      test('parses negatable flag as false', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['--no-verbose']);

        expect(results['verbose'], isFalse);
      });

      test('uses flag default value', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse([]);

        expect(results['verbose'], isFalse);
      });

      test('uses custom flag default value', () {
        final parser = CliParser()..addFlag('verbose', defaultsTo: true);

        final results = parser.parse([]);

        expect(results['verbose'], isTrue);
      });
    });

    group('Aliases', () {
      test('parses option using alias', () {
        final parser = CliParser()..addOption('name', aliases: ['username']);

        final results = parser.parse(['--username', 'Clix']);

        expect(results['name'], equals('Clix'));
      });

      test('parses flag using alias', () {
        final parser = CliParser()..addFlag('verbose', aliases: ['debug']);

        final results = parser.parse(['--debug']);

        expect(results['verbose'], isTrue);
      });
    });

    group('Multiple options', () {
      test('parses multiple occurrences', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse([
          '--tag',
          'dart',
          '--tag',
          'cli',
          '--tag',
          'clix',
        ]);

        expect(results.multiOption('tag'), equals(['dart', 'cli', 'clix']));
      });

      test('splits comma-separated values by default', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse(['--tag', 'dart,cli,clix']);

        expect(results.multiOption('tag'), equals(['dart', 'cli', 'clix']));
      });

      test('does not split comma-separated values when disabled', () {
        final parser = CliParser()..addMultiOption('tag', splitCommas: false);

        final results = parser.parse(['--tag', 'dart,cli,clix']);

        expect(results.multiOption('tag'), equals(['dart,cli,clix']));
      });

      test('uses multiple default values', () {
        final parser = CliParser()
          ..addMultiOption('tag', defaultsTo: ['dart', 'cli']);

        final results = parser.parse([]);

        expect(results.multiOption('tag'), equals(['dart', 'cli']));
      });
    });

    group('Allowed values', () {
      test('accepts an allowed value', () {
        final parser = CliParser()
          ..addOption('format', allowed: ['json', 'yaml']);

        final results = parser.parse(['--format', 'json']);

        expect(results['format'], equals('json'));
      });

      test('rejects a value that is not allowed', () {
        final parser = CliParser()
          ..addOption('format', allowed: ['json', 'yaml']);

        expect(
          () => parser.parse(['--format', 'xml']),
          throwsA(isA<CliArgParserException>()),
        );
      });
    });

    group('Mandatory options', () {
      test('accepts a mandatory option when supplied', () {
        final parser = CliParser()..addOption('name', mandatory: true);

        final results = parser.parse(['--name', 'Clix']);

        expect(results['name'], equals('Clix'));
      });

      test('rejects a missing mandatory option', () {
        final parser = CliParser()..addOption('name', mandatory: true);

        expect(() => parser.parse([]), throwsA(isA<CliArgParserException>()));
      });
    });

    group('Positional arguments', () {
      test('preserves positional arguments in rest', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['file.dart', 'other.dart']);

        expect(results.rest, equals(['file.dart', 'other.dart']));
      });

      test('parses trailing options by default', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['file.dart', '--verbose']);

        expect(results.rest, equals(['file.dart']));
        expect(results['verbose'], isTrue);
      });

      test('stops parsing options after positional argument when disabled', () {
        final parser = CliParser(allowTrailingOptions: false)
          ..addFlag('verbose');

        final results = parser.parse(['file.dart', '--verbose']);

        expect(results.rest, equals(['file.dart', '--verbose']));

        expect(results['verbose'], isFalse);
      });
    });

    group('End of options', () {
      test('preserves arguments after -- as positional arguments', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse([
          '--verbose',
          '--',
          '--not-an-option',
          'file.dart',
        ]);

        expect(results['verbose'], isTrue);
        expect(results.rest, equals(['--not-an-option', 'file.dart']));
      });
    });

    group('Callbacks', () {
      test('calls option callback', () {
        String? received;

        final parser = CliParser()
          ..addOption(
            'name',
            callback: (value) {
              received = value;
            },
          );

        parser.parse(['--name', 'Clix']);

        expect(received, equals('Clix'));
      });

      test('calls flag callback', () {
        bool? received;

        final parser = CliParser()
          ..addFlag(
            'verbose',
            callback: (value) {
              received = value;
            },
          );

        parser.parse(['--verbose']);

        expect(received, isTrue);
      });

      test('calls multi-option callback', () {
        List<String>? received;

        final parser = CliParser()
          ..addMultiOption(
            'tag',
            callback: (value) {
              received = value;
            },
          );

        parser.parse(['--tag', 'dart', '--tag', 'cli']);

        expect(received, equals(['dart', 'cli']));
      });
    });

    group('Validation', () {
      test('rejects duplicate option names', () {
        final parser = CliParser()..addOption('name');

        expect(() => parser.addOption('name'), throwsA(isA<ArgumentError>()));
      });

      test('rejects duplicate abbreviations', () {
        final parser = CliParser()..addOption('name', abbr: 'n');

        expect(
          () => parser.addOption('number', abbr: 'n'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects mandatory option with default value', () {
        expect(
          () => CliParser().addOption(
            'name',
            mandatory: true,
            defaultsTo: 'Clix',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects hideNegatedUsage without negatable flag', () {
        expect(
          () => CliParser().addFlag(
            'verbose',
            negatable: false,
            hideNegatedUsage: true,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Public collections', () {
      test('exposes defined options', () {
        final parser = CliParser()
          ..addFlag('verbose')
          ..addOption('name');

        expect(parser.options.keys, equals(['verbose', 'name']));
      });

      test('does not expose aliases as option keys', () {
        final parser = CliParser()..addOption('name', aliases: ['username']);

        expect(parser.options.keys, equals(['name']));
        expect(parser.options.containsKey('username'), isFalse);
      });

      test('options are unmodifiable', () {
        final parser = CliParser()..addFlag('verbose');

        expect(
          () => parser.options['other'] = parser.options['verbose']!,
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('commands are unmodifiable', () {
        final parser = CliParser()..addCommand('build');

        expect(
          () => parser.commands['test'] = CliParser(),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Defaults', () {
      test('returns default value by option name', () {
        final parser = CliParser()..addOption('name', defaultsTo: 'Clix');

        expect(parser.defaultFor('name'), equals('Clix'));
      });

      test('returns default value by alias', () {
        final parser = CliParser()
          ..addOption('name', aliases: ['username'], defaultsTo: 'Clix');

        expect(parser.defaultFor('username'), equals('Clix'));
      });

      test('returns null when option has no default', () {
        final parser = CliParser()..addOption('name');

        expect(parser.defaultFor('name'), isNull);
      });

      test('rejects unknown option when reading default', () {
        final parser = CliParser();

        expect(
          () => parser.defaultFor('unknown'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Lookup', () {
      test('finds option by abbreviation', () {
        final parser = CliParser()..addOption('name', abbr: 'n');

        expect(parser.findByAbbreviation('n')?.name, equals('name'));
      });

      test('returns null for unknown abbreviation', () {
        final parser = CliParser();

        expect(parser.findByAbbreviation('n'), isNull);
      });

      test('finds option by name', () {
        final parser = CliParser()..addOption('name');

        expect(parser.findByNameOrAlias('name')?.name, equals('name'));
      });

      test('finds option by alias', () {
        final parser = CliParser()..addOption('name', aliases: ['username']);

        expect(parser.findByNameOrAlias('username')?.name, equals('name'));
      });

      test('returns null for unknown name or alias', () {
        final parser = CliParser();

        expect(parser.findByNameOrAlias('unknown'), isNull);
      });
    });

    group('Usage', () {
      test('generates usage for options', () {
        final parser = CliParser()
          ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.')
          ..addOption('name', help: 'Name of the project.');

        expect(parser.usage, contains('--[no-]verbose'));
        expect(parser.usage, contains('--name'));
        expect(parser.usage, contains('Enable verbose output.'));
        expect(parser.usage, contains('Name of the project.'));
      });

      test('respects usage line length', () {
        final parser = CliParser(usageLineLength: 40)
          ..addOption(
            'name',
            help: 'This is a long help message that should wrap.',
          );

        expect(parser.usage, contains('\n'));
        expect(parser.usage, contains('This is a long help'));
      });

      test('includes separators in usage', () {
        final parser = CliParser()
          ..addOption('first', help: 'First option.')
          ..addSeparator('Advanced options:')
          ..addOption('second', help: 'Second option.');

        expect(parser.usage, contains('Advanced options:'));
      });

      test('hidden options are excluded from usage', () {
        final parser = CliParser()
          ..addOption('visible', help: 'Visible option.')
          ..addOption('hidden', help: 'Hidden option.', hide: true);

        expect(parser.usage, contains('--visible'));
        expect(parser.usage, isNot(contains('--hidden')));
      });

      test('includes value help in usage', () {
        final parser = CliParser()
          ..addOption('output', valueHelp: 'FILE', help: 'Output file.');

        expect(parser.usage, contains('--output=<FILE>'));
      });

      test('includes allowed help in usage', () {
        final parser = CliParser()
          ..addOption(
            'format',
            allowed: ['json', 'yaml'],
            allowedHelp: {'json': 'JSON format.', 'yaml': 'YAML format.'},
          );

        expect(parser.usage, contains('JSON format.'));
        expect(parser.usage, contains('YAML format.'));
      });
    });

    group('Commands', () {
      test('uses supplied parser for a subcommand', () {
        final commandParser = CliParser()..addFlag('release');
        final parser = CliParser();

        final returned = parser.addCommand('build', commandParser);

        expect(returned, same(commandParser));
        expect(parser.commands['build'], same(commandParser));

        final results = parser.parse(['build', '--release']);

        expect(results.commandName, equals('build'));
        expect(results.command?.flag('release'), isTrue);
      });

      test('rejects duplicate command names', () {
        final parser = CliParser()..addCommand('build');

        expect(() => parser.addCommand('build'), throwsA(isA<ArgumentError>()));
      });
    });

    group('Allow anything', () {
      test('preserves unknown options as positional arguments', () {
        final parser = CliParser.allowAnything();

        final results = parser.parse(['--unknown', 'value', '-x']);

        expect(results.rest, equals(['--unknown', 'value', '-x']));
      });
    });

    group('Commands', () {
      test('registers subcommand', () {
        final parser = CliParser();
        final command = parser.addCommand('build');

        command.addFlag('release');

        expect(parser.commands.containsKey('build'), isTrue);
        expect(parser.commands['build'], same(command));
      });
    });
  });
}
