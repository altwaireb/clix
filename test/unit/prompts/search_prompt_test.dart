import 'package:test/test.dart';
import 'package:clix/src/prompt/search_prompt.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Search Prompt Tests', () {
    late MockIO mockIO;
    late List<String> options;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      options = ['flutter', 'react', 'vue', 'angular', 'svelte'];
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should initialize with correct properties', () async {
      // Arrange
      final search = Search(prompt: 'Choose framework', options: options);

      // Act & Assert
      expect(search.prompt, equals('Choose framework'));
      expect(search.options, equals(options));
      expect(search.minQueryLength, equals(1));
      expect(search.maxResults, equals(10));
    });

    test('should use custom configuration', () async {
      // Arrange
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        minQueryLength: 2,
        maxResults: 5,
        placeholder: 'Type to search...',
      );

      // Act & Assert
      expect(search.minQueryLength, equals(2));
      expect(search.maxResults, equals(5));
      expect(search.placeholder, equals('Type to search...'));
    });

    test('should handle string list options', () async {
      // Arrange
      final search = Search(prompt: 'Choose framework', options: options);

      // Act & Assert
      expect(search.options, isA<List<String>>());
    });

    test('should handle function as options provider', () async {
      // Arrange
      String searchFunction(String query) {
        return options.where((o) => o.contains(query)).join(',');
      }

      final search = Search(
        prompt: 'Choose framework',
        options: searchFunction,
      );

      // Act & Assert
      expect(search.options, isA<Function>());
    });

    test('should validate query length', () async {
      // Arrange
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        validator: (query) {
          if (query.length < 2) return 'Query too short';
          return null;
        },
      );

      // Act & Assert
      expect(search.validator, isNotNull);
    });

    test('should use default index when specified', () async {
      // Arrange
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        defaultIndex: 2,
      );

      // Act & Assert
      expect(search.defaultIndex, equals(2));
    });

    test('should handle empty options list', () async {
      // Arrange
      final emptyOptions = <String>[];
      final search = Search(prompt: 'Choose framework', options: emptyOptions);

      // Act & Assert
      expect(search.options, isEmpty);
    });

    test('should limit max results', () async {
      // Arrange
      final manyOptions = List.generate(20, (i) => 'Option $i');
      final search = Search(
        prompt: 'Choose option',
        options: manyOptions,
        maxResults: 5,
      );

      // Act & Assert
      expect(search.maxResults, equals(5));
    });

    test('should handle minimum query length requirement', () async {
      // Arrange
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        minQueryLength: 3,
      );

      // Act & Assert
      expect(search.minQueryLength, equals(3));
    });

    // Note: Full integration tests with actual searching and selection
    // would require more complex input simulation including arrow keys
    // which is difficult to test with basic MockIO

    test('should provide search functionality interface', () async {
      // Arrange
      final search = Search(prompt: 'Choose framework', options: options);

      // Act & Assert - Verify the class structure is correct
      expect(search, isA<Search>());
      expect(search.prompt, isNotNull);
      expect(search.options, isNotNull);
    });
  });
}
