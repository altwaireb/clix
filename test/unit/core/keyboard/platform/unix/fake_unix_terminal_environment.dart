import 'package:clix/src/core/keyboard/platform/unix/unix_terminal_environment.dart';

final class FakeUnixTerminalEnvironment implements UnixTerminalEnvironment {
  FakeUnixTerminalEnvironment({this.hasTerminal = true});

  @override
  bool hasTerminal;
}
