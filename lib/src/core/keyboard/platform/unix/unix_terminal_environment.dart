import 'dart:io';

/// Provides the runtime terminal environment used by [UnixTty].
abstract interface class UnixTerminalEnvironment {
  bool get hasTerminal;
}

/// Real Unix terminal environment.
final class SystemUnixTerminalEnvironment implements UnixTerminalEnvironment {
  const SystemUnixTerminalEnvironment();

  @override
  bool get hasTerminal =>
      (Platform.isLinux || Platform.isMacOS) && stdin.hasTerminal;
}
