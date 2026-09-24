import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';
import 'package:test/test.dart';

void main() {
  group('CliKeyboard', () {
    test('uses the provided reader', () {
      final source = _FakeKeySource();
      final reader = CliKeyReader(source: source);
      final keyboard = CliKeyboard(reader: reader);

      expect(keyboard.reader, same(reader));
    });

    test('starts the reader', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      expect(keyboard.isStarted, isFalse);

      keyboard.start();

      expect(keyboard.isStarted, isTrue);
      expect(source.startCount, 1);
    });

    test('reads a key from the reader', () {
      final source = _FakeKeySource(keys: [const CliKey.character('a')]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();

      expect(keyboard.read(), const CliKey.character('a'));
      expect(source.readCount, 1);
    });

    test('reads multiple keys in order', () {
      final source = _FakeKeySource(
        keys: [
          const CliKey.character('a'),
          const CliKey.arrowDown(),
          const CliKey.enter(),
        ],
      );

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();

      expect(keyboard.read(), const CliKey.character('a'));
      expect(keyboard.read(), const CliKey.arrowDown());
      expect(keyboard.read(), const CliKey.enter());

      expect(source.readCount, 3);
    });

    test('stops the reader', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();
      keyboard.stop();

      expect(keyboard.isStarted, isFalse);
      expect(source.stopCount, 1);
    });

    test('disposes the reader', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.start();
      keyboard.dispose();

      expect(keyboard.isStarted, isFalse);
      expect(source.disposeCount, 1);
    });

    test('stop can be called while already stopped', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.stop();

      expect(keyboard.isStarted, isFalse);
      expect(source.stopCount, 1);
    });

    test('dispose can be called more than once', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      keyboard.dispose();
      keyboard.dispose();

      expect(source.disposeCount, 2);
      expect(keyboard.isStarted, isFalse);
    });

    test('forwards reader state through isStarted', () {
      final source = _FakeKeySource();
      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      expect(keyboard.isStarted, isFalse);

      source.start();

      expect(keyboard.isStarted, isTrue);

      source.stop();

      expect(keyboard.isStarted, isFalse);
    });
  });
}

final class _FakeKeySource implements CliKeySource {
  final List<CliKey> keys;

  bool _started = false;
  int _readIndex = 0;

  int startCount = 0;
  int readCount = 0;
  int stopCount = 0;
  int disposeCount = 0;

  _FakeKeySource({List<CliKey>? keys}) : keys = keys ?? const [];

  @override
  bool get isStarted => _started;

  @override
  void start() {
    startCount++;
    _started = true;
  }

  @override
  CliKey readKey() {
    readCount++;

    if (_readIndex >= keys.length) {
      return const CliKey.unknown();
    }

    return keys[_readIndex++];
  }

  @override
  void stop() {
    stopCount++;
    _started = false;
  }

  @override
  void dispose() {
    disposeCount++;
    _started = false;
  }
}
