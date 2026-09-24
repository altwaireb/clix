import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_modifier.dart';
import 'package:clix/src/core/keyboard/cli_key_type.dart';
import 'package:test/test.dart';

void main() {
  group('CliKey', () {
    group('Character', () {
      test('creates a character key', () {
        const key = CliKey.character('a');

        expect(key.type, CliKeyType.character);
        expect(key.text, 'a');
        expect(key.isCharacter, isTrue);
        expect(key.isPrintable, isTrue);
      });

      test('supports modifiers', () {
        const key = CliKey.character('c', modifiers: {CliKeyModifier.ctrl});

        expect(key.text, 'c');
        expect(key.isCtrl, isTrue);
        expect(key.hasModifier(CliKeyModifier.ctrl), isTrue);
      });
    });

    group('Space', () {
      test('creates a space key', () {
        const key = CliKey.space();

        expect(key.type, CliKeyType.space);
        expect(key.text, ' ');
        expect(key.isSpace, isTrue);
        expect(key.isPrintable, isTrue);
      });
    });

    group('Basic keys', () {
      test('creates enter key', () {
        const key = CliKey.enter();

        expect(key.type, CliKeyType.enter);
        expect(key.isEnter, isTrue);
        expect(key.isPrintable, isFalse);
      });

      test('creates tab key', () {
        const key = CliKey.tab();

        expect(key.type, CliKeyType.tab);
        expect(key.isTab, isTrue);
      });

      test('creates escape key', () {
        const key = CliKey.escape();

        expect(key.type, CliKeyType.escape);
        expect(key.isEscape, isTrue);
      });

      test('creates backspace key', () {
        const key = CliKey.backspace();

        expect(key.type, CliKeyType.backspace);
        expect(key.isBackspace, isTrue);
      });

      test('creates delete key', () {
        const key = CliKey.delete();

        expect(key.type, CliKeyType.delete);
        expect(key.isDelete, isTrue);
      });
    });

    group('Arrow keys', () {
      test('creates arrow up key', () {
        const key = CliKey.arrowUp();

        expect(key.type, CliKeyType.arrowUp);
        expect(key.isArrow, isTrue);
        expect(key.isArrowUp, isTrue);
        expect(key.isArrowDown, isFalse);
        expect(key.isArrowLeft, isFalse);
        expect(key.isArrowRight, isFalse);
      });

      test('creates arrow down key', () {
        const key = CliKey.arrowDown();

        expect(key.type, CliKeyType.arrowDown);
        expect(key.isArrow, isTrue);
        expect(key.isArrowDown, isTrue);
      });

      test('creates arrow left key', () {
        const key = CliKey.arrowLeft();

        expect(key.type, CliKeyType.arrowLeft);
        expect(key.isArrow, isTrue);
        expect(key.isArrowLeft, isTrue);
      });

      test('creates arrow right key', () {
        const key = CliKey.arrowRight();

        expect(key.type, CliKeyType.arrowRight);
        expect(key.isArrow, isTrue);
        expect(key.isArrowRight, isTrue);
      });
    });

    group('Navigation keys', () {
      test('creates home key', () {
        const key = CliKey.home();

        expect(key.type, CliKeyType.home);
        expect(key.isHome, isTrue);
      });

      test('creates end key', () {
        const key = CliKey.end();

        expect(key.type, CliKeyType.end);
        expect(key.isEnd, isTrue);
      });

      test('creates page up key', () {
        const key = CliKey.pageUp();

        expect(key.type, CliKeyType.pageUp);
        expect(key.isPageUp, isTrue);
      });

      test('creates page down key', () {
        const key = CliKey.pageDown();

        expect(key.type, CliKeyType.pageDown);
        expect(key.isPageDown, isTrue);
      });

      test('creates insert key', () {
        const key = CliKey.insert();

        expect(key.type, CliKeyType.insert);
        expect(key.isInsert, isTrue);
      });
    });

    group('Control keys', () {
      test('creates Ctrl+C', () {
        const key = CliKey.ctrlC();

        expect(key.type, CliKeyType.ctrlC);
        expect(key.isControl, isTrue);
        expect(key.isCtrl, isTrue);
      });

      test('creates Ctrl+D', () {
        const key = CliKey.ctrlD();

        expect(key.type, CliKeyType.ctrlD);
        expect(key.isControl, isTrue);
        expect(key.isCtrl, isTrue);
      });

      test('creates Ctrl+R', () {
        const key = CliKey.ctrlR();

        expect(key.type, CliKeyType.ctrlR);
        expect(key.isControl, isTrue);
        expect(key.isCtrl, isTrue);
      });

      test('creates Ctrl+E', () {
        const key = CliKey.ctrlE();

        expect(key.type, CliKeyType.ctrlE);
        expect(key.isControl, isTrue);
        expect(key.isCtrl, isTrue);
      });

      test('creates generic Ctrl key', () {
        const key = CliKey.ctrlGeneric('a');

        expect(key.type, CliKeyType.ctrlGeneric);
        expect(key.text, 'a');
        expect(key.isControl, isTrue);
        expect(key.isCtrl, isTrue);
      });
    });

    group('Function keys', () {
      test('creates a function key', () {
        const key = CliKey.functionKey(5);

        expect(key.type, CliKeyType.function);
        expect(key.functionNumber, 5);
        expect(key.isFunctionKey, isTrue);
      });

      test('supports modifiers on function keys', () {
        const key = CliKey.functionKey(
          12,
          modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
        );

        expect(key.functionNumber, 12);
        expect(key.isFunctionKey, isTrue);
        expect(key.isCtrl, isTrue);
        expect(key.isShift, isTrue);
      });
    });

    group('Unknown keys', () {
      test('creates an unknown key', () {
        const key = CliKey.unknown(code: 255, text: 'unknown');

        expect(key.type, CliKeyType.unknown);
        expect(key.code, 255);
        expect(key.text, 'unknown');
      });

      test('supports unknown key without values', () {
        const key = CliKey.unknown();

        expect(key.type, CliKeyType.unknown);
        expect(key.code, isNull);
        expect(key.text, isNull);
      });
    });

    group('Modifiers', () {
      test('detects Ctrl modifier', () {
        const key = CliKey.enter(modifiers: {CliKeyModifier.ctrl});

        expect(key.isCtrl, isTrue);
        expect(key.isAlt, isFalse);
        expect(key.isShift, isFalse);
        expect(key.isCommand, isFalse);
        expect(key.isWindows, isFalse);
      });

      test('detects Alt modifier', () {
        const key = CliKey.enter(modifiers: {CliKeyModifier.alt});

        expect(key.isAlt, isTrue);
        expect(key.isCtrl, isFalse);
      });

      test('detects Shift modifier', () {
        const key = CliKey.enter(modifiers: {CliKeyModifier.shift});

        expect(key.isShift, isTrue);
      });

      test('detects Command modifier', () {
        const key = CliKey.enter(modifiers: {CliKeyModifier.command});

        expect(key.isCommand, isTrue);
      });

      test('detects Windows modifier', () {
        const key = CliKey.enter(modifiers: {CliKeyModifier.windows});

        expect(key.isWindows, isTrue);
      });

      test('detects multiple modifiers', () {
        const key = CliKey.arrowUp(
          modifiers: {
            CliKeyModifier.ctrl,
            CliKeyModifier.alt,
            CliKeyModifier.shift,
          },
        );

        expect(key.isCtrl, isTrue);
        expect(key.isAlt, isTrue);
        expect(key.isShift, isTrue);
        expect(key.isCommand, isFalse);
        expect(key.isWindows, isFalse);
      });

      test('hasModifier returns whether a modifier exists', () {
        const key = CliKey.character(
          'x',
          modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
        );

        expect(key.hasModifier(CliKeyModifier.ctrl), isTrue);
        expect(key.hasModifier(CliKeyModifier.shift), isTrue);
        expect(key.hasModifier(CliKeyModifier.alt), isFalse);
      });
    });

    group('Printable state', () {
      test('character is printable', () {
        const key = CliKey.character('x');

        expect(key.isPrintable, isTrue);
      });

      test('space is printable', () {
        const key = CliKey.space();

        expect(key.isPrintable, isTrue);
      });

      test('enter is not printable', () {
        const key = CliKey.enter();

        expect(key.isPrintable, isFalse);
      });

      test('arrow is not printable', () {
        const key = CliKey.arrowDown();

        expect(key.isPrintable, isFalse);
      });
    });

    group('Equality', () {
      test('equal keys are equal', () {
        const first = CliKey.character('a', modifiers: {CliKeyModifier.ctrl});

        const second = CliKey.character('a', modifiers: {CliKeyModifier.ctrl});

        expect(first, equals(second));
      });

      test('different text makes keys unequal', () {
        const first = CliKey.character('a');
        const second = CliKey.character('b');

        expect(first, isNot(equals(second)));
      });

      test('different type makes keys unequal', () {
        const first = CliKey.character('a');
        const second = CliKey.space();

        expect(first, isNot(equals(second)));
      });

      test('different modifiers make keys unequal', () {
        const first = CliKey.character('a');

        const second = CliKey.character('a', modifiers: {CliKeyModifier.ctrl});

        expect(first, isNot(equals(second)));
      });

      test('function number participates in equality', () {
        const first = CliKey.functionKey(1);
        const second = CliKey.functionKey(2);

        expect(first, isNot(equals(second)));
      });

      test('equal keys have equal hash codes', () {
        const first = CliKey.arrowUp(modifiers: {CliKeyModifier.ctrl});

        const second = CliKey.arrowUp(modifiers: {CliKeyModifier.ctrl});

        expect(first.hashCode, equals(second.hashCode));
      });

      test('modifier order does not affect equality', () {
        const first = CliKey.character(
          'x',
          modifiers: {CliKeyModifier.ctrl, CliKeyModifier.shift},
        );

        const second = CliKey.character(
          'x',
          modifiers: {CliKeyModifier.shift, CliKeyModifier.ctrl},
        );

        expect(first, equals(second));
        expect(first.hashCode, equals(second.hashCode));
      });
    });

    group('toString', () {
      test('formats character key', () {
        const key = CliKey.character('a');

        expect(key.toString(), 'CliKey(CliKeyType.character, a)');
      });

      test('formats control key', () {
        const key = CliKey.ctrlGeneric('r');

        expect(
          key.toString(),
          'CliKey(CliKeyType.ctrlGeneric, r, '
          'modifiers: {CliKeyModifier.ctrl})',
        );
      });

      test('formats function key', () {
        const key = CliKey.functionKey(12);

        expect(key.toString(), 'CliKey(CliKeyType.function, F12)');
      });

      test('formats regular key', () {
        const key = CliKey.arrowUp();

        expect(key.toString(), 'CliKey(CliKeyType.arrowUp)');
      });

      test('formats modifiers', () {
        const key = CliKey.arrowUp(modifiers: {CliKeyModifier.ctrl});

        expect(key.toString(), contains('modifiers:'));
        expect(key.toString(), contains('CliKeyModifier.ctrl'));
      });
    });
  });
}
