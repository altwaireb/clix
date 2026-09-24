import 'package:clix/src/core/terminal/cli_terminal_core.dart';
import 'package:test/test.dart';

class Output implements CliTerminalOutput {
  Output({
    this.hasTerminal = true,
    this.terminalColumns = 132,
    this.terminalLines = 44,
  });

  @override
  final bool hasTerminal;

  @override
  final int terminalColumns;

  @override
  final int terminalLines;

  @override
  void write(Object? object) {}

  @override
  void writeln([Object? object = '']) {}
}

class Terminal implements CliTerminal {
  Terminal({Output? output}) : output = output ?? Output();

  @override
  final input = _Input();

  @override
  final CliTerminalOutput output;
}

class _Input implements CliTerminalInput {
  @override
  bool hasTerminal = true;

  @override
  bool echoMode = true;

  @override
  bool lineMode = true;

  @override
  int readByteSync() => 0;

  @override
  String? readLineSync() => null;
}

void main() {
  tearDown(CliTerminalContext.reset);

  test('reports terminal size', () {
    CliTerminalContext.current = Terminal();

    expect(CliTerminalInfo.hasTerminal, isTrue);
    expect(CliTerminalInfo.columns, 132);
    expect(CliTerminalInfo.rows, 44);
    expect(CliTerminalInfo.size, const CliTerminalSize(columns: 132, rows: 44));
  });

  test('uses defaults when output has no terminal', () {
    final terminal = Terminal(output: Output(hasTerminal: false));

    CliTerminalContext.current = terminal;

    expect(CliTerminalInfo.hasTerminal, isFalse);
    expect(CliTerminalInfo.columns, CliTerminalInfo.defaultColumns);
    expect(CliTerminalInfo.rows, CliTerminalInfo.defaultRows);
  });
}
