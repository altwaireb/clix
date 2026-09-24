import 'package:test/test.dart';

import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';

void main() {
  group('CliKeyboard lifecycle', () {
    test('starts, reads, and stops a key source', () {
      final source = _FakeKeySource(const CliKey.character('a'));
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      expect(keyboard.isStarted, isFalse);

      keyboard.start();
      expect(keyboard.isStarted, isTrue);
      expect(keyboard.read(), const CliKey.character('a'));

      keyboard.stop();
      expect(keyboard.isStarted, isFalse);
      expect(source.startCount, 1);
      expect(source.stopCount, 1);
    });

    test('start is idempotent', () {
      final source = _FakeKeySource(const CliKey.enter());
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();
      keyboard.start();

      expect(source.startCount, 1);
    });

    test('stop is idempotent', () {
      final source = _FakeKeySource(const CliKey.enter());
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();
      keyboard.stop();
      keyboard.stop();

      expect(source.stopCount, 1);
    });

    test('reading before start throws', () {
      final source = _FakeKeySource(const CliKey.enter());
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      expect(keyboard.read, throwsStateError);
    });

    test('dispose stops an active session', () {
      final source = _FakeKeySource(const CliKey.escape());
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();
      keyboard.dispose();

      expect(keyboard.isStarted, isFalse);
      expect(source.stopCount, 1);
      expect(source.disposeCount, 1);
    });
  });
}

final class _FakeKeySource implements CliKeySource {
  final CliKey key;

  bool _started = false;
  bool _disposed = false;
  int startCount = 0;
  int stopCount = 0;
  int disposeCount = 0;

  _FakeKeySource(this.key);

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_disposed) throw StateError('disposed');
    if (_started) return;
    _started = true;
    startCount++;
  }

  @override
  CliKey readKey() {
    if (_disposed) throw StateError('disposed');
    if (!_started) throw StateError('not started');
    return key;
  }

  @override
  void stop() {
    if (_disposed || !_started) return;
    _started = false;
    stopCount++;
  }

  @override
  void dispose() {
    if (_disposed) return;
    stop();
    _disposed = true;
    disposeCount++;
  }
}
