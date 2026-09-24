import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';

final class FakeCliKeySource implements CliKeySource {
  final List<CliKey> keys;

  int readCalls = 0;
  bool _started = false;
  bool _disposed = false;

  FakeCliKeySource(this.keys);

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_disposed) {
      throw StateError('FakeCliKeySource has been disposed.');
    }

    _started = true;
  }

  @override
  CliKey readKey() {
    if (_disposed) {
      throw StateError('FakeCliKeySource has been disposed.');
    }

    if (!_started) {
      throw StateError('FakeCliKeySource has not been started.');
    }

    if (readCalls >= keys.length) {
      throw StateError('No more fake keys available.');
    }

    return keys[readCalls++];
  }

  @override
  void stop() {
    _started = false;
  }

  @override
  void dispose() {
    if (_disposed) return;

    stop();
    _disposed = true;
  }
}
