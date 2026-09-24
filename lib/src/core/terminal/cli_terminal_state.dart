import 'cli_terminal.dart';

/// A captured terminal input state that can be restored safely.
final class CliTerminalState {
  final CliTerminalInput _input;
  final bool _echoMode;
  final bool _lineMode;
  bool _restored = false;

  CliTerminalState({
    required CliTerminalInput input,
    required bool echoMode,
    required bool lineMode,
  }) : _input = input,
       _echoMode = echoMode,
       _lineMode = lineMode;

  bool get isRestored => _restored;

  /// Restores the captured modes. Calling this more than once is safe.
  void restore() {
    if (_restored) return;

    Object? firstError;

    try {
      _input.echoMode = _echoMode;
    } catch (error) {
      firstError ??= error;
    }

    try {
      _input.lineMode = _lineMode;
    } catch (error) {
      firstError ??= error;
    }

    _restored = true;

    if (firstError != null) {
      Error.throwWithStackTrace(firstError, StackTrace.current);
    }
  }
}
