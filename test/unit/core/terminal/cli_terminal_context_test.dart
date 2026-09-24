import 'package:clix/src/core/terminal/cli_terminal_core.dart';
import 'package:test/test.dart';

class TestInput implements CliTerminalInput {
  bool _echo = true;
  bool _line = true;
  final List<int> bytes = [];

  @override
  bool hasTerminal = true;

  @override
  bool get echoMode => _echo;

  @override
  set echoMode(bool value) => _echo = value;

  @override
  bool get lineMode => _line;

  @override
  set lineMode(bool value) => _line = value;

  @override
  int readByteSync() => bytes.removeAt(0);

  @override
  String? readLineSync() => null;
}

class TestOutput implements CliTerminalOutput {
  final writes = <String>[];

  @override
  bool hasTerminal = true;

  @override
  int terminalColumns = 120;

  @override
  int terminalLines = 40;

  @override
  void write(Object? object) => writes.add('$object');

  @override
  void writeln([Object? object = '']) => writes.add('$object\n');
}

class TestTerminal implements CliTerminal {
  TestTerminal(this.input, this.output);

  @override
  final TestInput input;

  @override
  final TestOutput output;
}

void main() {
  tearDown(CliTerminalContext.reset);

  test('context is lazy', () {
    expect(CliTerminalContext.isInitialized, isFalse);
    final terminal = CliTerminalContext.current;
    expect(terminal, isA<DartCliTerminal>());
    expect(CliTerminalContext.isInitialized, isTrue);
  });

  test('runWith restores uninitialized context', () {
    final terminal = TestTerminal(TestInput(), TestOutput());
    CliTerminalContext.runWith(terminal, () {
      expect(identical(CliTerminalContext.current, terminal), isTrue);
    });
    expect(CliTerminalContext.isInitialized, isFalse);
  });

  test('runWith restores previous context', () {
    final first = TestTerminal(TestInput(), TestOutput());
    final second = TestTerminal(TestInput(), TestOutput());
    CliTerminalContext.current = first;

    CliTerminalContext.runWith(second, () {
      expect(identical(CliTerminalContext.current, second), isTrue);
    });

    expect(identical(CliTerminalContext.current, first), isTrue);
  });

  test('runWithAsync restores previous context', () async {
    final first = TestTerminal(TestInput(), TestOutput());
    final second = TestTerminal(TestInput(), TestOutput());
    CliTerminalContext.current = first;

    await CliTerminalContext.runWithAsync(second, () async {
      expect(identical(CliTerminalContext.current, second), isTrue);
      await Future<void>.value();
    });

    expect(identical(CliTerminalContext.current, first), isTrue);
  });
}
