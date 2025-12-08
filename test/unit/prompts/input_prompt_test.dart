import 'package:test/test.dart';
import 'package:clix/src/prompt/input_prompt.dart';
import 'package:clix/src/core/style/theme.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Input Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return user input', () async {
      // Arrange
      mockIO.addInput('Ahmad');
      final input = Input(prompt: 'Enter name');

      // Act
      final result = await input.run(mockIO, theme);

      // Assert
      expect(result, equals('Ahmad'));
      TestUtils.expectQuestion(mockIO, 'Enter name');
      TestUtils.expectConfirmation(mockIO, 'Enter name', 'Ahmad');
    });

    test('should use default value when input is empty', () async {
      // Arrange
      mockIO.addInput(''); // Empty input
      final input = Input(prompt: 'Enter name', defaultValue: 'Default');

      // Act
      final result = await input.run(mockIO, theme);

      // Assert
      expect(result, equals('Default'));
      TestUtils.expectConfirmation(mockIO, 'Enter name', 'Default');
    });

    test('should validate input and retry on error', () async {
      // Arrange
      mockIO.addInputs(['ab', 'Ahmad']); // First fails, second succeeds
      final input = Input(
        prompt: 'Enter name',
        validator: (value) {
          if (value.length < 3) return 'Name must be at least 3 characters';
          return null;
        },
      );

      // Act
      final result = await input.run(mockIO, theme);

      // Assert
      expect(result, equals('Ahmad'));
      TestUtils.expectValidationError(
        mockIO,
        'Name must be at least 3 characters',
      );
      TestUtils.expectConfirmation(mockIO, 'Enter name', 'Ahmad');
    });

    test('should trim whitespace from input', () async {
      // Arrange
      mockIO.addInput('  Ahmad  ');
      final input = Input(prompt: 'Enter name');

      // Act
      final result = await input.run(mockIO, theme);

      // Assert
      expect(result, equals('Ahmad'));
    });

    test('should show default value in prompt', () async {
      // Arrange
      mockIO.addInput('');
      final input = Input(prompt: 'Enter name', defaultValue: 'DefaultName');

      // Act
      await input.run(mockIO, theme);

      // Assert
      final outputs = TestUtils.getAllOutputs(mockIO);
      expect(outputs, contains('[DefaultName]'));
    });
  });
}
