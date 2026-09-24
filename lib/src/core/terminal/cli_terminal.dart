/// Terminal abstraction owned by Clix.
///
/// This API intentionally hides the underlying terminal implementation so
/// Clix can evolve its platform-specific behavior without exposing `dart:io`
/// details to consumers.
abstract interface class CliTerminal {
  CliTerminalInput get input;
  CliTerminalOutput get output;
}

abstract interface class CliTerminalInput {
  /// Whether stdin is attached to an interactive terminal.
  bool get hasTerminal;

  /// Whether typed characters are echoed by the terminal.
  bool get echoMode;
  set echoMode(bool value);

  /// Whether stdin is line-buffered.
  bool get lineMode;
  set lineMode(bool value);

  /// Reads one byte synchronously.
  int readByteSync();

  /// Reads one complete line synchronously.
  String? readLineSync();
}

abstract interface class CliTerminalOutput {
  /// Whether stdout is attached to an interactive terminal.
  bool get hasTerminal;

  /// Terminal width in columns, or the implementation fallback.
  int get terminalColumns;

  /// Terminal height in rows, or the implementation fallback.
  int get terminalLines;

  void write(Object? object);
  void writeln([Object? object = '']);
}
