import 'dart:io' as io;

import 'cli_terminal.dart';

/// Default Clix terminal backed by `dart:io`.
final class DartCliTerminal implements CliTerminal {
  late final DartCliTerminalInput _input = DartCliTerminalInput();
  late final DartCliTerminalOutput _output = DartCliTerminalOutput();

  @override
  CliTerminalInput get input => _input;

  @override
  CliTerminalOutput get output => _output;
}

final class DartCliTerminalInput implements CliTerminalInput {
  @override
  bool get hasTerminal {
    try {
      return io.stdin.hasTerminal;
    } catch (_) {
      return false;
    }
  }

  @override
  bool get echoMode => io.stdin.echoMode;

  @override
  set echoMode(bool value) => io.stdin.echoMode = value;

  @override
  bool get lineMode => io.stdin.lineMode;

  @override
  set lineMode(bool value) => io.stdin.lineMode = value;

  @override
  int readByteSync() => io.stdin.readByteSync();

  @override
  String? readLineSync() => io.stdin.readLineSync();
}

final class DartCliTerminalOutput implements CliTerminalOutput {
  static const defaultColumns = 80;
  static const defaultLines = 24;

  @override
  bool get hasTerminal {
    try {
      return io.stdout.hasTerminal;
    } catch (_) {
      return false;
    }
  }

  @override
  int get terminalColumns {
    try {
      return io.stdout.hasTerminal ? io.stdout.terminalColumns : defaultColumns;
    } catch (_) {
      return defaultColumns;
    }
  }

  @override
  int get terminalLines {
    try {
      return io.stdout.hasTerminal ? io.stdout.terminalLines : defaultLines;
    } catch (_) {
      return defaultLines;
    }
  }

  @override
  void write(Object? object) => io.stdout.write(object);

  @override
  void writeln([Object? object = '']) => io.stdout.writeln(object);
}
