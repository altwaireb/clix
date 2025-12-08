import 'package:test/test.dart';
import 'package:clix/src/prompt/decimal_prompt.dart';
import 'package:clix/src/core/style/theme.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Decimal Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return valid decimal', () async {
      // Arrange
      mockIO.addInput('3.14');
      final decimal = Decimal(prompt: 'Enter price');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(3.14));
      TestUtils.expectConfirmation(mockIO, 'Enter price', '3.14');
    });

    test('should handle integers as decimals', () async {
      // Arrange
      mockIO.addInput('42');
      final decimal = Decimal(prompt: 'Enter value');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(42.0));
      TestUtils.expectConfirmation(mockIO, 'Enter value', '42.0');
    });

    test('should use default value when input is empty', () async {
      // Arrange
      mockIO.addInput(''); // Empty input
      final decimal = Decimal(prompt: 'Enter price', defaultValue: 19.99);

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(19.99));
      TestUtils.expectConfirmation(mockIO, 'Enter price', '19.99');
    });

    test('should validate and retry on invalid input', () async {
      // Arrange
      mockIO.addInputs(['abc', '3.14']); // First invalid, second valid
      final decimal = Decimal(prompt: 'Enter price');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(3.14));
      TestUtils.expectValidationError(
        mockIO,
        'Invalid decimal number. Please try again.',
      );
    });

    test('should handle negative decimals', () async {
      // Arrange
      mockIO.addInput('-15.5');
      final decimal = Decimal(prompt: 'Enter temperature');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(-15.5));
    });

    test('should handle zero', () async {
      // Arrange
      mockIO.addInput('0.0');
      final decimal = Decimal(prompt: 'Enter amount');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(0.0));
    });

    test('should validate with min/max range', () async {
      // Arrange
      mockIO.addInputs(['5.5', '25.0']); // First too low, second valid
      final decimal = Decimal(prompt: 'Enter price', min: 10.0, max: 100.0);

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(25.0));
      TestUtils.expectValidationError(mockIO, 'Number must be at least 10.0');
    });

    test('should handle very small decimals', () async {
      // Arrange
      mockIO.addInput('0.001');
      final decimal = Decimal(prompt: 'Enter precision');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(0.001));
    });

    test('should handle large decimals', () async {
      // Arrange
      mockIO.addInput('999999.999');
      final decimal = Decimal(prompt: 'Enter large decimal');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(999999.999));
    });

    test('should trim whitespace from input', () async {
      // Arrange
      mockIO.addInput('  3.14  ');
      final decimal = Decimal(prompt: 'Enter number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(3.14));
    });

    test('should show default value in prompt', () async {
      // Arrange
      mockIO.addInput('');
      final decimal = Decimal(prompt: 'Enter price', defaultValue: 29.99);

      // Act
      await decimal.run(mockIO, theme);

      // Assert
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('[29.99]'));
    });

    test('should show min/max range in prompt', () async {
      // Arrange
      mockIO.addInput('15.5');
      final decimal = Decimal(prompt: 'Enter price', min: 10.0, max: 50.0);

      // Act
      await decimal.run(mockIO, theme);

      // Assert
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('Range: 10.0 to 50.0'));
    });

    test('should handle scientific notation', () async {
      // Arrange
      mockIO.addInput('1e-3');
      final decimal = Decimal(prompt: 'Enter scientific number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(0.001));
    });

    test('should reject multiple decimal points', () async {
      // Arrange
      mockIO.addInputs(['3.14.15', '2.71']); // Invalid then valid
      final decimal = Decimal(prompt: 'Enter decimal');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(2.71));
      TestUtils.expectValidationError(mockIO, 'Invalid');
    });

    test('should handle very precise decimal numbers', () async {
      // Arrange
      mockIO.addInput('3.141592653589793');
      final decimal = Decimal(prompt: 'Enter π');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(3.141592653589793));
    });

    test('should accept infinity values (Dart behavior)', () async {
      // Arrange
      mockIO.addInput('Infinity');
      final decimal = Decimal(prompt: 'Enter number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(double.infinity));
    });

    test('should accept negative infinity', () async {
      // Arrange
      mockIO.addInput('-Infinity');
      final decimal = Decimal(prompt: 'Enter number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(double.negativeInfinity));
    });

    test('should accept NaN values (Dart behavior)', () async {
      // Arrange
      mockIO.addInput('NaN');
      final decimal = Decimal(prompt: 'Enter number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result.isNaN, isTrue);
    });

    test('should reject truly invalid input', () async {
      // Arrange - Only truly invalid strings should be rejected
      mockIO.addInputs(['abc', 'xyz123', '42.0']);
      final decimal = Decimal(prompt: 'Enter valid number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(42.0));
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('Invalid'));
    });

    test('should handle leading and trailing zeros', () async {
      // Arrange
      mockIO.addInput('000123.4500');
      final decimal = Decimal(prompt: 'Enter number with zeros');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(123.45));
    });

    test('should handle negative decimals correctly', () async {
      // Arrange
      mockIO.addInput('-15.75');
      final decimal = Decimal(prompt: 'Enter negative decimal');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(-15.75));
    });

    test('should enforce range constraints', () async {
      // Arrange
      mockIO.addInputs(['0.5', '15.75']); // Below min then valid
      final decimal = Decimal(
        prompt: 'Enter temperature',
        min: 1.0,
        max: 100.0,
      );

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(15.75));
      // Check that range validation occurred
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('must be at least'));
    });

    test('should handle extremely small numbers', () async {
      // Arrange
      mockIO.addInput('1e-10');
      final decimal = Decimal(prompt: 'Enter tiny number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(1e-10));
    });

    test('should handle extremely large numbers', () async {
      // Arrange
      mockIO.addInput('1.23e15');
      final decimal = Decimal(prompt: 'Enter large number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(1.23e15));
    });

    test('should handle zero correctly', () async {
      // Arrange
      mockIO.addInput('0.0');
      final decimal = Decimal(prompt: 'Enter zero');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(0.0));
    });

    test('should reject non-numeric input', () async {
      // Arrange
      mockIO.addInputs(['abc', 'xyz123', '42.42']);
      final decimal = Decimal(prompt: 'Enter number');

      // Act
      final result = await decimal.run(mockIO, theme);

      // Assert
      expect(result, equals(42.42));
      TestUtils.expectValidationError(mockIO, 'Invalid');
    });
  });
}
