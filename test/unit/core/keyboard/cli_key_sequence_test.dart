import 'dart:convert';

import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_modifier.dart';
import 'package:clix/src/core/keyboard/cli_key_sequence.dart';
import 'package:clix/src/core/keyboard/cli_key_type.dart';
import 'package:test/test.dart';

void main() {
  group('CliKeySequenceParser', () {
    group('empty input', () {
      test('returns null for empty bytes', () {
        expect(CliKeySequenceParser.parse([]), isNull);
      });
    });

    group('control characters', () {
      test('parses Ctrl+C', () {
        final key = CliKeySequenceParser.parse([3]);

        expect(key, const CliKey.ctrlC());
      });

      test('parses Ctrl+D', () {
        final key = CliKeySequenceParser.parse([4]);

        expect(key, const CliKey.ctrlD());
      });

      test('parses Ctrl+E', () {
        final key = CliKeySequenceParser.parse([5]);

        expect(key, const CliKey.ctrlE());
      });

      test('parses Ctrl+R', () {
        final key = CliKeySequenceParser.parse([18]);

        expect(key, const CliKey.ctrlR());
      });

      test('parses generic control characters', () {
        final key = CliKeySequenceParser.parse([1]);

        expect(key, const CliKey.ctrlGeneric('a'));
      });

      test('parses Ctrl+B', () {
        final key = CliKeySequenceParser.parse([2]);

        expect(key, const CliKey.ctrlGeneric('b'));
      });

      test('parses Ctrl+Z', () {
        final key = CliKeySequenceParser.parse([26]);

        expect(key, const CliKey.ctrlGeneric('z'));
      });

      test('parses zero as unknown', () {
        final key = CliKeySequenceParser.parse([0]);

        expect(key, const CliKey.unknown(code: 0));
      });
    });

    group('basic keys', () {
      test('parses Tab', () {
        final key = CliKeySequenceParser.parse([9]);

        expect(key, const CliKey.tab());
      });

      test('parses LF as Enter', () {
        final key = CliKeySequenceParser.parse([10]);

        expect(key, const CliKey.enter());
      });

      test('parses CR as Enter', () {
        final key = CliKeySequenceParser.parse([13]);

        expect(key, const CliKey.enter());
      });

      test('parses Space', () {
        final key = CliKeySequenceParser.parse([32]);

        expect(key, const CliKey.space());
      });

      test('parses Backspace byte 8', () {
        final key = CliKeySequenceParser.parse([8]);

        expect(key, const CliKey.backspace());
      });

      test('parses DEL byte 127 as Backspace', () {
        final key = CliKeySequenceParser.parse([127]);

        expect(key, const CliKey.backspace());
      });

      test('parses printable ASCII character', () {
        final key = CliKeySequenceParser.parse([97]);

        expect(key, const CliKey.character('a'));
      });

      test('parses printable punctuation', () {
        final key = CliKeySequenceParser.parse([64]);

        expect(key, const CliKey.character('@'));
      });
    });

    group('UTF-8', () {
      test('parses a UTF-8 character', () {
        final key = CliKeySequenceParser.parse(utf8.encode('م'));

        expect(key, const CliKey.character('م'));
      });

      test('parses multiple-byte UTF-8 text', () {
        const text = 'مرحبا';
        final key = CliKeySequenceParser.parse(utf8.encode(text));

        expect(key, const CliKey.character(text));
      });

      test('returns unknown for malformed UTF-8', () {
        final key = CliKeySequenceParser.parse([0xD8, 0x00]);

        expect(key, const CliKey.unknown(code: 0xD8));
      });
    });

    group('Escape', () {
      test('parses a standalone Escape byte', () {
        final key = CliKeySequenceParser.parse([27]);

        expect(key, const CliKey.escape());
      });

      test('parses an unknown escape sequence', () {
        final key = CliKeySequenceParser.parse([27, 88]);

        expect(key, const CliKey.unknown(code: 88));
      });
    });

    group('CSI arrow keys', () {
      test('parses Arrow Up', () {
        final key = CliKeySequenceParser.parse([27, 91, 65]);

        expect(key, const CliKey.arrowUp());
      });

      test('parses Arrow Down', () {
        final key = CliKeySequenceParser.parse([27, 91, 66]);

        expect(key, const CliKey.arrowDown());
      });

      test('parses Arrow Right', () {
        final key = CliKeySequenceParser.parse([27, 91, 67]);

        expect(key, const CliKey.arrowRight());
      });

      test('parses Arrow Left', () {
        final key = CliKeySequenceParser.parse([27, 91, 68]);

        expect(key, const CliKey.arrowLeft());
      });
    });

    group('CSI navigation keys', () {
      test('parses Home', () {
        final key = CliKeySequenceParser.parse([27, 91, 72]);

        expect(key, const CliKey.home());
      });

      test('parses End', () {
        final key = CliKeySequenceParser.parse([27, 91, 70]);

        expect(key, const CliKey.end());
      });
    });

    group('CSI tilde sequences', () {
      test('parses Home using sequence 1~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 126]);

        expect(key, const CliKey.home());
      });

      test('parses Home using sequence 7~', () {
        final key = CliKeySequenceParser.parse([27, 91, 55, 126]);

        expect(key, const CliKey.home());
      });

      test('parses Insert', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 126]);

        expect(key, const CliKey.insert());
      });

      test('parses Delete', () {
        final key = CliKeySequenceParser.parse([27, 91, 51, 126]);

        expect(key, const CliKey.delete());
      });

      test('parses End using sequence 4~', () {
        final key = CliKeySequenceParser.parse([27, 91, 52, 126]);

        expect(key, const CliKey.end());
      });

      test('parses End using sequence 8~', () {
        final key = CliKeySequenceParser.parse([27, 91, 56, 126]);

        expect(key, const CliKey.end());
      });

      test('parses Page Up', () {
        final key = CliKeySequenceParser.parse([27, 91, 53, 126]);

        expect(key, const CliKey.pageUp());
      });

      test('parses Page Down', () {
        final key = CliKeySequenceParser.parse([27, 91, 54, 126]);

        expect(key, const CliKey.pageDown());
      });

      test('returns unknown for unsupported tilde sequence', () {
        final key = CliKeySequenceParser.parse([27, 91, 57, 57, 126]);

        expect(key, const CliKey.unknown(code: 99));
      });
    });

    group('Function keys', () {
      test('parses F1 using SS3', () {
        final key = CliKeySequenceParser.parse([27, 79, 80]);

        expect(key, const CliKey.functionKey(1));
      });

      test('parses F2 using SS3', () {
        final key = CliKeySequenceParser.parse([27, 79, 81]);

        expect(key, const CliKey.functionKey(2));
      });

      test('parses F3 using SS3', () {
        final key = CliKeySequenceParser.parse([27, 79, 82]);

        expect(key, const CliKey.functionKey(3));
      });

      test('parses F4 using SS3', () {
        final key = CliKeySequenceParser.parse([27, 79, 83]);

        expect(key, const CliKey.functionKey(4));
      });

      test('parses F1 using CSI 11~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 49, 126]);

        expect(key, const CliKey.functionKey(1));
      });

      test('parses F2 using CSI 12~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 50, 126]);

        expect(key, const CliKey.functionKey(2));
      });

      test('parses F5 using CSI 15~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 53, 126]);

        expect(key, const CliKey.functionKey(5));
      });

      test('parses F6 using CSI 17~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 55, 126]);

        expect(key, const CliKey.functionKey(6));
      });

      test('parses F7 using CSI 18~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 56, 126]);

        expect(key, const CliKey.functionKey(7));
      });

      test('parses F8 using CSI 19~', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 57, 126]);

        expect(key, const CliKey.functionKey(8));
      });

      test('parses F9 using CSI 20~', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 48, 126]);

        expect(key, const CliKey.functionKey(9));
      });

      test('parses F10 using CSI 21~', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 49, 126]);

        expect(key, const CliKey.functionKey(10));
      });

      test('parses F11 using CSI 23~', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 51, 126]);

        expect(key, const CliKey.functionKey(11));
      });

      test('parses F12 using CSI 24~', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 52, 126]);

        expect(key, const CliKey.functionKey(12));
      });
    });

    group('CSI modifiers', () {
      test('parses Shift modifier', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 50, 65]);

        expect(key, const CliKey.arrowUp(modifiers: {CliKeyModifier.shift}));
      });

      test('parses Alt modifier', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 51, 65]);

        expect(key, const CliKey.arrowUp(modifiers: {CliKeyModifier.alt}));
      });

      test('parses Alt+Shift modifiers', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 52, 65]);

        expect(
          key,
          const CliKey.arrowUp(
            modifiers: {CliKeyModifier.alt, CliKeyModifier.shift},
          ),
        );
      });

      test('parses Ctrl modifier', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 53, 65]);

        expect(key, const CliKey.arrowUp(modifiers: {CliKeyModifier.ctrl}));
      });

      test('parses Ctrl+Shift modifiers', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 54, 65]);

        expect(
          key,
          const CliKey.arrowUp(
            modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
          ),
        );
      });

      test('parses Ctrl+Alt modifiers', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 55, 65]);

        expect(
          key,
          const CliKey.arrowUp(
            modifiers: {CliKeyModifier.ctrl, CliKeyModifier.alt},
          ),
        );
      });

      test('parses Ctrl+Alt+Shift modifiers', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 56, 65]);

        expect(
          key,
          const CliKey.arrowUp(
            modifiers: {
              CliKeyModifier.ctrl,
              CliKeyModifier.alt,
              CliKeyModifier.shift,
            },
          ),
        );
      });

      test('ignores an unsupported modifier value', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 57, 65]);

        expect(key, const CliKey.arrowUp());
      });
    });

    group('CSI modifiers with navigation keys', () {
      test('applies modifiers to Home', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 53, 72]);

        expect(key, const CliKey.home(modifiers: {CliKeyModifier.ctrl}));
      });

      test('applies modifiers to End', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 59, 51, 70]);

        expect(key, const CliKey.end(modifiers: {CliKeyModifier.alt}));
      });

      test('applies modifiers to Insert', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 59, 53, 126]);

        expect(key, const CliKey.insert(modifiers: {CliKeyModifier.ctrl}));
      });

      test('applies modifiers to Delete', () {
        final key = CliKeySequenceParser.parse([27, 91, 51, 59, 53, 126]);

        expect(key, const CliKey.delete(modifiers: {CliKeyModifier.ctrl}));
      });

      test('applies modifiers to Page Up', () {
        final key = CliKeySequenceParser.parse([27, 91, 53, 59, 54, 126]);

        expect(
          key,
          const CliKey.pageUp(
            modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
          ),
        );
      });

      test('applies modifiers to Page Down', () {
        final key = CliKeySequenceParser.parse([27, 91, 54, 59, 56, 126]);

        expect(
          key,
          const CliKey.pageDown(
            modifiers: {
              CliKeyModifier.ctrl,
              CliKeyModifier.alt,
              CliKeyModifier.shift,
            },
          ),
        );
      });
    });

    group('CSI modifiers with function keys', () {
      test('applies modifiers to F1', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 49, 59, 53, 126]);

        expect(
          key,
          const CliKey.functionKey(1, modifiers: {CliKeyModifier.ctrl}),
        );
      });

      test('applies modifiers to F12', () {
        final key = CliKeySequenceParser.parse([27, 91, 50, 52, 59, 54, 126]);

        expect(
          key,
          const CliKey.functionKey(
            12,
            modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
          ),
        );
      });
    });

    group('invalid CSI input', () {
      test('returns unknown for unsupported CSI final byte', () {
        final key = CliKeySequenceParser.parse([27, 91, 49, 90]);

        expect(key, const CliKey.unknown(code: 91));
      });

      test('returns unknown for incomplete CSI sequence', () {
        final key = CliKeySequenceParser.parse([27, 91]);

        expect(key, const CliKey.unknown(code: 91));
      });

      test('returns unknown for unknown SS3 sequence', () {
        final key = CliKeySequenceParser.parse([27, 79, 90]);

        expect(key, const CliKey.unknown(code: 79));
      });
    });

    group('parser contract', () {
      test('does not modify the input list', () {
        final bytes = <int>[27, 91, 65];

        final original = List<int>.from(bytes);

        CliKeySequenceParser.parse(bytes);

        expect(bytes, equals(original));
      });

      test('returns a CliKey for valid input', () {
        final key = CliKeySequenceParser.parse([65]);

        expect(key, isA<CliKey>());
        expect(key!.type, CliKeyType.character);
      });
    });
  });
}
