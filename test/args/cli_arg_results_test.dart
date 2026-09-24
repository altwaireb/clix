import 'package:clix/clix.dart';
import 'package:test/test.dart';

void main() {
  group('CliArgResults', () {
    group('operator []', () {
      test('returns parsed option value', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name', 'Clix']);

        expect(results['name'], equals('Clix'));
      });

      test('returns default value when option was not parsed', () {
        final parser = CliParser()..addOption('name', defaultsTo: 'Clix');

        final results = parser.parse([]);

        expect(results['name'], equals('Clix'));
      });

      test('returns parsed flag value', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['--verbose']);

        expect(results['verbose'], isTrue);
      });

      test('throws for unknown option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(() => results['unknown'], throwsArgumentError);
      });
    });

    group('flag()', () {
      test('returns parsed flag', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse(['--verbose']);

        expect(results.flag('verbose'), isTrue);
      });

      test('returns default flag value', () {
        final parser = CliParser()..addFlag('verbose', defaultsTo: true);

        final results = parser.parse([]);

        expect(results.flag('verbose'), isTrue);
      });

      test('returns false for an unparsed flag with false default', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse([]);

        expect(results.flag('verbose'), isFalse);
      });

      test('throws for unknown flag', () {
        final parser = CliParser()..addFlag('verbose');

        final results = parser.parse([]);

        expect(() => results.flag('unknown'), throwsArgumentError);
      });

      test('throws when option is not a flag', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(() => results.flag('name'), throwsArgumentError);
      });
    });

    group('option()', () {
      test('returns parsed option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name', 'Clix']);

        expect(results.option('name'), equals('Clix'));
      });

      test('returns default option', () {
        final parser = CliParser()..addOption('name', defaultsTo: 'Clix');

        final results = parser.parse([]);

        expect(results.option('name'), equals('Clix'));
      });

      test('returns null when option has no value or default', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(results.option('name'), isNull);
      });

      test('throws for unknown option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(() => results.option('unknown'), throwsArgumentError);
      });

      test('throws when option is a multi-option', () {
        final parser = CliParser()..addMultiOption('tags');

        final results = parser.parse([]);

        expect(() => results.option('tags'), throwsArgumentError);
      });
    });

    group('multiOption()', () {
      test('returns parsed multiple values', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse(['--tag', 'dart', '--tag', 'flutter']);

        expect(results.multiOption('tag'), equals(['dart', 'flutter']));
      });

      test('splits comma-separated values', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse(['--tag=dart,flutter,clix']);

        expect(results.multiOption('tag'), equals(['dart', 'flutter', 'clix']));
      });

      test('returns default multiple values', () {
        final parser = CliParser()
          ..addMultiOption('tag', defaultsTo: ['dart', 'clix']);

        final results = parser.parse([]);

        expect(results.multiOption('tag'), equals(['dart', 'clix']));
      });

      test('returns empty list when no values are provided', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse([]);

        expect(results.multiOption('tag'), isEmpty);
      });

      test('throws for unknown option', () {
        final parser = CliParser()..addMultiOption('tag');

        final results = parser.parse([]);

        expect(() => results.multiOption('unknown'), throwsArgumentError);
      });

      test('throws when option is not a multi-option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(() => results.multiOption('name'), throwsArgumentError);
      });
    });

    group('options', () {
      test('contains parsed options', () {
        final parser = CliParser()
          ..addOption('name')
          ..addFlag('verbose');

        final results = parser.parse(['--name', 'Clix', '--verbose']);

        expect(results.options, containsAll(['name', 'verbose']));
      });

      test('contains options with defaults', () {
        final parser = CliParser()..addOption('name', defaultsTo: 'Clix');

        final results = parser.parse([]);

        expect(results.options, contains('name'));
      });

      test('does not contain unparsed options without defaults', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(results.options, isNot(contains('name')));
      });
    });

    group('wasParsed()', () {
      test('returns true for a parsed option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name', 'Clix']);

        expect(results.wasParsed('name'), isTrue);
      });

      test('returns false when only the default is used', () {
        final parser = CliParser()..addOption('name', defaultsTo: 'Clix');

        final results = parser.parse([]);

        expect(results.wasParsed('name'), isFalse);
      });

      test('throws for unknown option', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(() => results.wasParsed('unknown'), throwsArgumentError);
      });
    });

    group('rest', () {
      test('contains positional arguments', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name', 'Clix', 'first', 'second']);

        expect(results.rest, equals(['first', 'second']));
      });

      test('does not include arguments after -- as options', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--', '--name', 'Clix']);

        expect(results.rest, equals(['--name', 'Clix']));
      });
    });

    group('arguments', () {
      test('contains the original arguments', () {
        final parser = CliParser()
          ..addOption('name')
          ..addFlag('verbose');

        final arguments = ['--name', 'Clix', '--verbose'];

        final results = parser.parse(arguments);

        expect(results.arguments, equals(arguments));
      });

      test('is unmodifiable', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse(['--name', 'Clix']);

        expect(() => results.arguments.add('extra'), throwsUnsupportedError);
      });
    });

    group('command', () {
      test('returns selected command results', () {
        final parser = CliParser();
        parser.addCommand('create').addOption('name');

        final results = parser.parse(['create', '--name', 'Clix']);

        expect(results.command, isNotNull);
        expect(results.commandName, equals('create'));
        expect(results.command!.option('name'), equals('Clix'));
      });

      test('returns null when no command is selected', () {
        final parser = CliParser()..addOption('name');

        final results = parser.parse([]);

        expect(results.command, isNull);
        expect(results.commandName, isNull);
      });
    });

    group('rest and arguments immutability', () {
      test('rest is unmodifiable', () {
        final parser = CliParser();

        final results = parser.parse(['first']);

        expect(() => results.rest.add('second'), throwsUnsupportedError);
      });
    });
  });
}
