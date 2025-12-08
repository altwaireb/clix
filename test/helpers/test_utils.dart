import 'package:test/test.dart';
import 'package:clix/src/core/style/theme.dart';
import 'mock_io.dart';

/// Test utilities for prompt testing
class TestUtils {
  /// Create a basic theme for testing
  static CliTheme createTestTheme() {
    return CliTheme.defaultTheme();
  }

  /// Create a mock IO with predefined inputs
  static MockIO createMockIO({List<String>? inputs}) {
    final mockIO = MockIO();
    if (inputs != null) {
      mockIO.addInputs(inputs);
    }
    return mockIO;
  }

  /// Check if output contains the confirmation pattern
  static void expectConfirmation(
    MockIO mockIO,
    String question,
    String answer,
  ) {
    final outputs = mockIO.outputs.join('');
    expect(outputs, contains('✓'));
    expect(outputs, contains(question));
    expect(outputs, contains(answer));
  }

  /// Check if output contains the question
  static void expectQuestion(MockIO mockIO, String question) {
    final outputs = mockIO.outputs.join('');
    expect(outputs, contains(question));
  }

  /// Check if output contains validation error
  static void expectValidationError(MockIO mockIO, String error) {
    final outputs = mockIO.outputs.join('');
    expect(outputs, contains(error));
  }

  /// Count how many times a text appears in outputs
  static int countInOutputs(MockIO mockIO, String text) {
    final outputs = mockIO.outputs.join('');
    return text.allMatches(outputs).length;
  }

  /// Get all outputs as a single string
  static String getAllOutputs(MockIO mockIO) {
    return mockIO.outputs.join('');
  }

  /// Clear everything and prepare for next test
  static void resetMockIO(MockIO mockIO) {
    mockIO.reset();
  }
}
