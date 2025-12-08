import 'package:test/test.dart';
import 'package:clix/src/prompt/number_prompt.dart';
import 'package:clix/src/core/style/theme.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Number Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return valid integer', () async {
      // Arrange
      mockIO.addInput('42');
      final number = Number(prompt: 'Enter age');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(42));
      TestUtils.expectConfirmation(mockIO, 'Enter age', '42');
    });

    test('should use default value when input is empty', () async {
      // Arrange
      mockIO.addInput(''); // Empty input
      final number = Number(prompt: 'Enter age', defaultValue: 25);

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(25));
      TestUtils.expectConfirmation(mockIO, 'Enter age', '25');
    });

    test('should validate and retry on invalid input', () async {
      // Arrange
      mockIO.addInputs(['abc', '42']); // First invalid, second valid
      final number = Number(prompt: 'Enter age');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(42));
      TestUtils.expectValidationError(
        mockIO,
        'Invalid integer number. Please try again.',
      );
    });

    test('should handle negative numbers', () async {
      // Arrange
      mockIO.addInput('-15');
      final number = Number(prompt: 'Enter temperature');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(-15));
    });

    test('should handle zero', () async {
      // Arrange
      mockIO.addInput('0');
      final number = Number(prompt: 'Enter count');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(0));
    });

    test('should validate with min/max range', () async {
      // Arrange
      mockIO.addInputs(['5', '25']); // First too low, second valid
      final number = Number(prompt: 'Enter age', min: 18, max: 100);

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(25));
      TestUtils.expectValidationError(mockIO, 'Number must be at least 18');
    });

    test('should show min/max range in prompt', () async {
      // Arrange
      mockIO.addInput('25');
      final number = Number(prompt: 'Enter age', min: 18, max: 65);

      // Act
      await number.run(mockIO, theme);

      // Assert
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('Range: 18 to 65'));
    });

    test('should handle large numbers', () async {
      // Arrange
      mockIO.addInput('999999999');
      final number = Number(prompt: 'Enter large number');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(999999999));
    });

    test('should trim whitespace from input', () async {
      // Arrange
      mockIO.addInput('  42  ');
      final number = Number(prompt: 'Enter number');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(42));
    });

    test('should show default value in prompt', () async {
      // Arrange
      mockIO.addInput('');
      final number = Number(prompt: 'Enter age', defaultValue: 30);

      // Act
      await number.run(mockIO, theme);

      // Assert
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('[30]'));
    });

    test('should reject decimal numbers', () async {
      // Arrange
      mockIO.addInputs([
        '3.14',
        '42',
      ]); // First decimal (invalid), second integer (valid)
      final number = Number(prompt: 'Enter count');

      // Act
      final result = await number.run(mockIO, theme);

      // Assert
      expect(result, equals(42));
      TestUtils.expectValidationError(
        mockIO,
        'Invalid integer number. Please try again.',
      );
    });
  });
}
