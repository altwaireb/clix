import 'package:clix/clix.dart';
import 'package:test/test.dart';

void main() {
  group('CliUsageException', () {
    test('stores message and usage', () {
      final exception = CliUsageException(
        'Invalid command.',
        'Usage: clix <command>',
      );

      expect(exception.message, equals('Invalid command.'));
      expect(exception.usage, equals('Usage: clix <command>'));
    });

    test('formats message and usage in toString', () {
      final exception = CliUsageException(
        'Invalid command.',
        'Usage: clix <command>',
      );

      expect(
        exception.toString(),
        equals(
          'Invalid command.\n\n'
          'Usage: clix <command>',
        ),
      );
    });

    test('implements Exception', () {
      final exception = CliUsageException(
        'Invalid command.',
        'Usage: clix <command>',
      );

      expect(exception, isA<Exception>());
    });

    test('supports empty message', () {
      final exception = CliUsageException('', 'Usage: clix <command>');

      expect(exception.toString(), equals('\n\nUsage: clix <command>'));
    });

    test('supports empty usage', () {
      final exception = CliUsageException('Invalid command.', '');

      expect(exception.toString(), equals('Invalid command.\n\n'));
    });
  });
}
