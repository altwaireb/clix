import 'package:clix/src/args/cli_utils.dart';
import 'package:test/test.dart';

void main() {
  group('padRight', () {
    test('pads text with spaces to the requested length', () {
      expect(padRight('Clix', 8), equals('Clix    '));
    });

    test('returns text unchanged when already at requested length', () {
      expect(padRight('Clix', 4), equals('Clix'));
    });

    test('returns text unchanged when longer than requested length', () {
      expect(padRight('Clix', 2), equals('Clix'));
    });

    test('supports empty text', () {
      expect(padRight('', 4), equals('    '));
    });
  });

  group('wrapText', () {
    test('returns text unchanged when length is null', () {
      const text = 'This is a long line of text.';

      expect(wrapText(text), equals(text));
    });

    test('wraps text at the requested length', () {
      expect(
        wrapText('This is a long line of text.', length: 10),
        equals('This is a\nlong line\nof text.'),
      );
    });

    test('splits long words when necessary', () {
      expect(
        wrapText('abcdefghijklmnop', length: 10),
        equals('abcdefghij\nklmnop'),
      );
    });

    test('preserves existing newlines', () {
      expect(
        wrapText('First line\nSecond line', length: 20),
        equals('First line\nSecond line'),
      );
    });

    test('preserves leading indentation', () {
      expect(
        wrapText('    This is a long line.', length: 15),
        equals('    This is a\n    long line.'),
      );
    });

    test('applies hanging indent', () {
      expect(
        wrapText(
          'Usage: app main_command arguments',
          length: 20,
          hangingIndent: 7,
        ),
        equals('Usage: app\n       main_command\n       arguments'),
      );
    });

    test('does not add whitespace-only lines', () {
      expect(
        wrapText('First\n\nSecond', length: 20),
        equals('First\n\nSecond'),
      );
    });

    test('supports empty text', () {
      expect(wrapText('', length: 20), equals(''));
    });
  });

  group('wrapTextAsLines', () {
    test('returns split lines when length is null', () {
      expect(wrapTextAsLines('First\nSecond'), equals(['First', 'Second']));
    });

    test('preserves whitespace when length is null', () {
      expect(
        wrapTextAsLines('  First  \n  Second  '),
        equals(['  First  ', '  Second  ']),
      );
    });

    test('wraps text into a list of lines', () {
      expect(
        wrapTextAsLines('This is a long line of text.', length: 10),
        equals(['This is a', 'long line', 'of text.']),
      );
    });

    test('accepts a non-negative start column', () {
      expect(
        wrapTextAsLines('This is some text.', start: 3, length: 21),
        equals(['This is some text.']),
      );
    });

    test('uses a minimum effective length of 10', () {
      expect(
        wrapTextAsLines('abcdefghijklmnop', length: 5),
        equals(['abcdefghij', 'klmnop']),
      );
    });

    test('splits long words when no whitespace is available', () {
      expect(
        wrapTextAsLines('abcdefghijklmnop', length: 10),
        equals(['abcdefghij', 'klmnop']),
      );
    });

    test('wraps at whitespace when possible', () {
      expect(
        wrapTextAsLines('one two three four', length: 10),
        equals(['one two', 'three four']),
      );
    });

    test('preserves embedded newlines', () {
      expect(
        wrapTextAsLines('First line\nSecond line', length: 20),
        equals(['First line', 'Second line']),
      );
    });

    test('trims lines when wrapping', () {
      expect(
        wrapTextAsLines('  First line  \n  Second line  ', length: 20),
        equals(['First line', 'Second line']),
      );
    });

    test('supports Unicode whitespace', () {
      expect(
        wrapTextAsLines('one\u2000two three', length: 10),
        equals(['one\u2000two', 'three']),
      );
    });
  });
}
