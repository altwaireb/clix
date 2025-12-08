import 'package:test/test.dart';
import 'package:clix/src/prompt/confirm_prompt.dart';
import 'package:clix/src/core/style/theme.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Confirm Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return true for "y" input', () async {
      // Arrange
      mockIO.addInput('y');
      final confirm = Confirm(prompt: 'Continue?');

      // Act
      final result = await confirm.run(mockIO, theme);

      // Assert
      expect(result, isTrue);
      TestUtils.expectConfirmation(mockIO, 'Continue?', 'Yes');
    });

    test('should return true for "yes" input', () async {
      // Arrange
      mockIO.addInput('yes');
      final confirm = Confirm(prompt: 'Continue?');

      // Act
      final result = await confirm.run(mockIO, theme);

      // Assert
      expect(result, isTrue);
      TestUtils.expectConfirmation(mockIO, 'Continue?', 'Yes');
    });

    test('should return false for "n" input', () async {
      // Arrange
      mockIO.addInput('n');
      final confirm = Confirm(prompt: 'Continue?');

      // Act
      final result = await confirm.run(mockIO, theme);

      // Assert
      expect(result, isFalse);
      TestUtils.expectConfirmation(mockIO, 'Continue?', 'No');
    });

    test('should return false for "no" input', () async {
      // Arrange
      mockIO.addInput('no');
      final confirm = Confirm(prompt: 'Continue?');

      // Act
      final result = await confirm.run(mockIO, theme);

      // Assert
      expect(result, isFalse);
      TestUtils.expectConfirmation(mockIO, 'Continue?', 'No');
    });

    test('should use default value for empty input', () async {
      // Arrange
      mockIO.addInput(''); // Empty input
      final confirm = Confirm(prompt: 'Continue?', defaultValue: true);

      // Act
      final result = await confirm.run(mockIO, theme);

      // Assert
      expect(result, isTrue);
      TestUtils.expectConfirmation(mockIO, 'Continue?', 'Yes');
    });

    test(
      'should handle invalid input (returns false for anything not y/yes)',
      () async {
        // Arrange
        mockIO.addInput('invalid'); // Invalid input should return false
        final confirm = Confirm(prompt: 'Continue?');

        // Act
        final result = await confirm.run(mockIO, theme);

        // Assert
        expect(result, isFalse); // Invalid input returns false
        TestUtils.expectConfirmation(mockIO, 'Continue?', 'No');
      },
    );

    test('should be case insensitive', () async {
      // Test different cases
      final testCases = [
        ('Y', true),
        ('YES', true),
        ('N', false),
        ('NO', false),
      ];

      for (final (input, expected) in testCases) {
        mockIO.reset();
        mockIO.addInput(input);
        final confirm = Confirm(prompt: 'Test?');

        final result = await confirm.run(mockIO, theme);

        expect(result, equals(expected), reason: 'Failed for input: $input');
      }
    });
  });
}
