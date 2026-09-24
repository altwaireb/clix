/// Abstract CLI input/output interface
///
/// Defines the core interface for CLI input/output operations. This abstraction
/// allows for different implementations (console, mock, etc.) to be used
/// interchangeably throughout the CLI application.
///
/// Core methods:
/// - `write()`: Output text without newline
/// - `writeln()`: Output text with newline
/// - `readLine()`: Read a complete line of input
/// - `read()`: Read input using a specific input mode
/// - `isTTY`: Check if running in terminal
///
/// Usage:
/// ```dart
/// CliIO io = ConsoleIO();
/// io.write('Enter name: ');
/// final name = io.readLine();
/// io.writeln('Hello $name');
/// ```
library;

/// Defines how CLI input should be read.
enum CliInputMode {
  /// Read a complete line with normal terminal echo.
  line,

  /// Read a complete line without displaying typed characters.
  hidden,
}

abstract class CliIO {
  void write(String text);

  void writeln([String text = '']);

  String readLine();

  String read({CliInputMode mode = CliInputMode.line});

  bool get isTTY;
}
