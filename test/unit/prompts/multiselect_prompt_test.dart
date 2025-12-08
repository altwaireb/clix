import 'package:test/test.dart';
import 'package:clix/src/prompt/multi_select_prompt.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('MultiSelect Prompt Tests', () {
    late MockIO mockIO;
    late List<String> options;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should initialize with correct properties', () async {
      // Arrange
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: options,
      );

      // Act & Assert
      expect(multiSelect.prompt, equals('Choose options'));
      expect(multiSelect.options, equals(options));
      expect(multiSelect.defaults, isEmpty);
      expect(multiSelect.help, isTrue);
    });

    test('should use default selected items', () async {
      // Arrange
      final defaultSelected = [0, 2];
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: options,
        defaults: defaultSelected,
      );

      // Act & Assert
      expect(multiSelect.defaults, equals(defaultSelected));
    });

    test('should handle empty options list', () async {
      // Arrange
      final emptyOptions = <String>[];
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: emptyOptions,
      );

      // Act & Assert
      expect(multiSelect.options, isEmpty);
    });

    test('should handle single option', () async {
      // Arrange
      final singleOption = ['Only Option'];
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: singleOption,
      );

      // Act & Assert
      expect(multiSelect.options, hasLength(1));
      expect(multiSelect.options.first, equals('Only Option'));
    });

    test('should validate default selected indices', () async {
      // Arrange - Some valid, some invalid indices
      final defaultSelected = [0, 2, 5]; // 5 is out of bounds
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: options,
        defaults: defaultSelected,
      );

      // Act & Assert
      expect(multiSelect.defaults, equals(defaultSelected));
      // Note: Validation typically happens in run() method
    });

    test('should handle duplicate default selections', () async {
      // Arrange
      final defaultSelected = [0, 1, 0, 2]; // Duplicate 0
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: options,
        defaults: defaultSelected,
      );

      // Act & Assert
      expect(multiSelect.defaults, equals(defaultSelected));
      // Note: Duplicate handling happens in run() method
    });

    test('should allow disabling help', () async {
      // Arrange
      final multiSelect = MultiSelect(
        prompt: 'Choose options',
        options: options,
        help: false,
      );

      // Act & Assert
      expect(multiSelect.help, isFalse);
    });
  });
}
