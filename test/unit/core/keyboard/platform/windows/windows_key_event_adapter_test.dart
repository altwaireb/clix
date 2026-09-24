import 'package:clix/src/core/keyboard/cli_key_event.dart';
import 'package:clix/src/core/keyboard/platform/windows/windows_key_event_adapter.dart';
import 'package:test/test.dart';

void main() {
  final adapter = WindowsKeyEventAdapter();

  group('WindowsKeyEventAdapter', () {
    group('regular keys', () {
      test('converts key down with Unicode text', () {
        final event = adapter.convert(
          virtualKeyCode: 0x41,
          virtualScanCode: 0x1E,
          unicodeChar: 0x41,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, isNull);
        expect(event.code, 0x41);
        expect(event.text, 'A');
      });

      test('converts key up with Unicode text', () {
        final event = adapter.convert(
          virtualKeyCode: 0x41,
          virtualScanCode: 0x1E,
          unicodeChar: 0x41,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
        expect(event.modifier, isNull);
        expect(event.code, 0x41);
        expect(event.text, 'A');
      });

      test('preserves Unicode characters', () {
        final event = adapter.convert(
          virtualKeyCode: 0x41,
          virtualScanCode: 0x1E,
          unicodeChar: 0x645,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, 0x41);
        expect(event.text, 'م');
      });

      test('uses space as text when Unicode character is zero', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkSpace,
          virtualScanCode: 0x39,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkSpace);
        expect(event.text, ' ');
      });

      test('returns null text when key has no Unicode character', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkHome,
          virtualScanCode: 0x47,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkHome);
        expect(event.text, isNull);
      });
    });

    group('Ctrl modifier', () {
      test('maps left Ctrl virtual key to leftCtrl', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.leftCtrl);
        expect(event.code, isNull);
        expect(event.text, isNull);
      });

      test('maps right Ctrl virtual key to rightCtrl', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.rightCtrl);
      });

      test('maps generic Ctrl using left control state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.leftCtrlPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.leftCtrl);
      });

      test('maps generic Ctrl using right control state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.rightCtrlPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.rightCtrl);
      });

      test('prefers left Ctrl when both control flags are present', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState:
              WindowsKeyEventAdapter.leftCtrlPressed |
              WindowsKeyEventAdapter.rightCtrlPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.leftCtrl);
      });

      test('returns a normal key event when generic Ctrl has no state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, isNull);
        expect(event.code, WindowsKeyEventAdapter.vkControl);
        expect(event.text, isNull);
      });

      test('creates Ctrl key-up event for left Ctrl', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLControl,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
        expect(event.modifier, CliKeyModifierKey.leftCtrl);
      });
    });

    group('Alt modifier', () {
      test('maps left Alt virtual key to leftAlt', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.leftAlt);
      });

      test('maps right Alt virtual key to rightAlt', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.rightAlt);
      });

      test('maps generic Alt using left Alt state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.leftAltPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.leftAlt);
      });

      test('maps generic Alt using right Alt state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.rightAltPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.rightAlt);
      });

      test('prefers left Alt when both Alt flags are present', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState:
              WindowsKeyEventAdapter.leftAltPressed |
              WindowsKeyEventAdapter.rightAltPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.leftAlt);
      });

      test('returns a normal key event when generic Alt has no state', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, isNull);
        expect(event.code, WindowsKeyEventAdapter.vkAlt);
      });

      test('creates Alt key-up event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRAlt,
          virtualScanCode: 0x38,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
        expect(event.modifier, CliKeyModifierKey.rightAlt);
      });
    });

    group('Shift modifier', () {
      test('maps left Shift using left scan code', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkShift,
          virtualScanCode: 0x2A,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.shiftPressed,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.leftShift);
      });

      test('maps right Shift using right scan code', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkShift,
          virtualScanCode: 0x36,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.shiftPressed,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.rightShift);
      });

      test('maps explicit left Shift virtual key', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLShift,
          virtualScanCode: 0x2A,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.shiftPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.leftShift);
      });

      test('maps explicit right Shift virtual key', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRShift,
          virtualScanCode: 0x36,
          unicodeChar: 0,
          controlKeyState: WindowsKeyEventAdapter.shiftPressed,
          keyDown: true,
        );

        expect(event.modifier, CliKeyModifierKey.rightShift);
      });

      test('creates Shift key-up event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLShift,
          virtualScanCode: 0x2A,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
        expect(event.modifier, CliKeyModifierKey.leftShift);
      });
    });

    group('Windows modifier keys', () {
      test('maps left Windows key', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkLWin,
          virtualScanCode: 0x5B,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.leftWindows);
      });

      test('maps right Windows key', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRWin,
          virtualScanCode: 0x5C,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.modifier, CliKeyModifierKey.rightWindows);
      });

      test('creates Windows key-up event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkRWin,
          virtualScanCode: 0x5C,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
        expect(event.modifier, CliKeyModifierKey.rightWindows);
      });
    });

    group('non-modifier keys', () {
      test('maps Backspace as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkBackspace,
          virtualScanCode: 0x0E,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkBackspace);
        expect(event.text, isNull);
        expect(event.modifier, isNull);
      });

      test('maps Tab as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkTab,
          virtualScanCode: 0x0F,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkTab);
        expect(event.text, isNull);
      });

      test('maps Enter as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkEnter,
          virtualScanCode: 0x1C,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkEnter);
        expect(event.text, isNull);
      });

      test('maps Escape as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkEscape,
          virtualScanCode: 0x01,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, WindowsKeyEventAdapter.vkEscape);
        expect(event.text, isNull);
      });

      test('maps Home as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkHome,
          virtualScanCode: 0x47,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkHome);
      });

      test('maps End as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkEnd,
          virtualScanCode: 0x4F,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkEnd);
      });

      test('maps Page Up as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkPageUp,
          virtualScanCode: 0x49,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkPageUp);
      });

      test('maps Page Down as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkPageDown,
          virtualScanCode: 0x51,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkPageDown);
      });

      test('maps Insert as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkInsert,
          virtualScanCode: 0x52,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkInsert);
      });

      test('maps Delete as a normal key event', () {
        final event = adapter.convert(
          virtualKeyCode: WindowsKeyEventAdapter.vkDelete,
          virtualScanCode: 0x53,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.code, WindowsKeyEventAdapter.vkDelete);
      });

      test('maps arrow keys as normal key events', () {
        const arrowKeys = [
          WindowsKeyEventAdapter.vkLeft,
          WindowsKeyEventAdapter.vkUp,
          WindowsKeyEventAdapter.vkRight,
          WindowsKeyEventAdapter.vkDown,
        ];

        for (final keyCode in arrowKeys) {
          final event = adapter.convert(
            virtualKeyCode: keyCode,
            virtualScanCode: 0,
            unicodeChar: 0,
            controlKeyState: 0,
            keyDown: true,
          );

          expect(event.type, CliKeyEventType.down);
          expect(event.code, keyCode);
          expect(event.modifier, isNull);
        }
      });
    });

    group('key transitions', () {
      test('preserves key-down transition', () {
        final event = adapter.convert(
          virtualKeyCode: 0x41,
          virtualScanCode: 0x1E,
          unicodeChar: 0x41,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
      });

      test('preserves key-up transition', () {
        final event = adapter.convert(
          virtualKeyCode: 0x41,
          virtualScanCode: 0x1E,
          unicodeChar: 0x41,
          controlKeyState: 0,
          keyDown: false,
        );

        expect(event.type, CliKeyEventType.up);
      });
    });

    group('unsupported and unknown keys', () {
      test('preserves an unknown virtual key code', () {
        const virtualKeyCode = 0xFE;

        final event = adapter.convert(
          virtualKeyCode: virtualKeyCode,
          virtualScanCode: 0,
          unicodeChar: 0,
          controlKeyState: 0,
          keyDown: true,
        );

        expect(event.type, CliKeyEventType.down);
        expect(event.code, virtualKeyCode);
        expect(event.text, isNull);
        expect(event.modifier, isNull);
      });
    });
  });
}
