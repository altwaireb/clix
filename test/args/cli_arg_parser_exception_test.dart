import 'package:clix/src/args/cli_arg_parser_exception.dart';
import 'package:test/test.dart';

void main() {
  group('CliArgParserException', () {
    test('stores the error message', () {
      final exception = CliArgParserException('Invalid argument.');

      expect(exception.message, equals('Invalid argument.'));
    });

    test('extends FormatException', () {
      final exception = CliArgParserException('Invalid argument.');

      expect(exception, isA<FormatException>());
    });

    test('stores commands', () {
      final exception = CliArgParserException('Invalid argument.', [
        'build',
        'web',
      ]);

      expect(exception.commands, equals(['build', 'web']));
    });

    test('uses an empty command list when commands are omitted', () {
      final exception = CliArgParserException('Invalid argument.');

      expect(exception.commands, isEmpty);
    });

    test('stores argument name', () {
      final exception = CliArgParserException(
        'Invalid argument.',
        null,
        'output',
      );

      expect(exception.argumentName, equals('output'));
    });

    test('argument name defaults to null', () {
      final exception = CliArgParserException('Invalid argument.');

      expect(exception.argumentName, isNull);
    });

    test('commands are unmodifiable', () {
      final exception = CliArgParserException('Invalid argument.', ['build']);

      expect(() => exception.commands.add('web'), throwsUnsupportedError);
    });

    test('preserves source and offset', () {
      final exception = CliArgParserException(
        'Invalid argument.',
        null,
        null,
        'source text',
        7,
      );

      expect(exception.source, equals('source text'));
      expect(exception.offset, equals(7));
    });

    test('supports commands, argument name, source, and offset together', () {
      final exception = CliArgParserException(
        'Unknown option.',
        ['build', 'web'],
        'output',
        '--output',
        2,
      );

      expect(exception.message, equals('Unknown option.'));
      expect(exception.commands, equals(['build', 'web']));
      expect(exception.argumentName, equals('output'));
      expect(exception.source, equals('--output'));
      expect(exception.offset, equals(2));
    });

    test('preserves command order', () {
      final exception = CliArgParserException('Invalid argument.', [
        'build',
        'web',
        'release',
      ]);

      expect(exception.commands, equals(['build', 'web', 'release']));
    });
  });
}
