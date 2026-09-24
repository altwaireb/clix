import 'dart:async';

import 'cli_terminal.dart';
import 'dart_cli_terminal.dart';

/// Global access point for the active Clix terminal.
///
/// The context is intentionally small: it only stores the terminal instance.
/// Higher-level behavior belongs in [CliTerminalControl], key handling, and
/// prompts rather than in this global.
abstract final class CliTerminalContext {
  static CliTerminal? _current;

  CliTerminalContext._();

  /// Returns the active terminal, lazily creating the default terminal.
  static CliTerminal get current => _current ??= DartCliTerminal();

  /// Installs [terminal] as the active terminal.
  static set current(CliTerminal terminal) => _current = terminal;

  /// Restores the lazy default-terminal state.
  static void reset() => _current = null;

  /// Whether a terminal instance has already been installed or created.
  static bool get isInitialized => _current != null;

  /// Captures the current context without forcing lazy initialization.
  static CliTerminalContextSnapshot capture() =>
      CliTerminalContextSnapshot._(_current);

  /// Runs [body] with [terminal] installed, then restores the previous state.
  static T runWith<T>(CliTerminal terminal, T Function() body) {
    final snapshot = capture();
    current = terminal;
    try {
      return body();
    } finally {
      snapshot.restore();
    }
  }

  /// Async counterpart of [runWith].
  static Future<T> runWithAsync<T>(
    CliTerminal terminal,
    FutureOr<T> Function() body,
  ) async {
    final snapshot = capture();
    current = terminal;
    try {
      return await Future<T>.sync(body);
    } finally {
      snapshot.restore();
    }
  }

  static CliTerminalInput get input => current.input;
  static CliTerminalOutput get output => current.output;
}

/// Restorable snapshot of [CliTerminalContext].
final class CliTerminalContextSnapshot {
  final CliTerminal? _terminal;

  CliTerminalContextSnapshot._(this._terminal);

  bool get wasInitialized => _terminal != null;

  CliTerminal? get terminal => _terminal;

  void restore() {
    if (_terminal == null) {
      CliTerminalContext.reset();
    } else {
      CliTerminalContext.current = _terminal;
    }
  }
}
