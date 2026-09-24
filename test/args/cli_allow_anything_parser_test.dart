import 'package:clix/src/args/cli_allow_anything_parser.dart';
import 'package:clix/src/args/cli_parser.dart';
import 'package:test/test.dart';

void main() {
  group('CliAllowAnythingParser', () {
    late CliAllowAnythingParser parser;

    setUp(() {
      parser = CliAllowAnythingParser();
    });

    test('implements CliParser', () {
      expect(parser, isA<CliParser>());
    });

    test('has no options', () {
      expect(parser.options, isEmpty);
    });

    test('has no commands', () {
      expect(parser.commands, isEmpty);
    });

    test('does not allow trailing options', () {
      expect(parser.allowTrailingOptions, isFalse);
    });

    test('allows anything', () {
      expect(parser.allowsAnything, isTrue);
    });

    test('has no usage line length', () {
      expect(parser.usageLineLength, isNull);
    });

    test('has empty usage', () {
      expect(parser.usage, isEmpty);
    });

    test('does not have a default command', () {
      expect(parser.defaultCommand, isNull);
    });

    test('cannot add a command', () {
      expect(() => parser.addCommand('build'), throwsUnsupportedError);
    });

    test('cannot add a flag', () {
      expect(() => parser.addFlag('verbose'), throwsUnsupportedError);
    });

    test('cannot add an option', () {
      expect(() => parser.addOption('output'), throwsUnsupportedError);
    });

    test('cannot add a multi option', () {
      expect(() => parser.addMultiOption('tag'), throwsUnsupportedError);
    });

    test('cannot add a separator', () {
      expect(() => parser.addSeparator('General'), throwsUnsupportedError);
    });

    test('returns null when finding an option by abbreviation', () {
      expect(parser.findByAbbreviation('v'), isNull);
    });

    test('returns null when finding an option by name or alias', () {
      expect(parser.findByNameOrAlias('verbose'), isNull);
    });

    test('defaultFor throws for any option name', () {
      expect(() => parser.defaultFor('output'), throwsArgumentError);
    });

    test('cannot set a default command', () {
      expect(() => parser.defaultCommand = 'build', throwsUnsupportedError);
    });

    test('parses all input as arguments', () {
      final results = parser.parse([
        'build',
        '--output',
        'dist',
        '-v',
        'file.txt',
      ]);

      expect(
        results.arguments,
        equals(['build', '--output', 'dist', '-v', 'file.txt']),
      );
    });

    test('parses an empty argument list', () {
      final results = parser.parse([]);

      expect(results.arguments, isEmpty);
    });

    test('does not interpret option-like input as options', () {
      final results = parser.parse(['--verbose', '--output=dist', '-v']);

      expect(results.arguments, equals(['--verbose', '--output=dist', '-v']));
    });
  });
}
