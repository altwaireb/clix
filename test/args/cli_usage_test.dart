import 'package:clix/clix.dart';
import 'package:test/test.dart';

void main() {
  group('CliUsage', () {
    test('generates basic option usage', () {
      final parser = CliParser()
        ..addOption('name', abbr: 'n', help: 'The name to use.');

      expect(parser.usage, equals('-n, --name    The name to use.'));
    });

    test('generates flag usage', () {
      final parser = CliParser()
        ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.');

      expect(
        parser.usage,
        equals('-v, --[no-]verbose    Enable verbose output.'),
      );
    });

    test('generates non-negatable flag usage', () {
      final parser = CliParser()
        ..addFlag(
          'verbose',
          abbr: 'v',
          help: 'Enable verbose output.',
          negatable: false,
        );

      expect(parser.usage, equals('-v, --verbose    Enable verbose output.'));
    });

    test('hides negated flag usage', () {
      final parser = CliParser()
        ..addFlag(
          'verbose',
          abbr: 'v',
          help: 'Enable verbose output.',
          hideNegatedUsage: true,
        );

      expect(parser.usage, equals('-v, --verbose    Enable verbose output.'));
    });

    test('generates value help', () {
      final parser = CliParser()
        ..addOption(
          'output',
          abbr: 'o',
          valueHelp: 'file',
          help: 'Output file.',
        );

      expect(parser.usage, equals('-o, --output=<file>    Output file.'));
    });

    test('marks mandatory options', () {
      final parser = CliParser()
        ..addOption('name', help: 'The name.', mandatory: true);

      expect(parser.usage, equals('--name (mandatory)    The name.'));
    });

    test('shows flag default when enabled', () {
      final parser = CliParser()
        ..addFlag('verbose', help: 'Enable verbose output.', defaultsTo: true);

      expect(
        parser.usage,
        equals(
          '--[no-]verbose    Enable verbose output.\n'
          '                  (defaults to on)',
        ),
      );
    });

    test('shows single option default', () {
      final parser = CliParser()
        ..addOption('format', help: 'Output format.', defaultsTo: 'json');

      expect(
        parser.usage,
        equals(
          '--format    Output format.\n'
          '            (defaults to "json")',
        ),
      );
    });

    test('shows multiple option defaults', () {
      final parser = CliParser()
        ..addMultiOption(
          'format',
          help: 'Output formats.',
          defaultsTo: ['json', 'yaml'],
        );

      expect(
        parser.usage,
        equals(
          '--format    Output formats.\n'
          '            (defaults to "json", "yaml")',
        ),
      );
    });

    test('shows allowed values', () {
      final parser = CliParser()
        ..addOption(
          'format',
          help: 'Output format.',
          allowed: ['json', 'yaml', 'xml'],
        );

      expect(
        parser.usage,
        equals(
          '--format    Output format.\n'
          '            [json, yaml, xml]',
        ),
      );
    });

    test('marks default allowed value', () {
      final parser = CliParser()
        ..addOption(
          'format',
          help: 'Output format.',
          allowed: ['json', 'yaml', 'xml'],
          defaultsTo: 'json',
        );

      expect(
        parser.usage,
        equals(
          '--format    Output format.\n'
          '            [json (default), yaml, xml]',
        ),
      );
    });

    test('generates allowed help entries', () {
      final parser = CliParser()
        ..addOption(
          'format',
          help: 'Output format.',
          allowedHelp: {'json': 'JSON format.', 'yaml': 'YAML format.'},
        );

      expect(
        parser.usage,
        equals(
          '--format        Output format.\n'
          '\n'
          '      [json]    JSON format.\n'
          '      [yaml]    YAML format.',
        ),
      );
    });

    test('hides hidden options', () {
      final parser = CliParser()
        ..addOption('visible', help: 'Visible option.')
        ..addOption('hidden', help: 'Hidden option.', hide: true);

      expect(parser.usage, equals('--visible    Visible option.'));
    });

    test('generates separators', () {
      final parser = CliParser()
        ..addOption('name', help: 'The name.')
        ..addSeparator('Authentication')
        ..addOption('token', help: 'Authentication token.');

      expect(
        parser.usage,
        equals(
          '--name     The name.\n'
          '\n'
          'Authentication\n'
          '--token    Authentication token.',
        ),
      );
    });

    test('aligns multiple options into columns', () {
      final parser = CliParser()
        ..addOption('name', abbr: 'n', help: 'The name.')
        ..addOption('verbose', abbr: 'v', help: 'Enable verbose output.');

      expect(
        parser.usage,
        equals(
          '-n, --name       The name.\n'
          '-v, --verbose    Enable verbose output.',
        ),
      );
    });

    test('wraps help text when line length is specified', () {
      final parser = CliParser(usageLineLength: 40)
        ..addOption(
          'name',
          abbr: 'n',
          help: 'This is a long help message that should wrap.',
        );

      final usage = parser.usage;
      final lines = usage.split('\n');

      expect(usage, contains('-n, --name'));
      expect(usage, contains('This is a long help'));

      expect(lines.length, greaterThan(1));
      expect(lines.every((line) => line.length <= 40), isTrue);
    });

    test('does not wrap help text without line length', () {
      final parser = CliParser()
        ..addOption(
          'name',
          help: 'This is a long help message that should remain on one line.',
        );

      expect(
        parser.usage,
        equals(
          '--name    This is a long help message that should remain on one line.',
        ),
      );
    });
  });
}
