import 'package:clix/src/core/terminal/cli_terminal.dart';

final class FakeCliTerminalOutput implements CliTerminalOutput {
  final List<String> writes = [];

  @override
  bool hasTerminal = true;

  @override
  int terminalColumns = 80;

  @override
  int terminalLines = 24;

  @override
  void write(Object? object) {
    writes.add('$object');
  }

  @override
  void writeln([Object? object = '']) {
    writes.add('${object ?? ''}\n');
  }

  String get output => writes.join();

  void clear() {
    writes.clear();
  }
}
