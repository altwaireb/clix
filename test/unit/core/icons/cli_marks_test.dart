import 'package:clix/src/core/icons/cli_marks.dart';
import 'package:test/test.dart';

void main() {
  group('CliMarks', () {
    test('returns the expected selected circle symbol', () {
      expect(CliMarks.selectedCircle.symbol, equals('\u25C9'));
    });

    test('returns the expected circle symbol', () {
      expect(CliMarks.circle.symbol, equals('\u25CB'));
    });

    test('selected circle is different from circle', () {
      expect(
        CliMarks.selectedCircle.symbol,
        isNot(equals(CliMarks.circle.symbol)),
      );
    });
  });
}
