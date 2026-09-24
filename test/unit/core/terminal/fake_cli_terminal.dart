import 'package:clix/src/core/terminal/cli_terminal.dart';

import 'fake_cli_terminal_output.dart';

final class FakeCliTerminal implements CliTerminal {
  @override
  final CliTerminalInput input = FakeCliTerminalInput();

  @override
  final FakeCliTerminalOutput output = FakeCliTerminalOutput();
}

final class FakeCliTerminalInput implements CliTerminalInput {
  @override
  bool hasTerminal = true;

  @override
  bool echoMode = true;

  @override
  bool lineMode = true;

  @override
  int readByteSync() => -1;

  @override
  String? readLineSync() => null;
}
