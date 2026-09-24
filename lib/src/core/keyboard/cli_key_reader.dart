import '../terminal/cli_terminal.dart';
import '../terminal/cli_terminal_context.dart';
import 'cli_key.dart';
import 'cli_key_sequence.dart';
import 'platform/cli_platform_key_source.dart';

/// Reads normalized keys from a platform-aware input source.
final class CliKeyReader {
  final CliKeySource source;

  CliKeyReader({CliKeySource? source})
    : source = source ?? CliPlatformKeySource.create();

  bool get isStarted => source.isStarted;

  void start() => source.start();

  CliKey read() => source.readKey();

  void stop() => source.stop();

  void dispose() => source.dispose();
}

/// Supplies normalized keyboard events to [CliKeyReader].
abstract interface class CliKeySource {
  bool get isStarted;
  void start();
  CliKey readKey();
  void stop();
  void dispose();
}

abstract interface class CliKeyByteSource {
  List<int> readKeySequence();
}

final class CliByteKeySource implements CliKeySource {
  final CliKeyByteSource source;
  bool _started = false;
  bool _disposed = false;

  CliByteKeySource(this.source);

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_disposed) throw StateError('CliByteKeySource has been disposed.');
    _started = true;
  }

  @override
  CliKey readKey() {
    if (_disposed) throw StateError('CliByteKeySource has been disposed.');
    if (!_started) throw StateError('CliByteKeySource has not been started.');

    return CliKeySequenceParser.parse(source.readKeySequence()) ??
        const CliKey.unknown();
  }

  @override
  void stop() {
    if (_disposed) return;
    _started = false;
  }

  @override
  void dispose() {
    if (_disposed) return;
    stop();
    _disposed = true;
  }
}

final class CliTerminalByteSource implements CliKeyByteSource {
  final CliTerminalInput input;

  CliTerminalByteSource({CliTerminalInput? input})
    : input = input ?? CliTerminalContext.input;

  @override
  List<int> readKeySequence() => [input.readByteSync()];
}
