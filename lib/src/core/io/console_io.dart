/// Console-based CLI input/output implementation
///
/// Provides real console I/O operations using Dart's built-in stdin/stdout.
/// This is the standard implementation used in production CLI applications.
///
/// Features:
/// - Direct console output via stdout
/// - User input reading via stdin
/// - Terminal detection support
/// - Synchronous operations
///
/// Usage:
/// ```dart
/// final io = ConsoleIO();
/// io.writeln('Welcome to CLI app');
///
/// if (io.isTTY) {
///   io.write('Enter command: ');
///   String command = io.readLine();
/// }
/// ```
library;

import 'dart:io';
import 'cli_io.dart';

class ConsoleIO implements CliIO {
  @override
  void write(String text) => stdout.write(text);

  @override
  void writeln([String text = '']) => stdout.writeln(text);

  @override
  String readLine() => stdin.readLineSync() ?? '';

  @override
  bool get isTTY => stdin.hasTerminal;
}
