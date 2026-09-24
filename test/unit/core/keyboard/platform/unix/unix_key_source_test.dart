import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_key_type.dart';
import 'package:clix/src/core/keyboard/platform/unix/unix_key_source.dart';
import 'package:test/test.dart';

final class FakeKeyByteSource implements CliKeyByteSource {
  final List<List<int>> sequences;

  FakeKeyByteSource(Iterable<List<int>> sequences)
    : sequences = sequences.map(List<int>.from).toList();

  int readCount = 0;

  @override
  List<int> readKeySequence() {
    readCount++;

    if (sequences.isEmpty) {
      throw StateError('FakeKeyByteSource has no more sequences.');
    }

    return sequences.removeAt(0);
  }
}

void main() {
  group('UnixKeySource', () {
    test('starts in a stopped state', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('starts successfully with an injected source', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();

      expect(source.isStarted, isTrue);

      source.dispose();
    });

    test('start is idempotent', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();
      source.start();

      expect(source.isStarted, isTrue);

      source.dispose();
    });

    test('reads a character from an injected source', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('a'));

      source.dispose();
    });

    test('reads multiple keys in order', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
          [0x62],
          [0x63],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.character('a'));
      expect(source.readKey(), const CliKey.character('b'));
      expect(source.readKey(), const CliKey.character('c'));

      source.dispose();
    });

    test('reads space', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x20],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.space());

      source.dispose();
    });

    test('reads enter', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x0D],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.enter());

      source.dispose();
    });

    test('reads tab', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x09],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.tab());

      source.dispose();
    });

    test('reads backspace', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x7F],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.backspace());

      source.dispose();
    });

    test('reads escape', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x1B],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.escape());

      source.dispose();
    });

    test('reads arrow keys from ANSI sequences', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x1B, 0x5B, 0x41],
          [0x1B, 0x5B, 0x42],
          [0x1B, 0x5B, 0x43],
          [0x1B, 0x5B, 0x44],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.arrowUp());
      expect(source.readKey(), const CliKey.arrowDown());
      expect(source.readKey(), const CliKey.arrowRight());
      expect(source.readKey(), const CliKey.arrowLeft());

      source.dispose();
    });

    test('reads navigation keys from ANSI sequences', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x1B, 0x5B, 0x48],
          [0x1B, 0x5B, 0x46],
          [0x1B, 0x5B, 0x32, 0x7E],
          [0x1B, 0x5B, 0x33, 0x7E],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.home());
      expect(source.readKey(), const CliKey.end());
      expect(source.readKey(), const CliKey.insert());
      expect(source.readKey(), const CliKey.delete());

      source.dispose();
    });

    test('reads page navigation keys', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x1B, 0x5B, 0x35, 0x7E],
          [0x1B, 0x5B, 0x36, 0x7E],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.pageUp());
      expect(source.readKey(), const CliKey.pageDown());

      source.dispose();
    });

    test('reads function keys', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x1B, 0x4F, 0x50],
          [0x1B, 0x4F, 0x51],
          [0x1B, 0x4F, 0x52],
          [0x1B, 0x4F, 0x53],
          [0x1B, 0x5B, 0x31, 0x35, 0x7E],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.functionKey(1));
      expect(source.readKey(), const CliKey.functionKey(2));
      expect(source.readKey(), const CliKey.functionKey(3));
      expect(source.readKey(), const CliKey.functionKey(4));
      expect(source.readKey(), const CliKey.functionKey(5));

      source.dispose();
    });

    test('reads UTF-8 characters', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0xD9, 0x85],
          [0xD8, 0xA8],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.character('م'));
      expect(source.readKey(), const CliKey.character('ب'));

      source.dispose();
    });

    test('reads four-byte UTF-8 characters', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0xF0, 0x9F, 0x98, 0x80],
        ]),
      );

      source.start();

      expect(source.readKey(), const CliKey.character('😀'));

      source.dispose();
    });

    test('returns unknown for an empty parsed sequence', () {
      final source = UnixKeySource(source: FakeKeyByteSource([[]]));

      source.start();

      expect(source.readKey(), const CliKey.unknown());

      source.dispose();
    });

    test('returns unknown for an invalid UTF-8 sequence', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0xC2, 0x20],
        ]),
      );

      source.start();

      final key = source.readKey();

      expect(key.type, CliKeyType.unknown);

      source.dispose();
    });

    test('stop changes the started state', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();
      source.stop();

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('stop is idempotent', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();
      source.stop();
      source.stop();

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('throws when reading before start', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      expect(source.readKey, throwsStateError);

      source.dispose();
    });

    test('throws when reading after dispose', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.dispose();

      expect(source.readKey, throwsStateError);
    });

    test('throws when starting after dispose', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.dispose();

      expect(source.start, throwsStateError);
    });

    test('dispose is idempotent', () {
      final source = UnixKeySource(
        source: FakeKeyByteSource([
          [0x61],
        ]),
      );

      source.start();
      source.dispose();
      source.dispose();

      expect(source.isStarted, isFalse);
    });

    test('reads the expected number of injected sequences', () {
      final input = FakeKeyByteSource([
        [0x61],
        [0x62],
      ]);

      final source = UnixKeySource(source: input);

      source.start();

      source.readKey();
      source.readKey();

      expect(input.readCount, 2);

      source.dispose();
    });
  });
}
