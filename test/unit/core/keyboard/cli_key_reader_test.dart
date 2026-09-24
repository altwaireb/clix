import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_modifier.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:test/test.dart';

void main() {
  group('CliKeyReader', () {
    test('uses the provided source', () {
      final source = _FakeKeySource(keys: [const CliKey.character('a')]);

      final reader = CliKeyReader(source: source);

      expect(reader.source, same(source));
    });

    test('starts the source', () {
      final source = _FakeKeySource();
      final reader = CliKeyReader(source: source);

      expect(reader.isStarted, isFalse);

      reader.start();

      expect(reader.isStarted, isTrue);
      expect(source.startCount, 1);
    });

    test('reads a key from the source', () {
      final expected = const CliKey.character('a');
      final source = _FakeKeySource(keys: [expected]);
      final reader = CliKeyReader(source: source);

      reader.start();

      expect(reader.read(), expected);
      expect(source.readCount, 1);
    });

    test('stops the source', () {
      final source = _FakeKeySource();
      final reader = CliKeyReader(source: source);

      reader.start();
      reader.stop();

      expect(reader.isStarted, isFalse);
      expect(source.stopCount, 1);
    });

    test('disposes the source', () {
      final source = _FakeKeySource();
      final reader = CliKeyReader(source: source);

      reader.start();
      reader.dispose();

      expect(reader.isStarted, isFalse);
      expect(source.disposeCount, 1);
    });

    test('forwards multiple reads in order', () {
      final source = _FakeKeySource(
        keys: [
          const CliKey.character('a'),
          const CliKey.character('b'),
          const CliKey.enter(),
        ],
      );

      final reader = CliKeyReader(source: source);

      reader.start();

      expect(reader.read(), const CliKey.character('a'));
      expect(reader.read(), const CliKey.character('b'));
      expect(reader.read(), const CliKey.enter());
    });
  });

  group('CliByteKeySource', () {
    test('starts in a stopped state', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      expect(source.isStarted, isFalse);
    });

    test('start changes isStarted to true', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.isStarted, isTrue);
    });

    test('readKey requires start', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [97],
        ],
      );
      final source = CliByteKeySource(byteSource);

      expect(source.readKey, throwsStateError);
    });

    test('readKey parses the byte sequence', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [97],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.readKey(), const CliKey.character('a'));
    });

    test('readKey parses control input', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [3],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.readKey(), const CliKey.ctrlC());
    });

    test('readKey parses ANSI sequences', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [27, 91, 65],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.readKey(), const CliKey.arrowUp());
    });

    test('returns unknown for an empty parsed sequence', () {
      final byteSource = _FakeByteSource(sequences: [[]]);
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.readKey(), const CliKey.unknown());
    });

    test('readKey forwards each sequence to the byte source', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [97],
          [98],
          [13],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();

      expect(source.readKey(), const CliKey.character('a'));
      expect(source.readKey(), const CliKey.character('b'));
      expect(source.readKey(), const CliKey.enter());

      expect(byteSource.readCount, 3);
    });

    test('stop changes isStarted to false', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.start();
      source.stop();

      expect(source.isStarted, isFalse);
    });

    test('stop is safe when already stopped', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.stop();

      expect(source.isStarted, isFalse);
    });

    test('dispose stops the source', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.start();
      source.dispose();

      expect(source.isStarted, isFalse);
    });

    test('dispose is idempotent', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.start();
      source.dispose();
      source.dispose();

      expect(source.isStarted, isFalse);
    });

    test('start after dispose throws StateError', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.dispose();

      expect(source.start, throwsStateError);
    });

    test('readKey after dispose throws StateError', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [97],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();
      source.dispose();

      expect(source.readKey, throwsStateError);
    });

    test('stop after dispose is safe', () {
      final byteSource = _FakeByteSource();
      final source = CliByteKeySource(byteSource);

      source.start();
      source.dispose();

      expect(source.stop, returnsNormally);
      expect(source.isStarted, isFalse);
    });

    test('dispose does not read from the byte source', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [97],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();
      source.dispose();

      expect(byteSource.readCount, 0);
    });

    test('preserves modifier information parsed from ANSI input', () {
      final byteSource = _FakeByteSource(
        sequences: [
          [27, 91, 49, 59, 53, 65],
        ],
      );
      final source = CliByteKeySource(byteSource);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.arrowUp(modifiers: {CliKeyModifier.ctrl}));
    });
  });
}

final class _FakeByteSource implements CliKeyByteSource {
  final List<List<int>> sequences;
  int _index = 0;
  int readCount = 0;

  _FakeByteSource({List<List<int>>? sequences})
    : sequences = sequences ?? const [];

  @override
  List<int> readKeySequence() {
    readCount++;

    if (_index >= sequences.length) {
      return const [];
    }

    return sequences[_index++];
  }
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
