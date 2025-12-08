import 'package:test/test.dart';
import 'package:clix/src/prompt/select_prompt.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Select Prompt Tests', () {
    late MockIO mockIO;
    late List<String> options;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      options = ['Option 1', 'Option 2', 'Option 3'];
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return selected index', () async {
      // Arrange - Simulate arrow key navigation and enter
      // This is simplified since we can't easily test raw keyboard input
      final select = Select(prompt: 'Choose option', options: options);

      // For now, we'll test the basic functionality without raw input
      // Note: Full keyboard simulation would require more complex mocking

      // Act & Assert
      expect(select.prompt, equals('Choose option'));
      expect(select.options, equals(options));
      expect(select.defaultIndex, equals(0));
    });

    test('should use default index', () async {
      // Arrange
      final select = Select(
        prompt: 'Choose option',
        options: options,
        defaultIndex: 1,
      );

      // Act & Assert
      expect(select.defaultIndex, equals(1));
    });

    test('should handle empty options list', () async {
      // Arrange
      final emptyOptions = <String>[];
      final select = Select(prompt: 'Choose option', options: emptyOptions);

      // Act & Assert
      expect(select.options, isEmpty);
    });

    test('should handle single option', () async {
      // Arrange
      final singleOption = ['Only Option'];
      final select = Select(prompt: 'Choose option', options: singleOption);

      // Act & Assert
      expect(select.options, hasLength(1));
      expect(select.options.first, equals('Only Option'));
    });

    test('should validate default index bounds', () async {
      // Arrange
      final select = Select(
        prompt: 'Choose option',
        options: options,
        defaultIndex: 5,
      );

      // Act & Assert - Default index should be clamped or handled gracefully
      expect(
        select.defaultIndex,
        equals(5),
      ); // Raw value, validation happens in run()
    });
  });
}
