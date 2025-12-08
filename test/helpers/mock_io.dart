import 'package:clix/src/core/io/cli_io.dart';

/// Mock IO implementation for testing prompts
class MockIO implements CliIO {
  final List<String> _inputs = [];
  final List<String> _outputs = [];
  int _inputIndex = 0;

  /// Add inputs that will be returned by readLine()
  void addInputs(List<String> inputs) {
    _inputs.addAll(inputs);
  }

  /// Add a single input
  void addInput(String input) {
    _inputs.add(input);
  }

  /// Get all outputs written to this IO
  List<String> get outputs => List.unmodifiable(_outputs);

  /// Get the last output written
  String? get lastOutput => _outputs.isNotEmpty ? _outputs.last : null;

  /// Clear all outputs
  void clearOutputs() {
    _outputs.clear();
  }

  /// Clear all inputs
  void clearInputs() {
    _inputs.clear();
    _inputIndex = 0;
  }

  /// Reset everything
  void reset() {
    clearInputs();
    clearOutputs();
  }

  @override
  void write(String text) {
    _outputs.add(text);
  }

  @override
  void writeln([String text = '']) {
    _outputs.add('$text\n');
  }

  @override
  String readLine() {
    if (_inputIndex < _inputs.length) {
      return _inputs[_inputIndex++];
    }
    throw StateError(
      'No more inputs available. Add more inputs with addInput()',
    );
  }

  @override
  bool get isTTY => true; // For testing, assume we're in a TTY
}
