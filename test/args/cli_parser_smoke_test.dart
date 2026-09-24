import 'package:clix/clix.dart';
import 'package:test/test.dart';

void main() {
  group('CliParser Smoke Test', () {
    test('should parse option and flag', () {
      final parser = CliParser()
        ..addOption('name', abbr: 'n', help: 'User name')
        ..addFlag('verbose', abbr: 'v');

      final results = parser.parse(['--name', 'Abdulmajeed', '--verbose']);

      expect(results['name'], equals('Abdulmajeed'));
      expect(results['verbose'], isTrue);
    });

    test('should parse abbreviation', () {
      final parser = CliParser()
        ..addOption('name', abbr: 'n')
        ..addFlag('verbose', abbr: 'v');

      final results = parser.parse(['-n', 'Clix', '-v']);

      expect(results['name'], equals('Clix'));
      expect(results['verbose'], isTrue);
    });

    test('should use default values', () {
      final parser = CliParser()
        ..addOption('name', defaultsTo: 'Guest')
        ..addFlag('verbose', defaultsTo: false);

      final results = parser.parse([]);

      expect(results['name'], equals('Guest'));
      expect(results['verbose'], isFalse);
    });

    test('should parse multiple options', () {
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
  });
}
