import 'package:clix/src/core/keyboard/cli_key_event.dart';
import 'package:clix/src/core/keyboard/cli_key_modifier.dart';
import 'package:clix/src/core/keyboard/cli_key_state.dart';
import 'package:test/test.dart';

void main() {
  group('CliKeyModifierKeyExtension', () {
    test('maps left and right Ctrl to logical Ctrl', () {
      expect(CliKeyModifierKey.leftCtrl.logicalModifier, CliKeyModifier.ctrl);
      expect(CliKeyModifierKey.rightCtrl.logicalModifier, CliKeyModifier.ctrl);
    });

    test('maps left and right Alt to logical Alt', () {
      expect(CliKeyModifierKey.leftAlt.logicalModifier, CliKeyModifier.alt);
      expect(CliKeyModifierKey.rightAlt.logicalModifier, CliKeyModifier.alt);
    });

    test('maps left and right Shift to logical Shift', () {
      expect(CliKeyModifierKey.leftShift.logicalModifier, CliKeyModifier.shift);
      expect(
        CliKeyModifierKey.rightShift.logicalModifier,
        CliKeyModifier.shift,
      );
    });

    test('maps left and right Command to logical Command', () {
      expect(
        CliKeyModifierKey.leftCommand.logicalModifier,
        CliKeyModifier.command,
      );
      expect(
        CliKeyModifierKey.rightCommand.logicalModifier,
        CliKeyModifier.command,
      );
    });

    test('maps left and right Windows to logical Windows', () {
      expect(
        CliKeyModifierKey.leftWindows.logicalModifier,
        CliKeyModifier.windows,
      );
      expect(
        CliKeyModifierKey.rightWindows.logicalModifier,
        CliKeyModifier.windows,
      );
    });
  });

  group('CliKeyEvent', () {
    test('creates a generic key down event', () {
      const event = CliKeyEvent.keyDown(code: 65, text: 'A');

      expect(event.type, CliKeyEventType.down);
      expect(event.modifier, isNull);
      expect(event.code, 65);
      expect(event.text, 'A');
    });

    test('creates a generic key up event', () {
      const event = CliKeyEvent.keyUp(code: 65, text: 'A');

      expect(event.type, CliKeyEventType.up);
      expect(event.modifier, isNull);
      expect(event.code, 65);
      expect(event.text, 'A');
    });

    test('creates a modifier down event', () {
      const event = CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl);

      expect(event.type, CliKeyEventType.down);
      expect(event.modifier, CliKeyModifierKey.leftCtrl);
      expect(event.code, isNull);
      expect(event.text, isNull);
    });

    test('creates a modifier up event', () {
      const event = CliKeyEvent.modifierUp(CliKeyModifierKey.rightShift);

      expect(event.type, CliKeyEventType.up);
      expect(event.modifier, CliKeyModifierKey.rightShift);
      expect(event.code, isNull);
      expect(event.text, isNull);
    });

    test('toString includes event details', () {
      const event = CliKeyEvent.modifierDown(CliKeyModifierKey.leftAlt);

      expect(event.toString(), contains('CliKeyEvent'));
      expect(event.toString(), contains('CliKeyEventType.down'));
      expect(event.toString(), contains('CliKeyModifierKey.leftAlt'));
    });
  });

  group('CliKeyState', () {
    test('starts with no physical modifiers', () {
      final state = CliKeyState();

      expect(state.pressedModifiers, isEmpty);
    });

    test('starts with no logical modifiers', () {
      final state = CliKeyState();

      expect(state.modifiers, isEmpty);
    });

    test('starts with no active modifiers', () {
      final state = CliKeyState();

      expect(state.isPressed(CliKeyModifier.ctrl), isFalse);
      expect(state.isPressed(CliKeyModifier.alt), isFalse);
      expect(state.isPressed(CliKeyModifier.shift), isFalse);
      expect(state.isPressed(CliKeyModifier.command), isFalse);
      expect(state.isPressed(CliKeyModifier.windows), isFalse);
    });

    test('starts with no physical modifier pressed', () {
      final state = CliKeyState();

      expect(state.isPhysicalPressed(CliKeyModifierKey.leftCtrl), isFalse);
      expect(state.isPhysicalPressed(CliKeyModifierKey.rightCtrl), isFalse);
    });

    test('applies a physical modifier down event', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      expect(state.isPhysicalPressed(CliKeyModifierKey.leftCtrl), isTrue);
      expect(state.isPressed(CliKeyModifier.ctrl), isTrue);
      expect(state.pressedModifiers, contains(CliKeyModifierKey.leftCtrl));
      expect(state.modifiers, contains(CliKeyModifier.ctrl));
    });

    test('applies a physical modifier up event', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      state.apply(const CliKeyEvent.modifierUp(CliKeyModifierKey.leftCtrl));

      expect(state.isPhysicalPressed(CliKeyModifierKey.leftCtrl), isFalse);
      expect(state.isPressed(CliKeyModifier.ctrl), isFalse);
      expect(state.pressedModifiers, isEmpty);
      expect(state.modifiers, isEmpty);
    });

    test('maps left Ctrl to logical Ctrl', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      expect(state.modifiers, {CliKeyModifier.ctrl});
    });

    test('maps right Ctrl to logical Ctrl', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightCtrl));

      expect(state.modifiers, {CliKeyModifier.ctrl});
    });

    test('maps left Alt to logical Alt', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftAlt));

      expect(state.modifiers, {CliKeyModifier.alt});
    });

    test('maps right Alt to logical Alt', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightAlt));

      expect(state.modifiers, {CliKeyModifier.alt});
    });

    test('maps left Shift to logical Shift', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftShift));

      expect(state.modifiers, {CliKeyModifier.shift});
    });

    test('maps right Shift to logical Shift', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightShift));

      expect(state.modifiers, {CliKeyModifier.shift});
    });

    test('maps left Command to logical Command', () {
      final state = CliKeyState();

      state.apply(
        const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCommand),
      );

      expect(state.modifiers, {CliKeyModifier.command});
    });

    test('maps right Command to logical Command', () {
      final state = CliKeyState();

      state.apply(
        const CliKeyEvent.modifierDown(CliKeyModifierKey.rightCommand),
      );

      expect(state.modifiers, {CliKeyModifier.command});
    });

    test('maps left Windows to logical Windows', () {
      final state = CliKeyState();

      state.apply(
        const CliKeyEvent.modifierDown(CliKeyModifierKey.leftWindows),
      );

      expect(state.modifiers, {CliKeyModifier.windows});
    });

    test('maps right Windows to logical Windows', () {
      final state = CliKeyState();

      state.apply(
        const CliKeyEvent.modifierDown(CliKeyModifierKey.rightWindows),
      );

      expect(state.modifiers, {CliKeyModifier.windows});
    });

    test(
      'keeps logical modifier active while both physical sides are pressed',
      () {
        final state = CliKeyState();

        state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
        state.apply(
          const CliKeyEvent.modifierDown(CliKeyModifierKey.rightCtrl),
        );

        expect(state.isPressed(CliKeyModifier.ctrl), isTrue);
        expect(state.pressedModifiers, {
          CliKeyModifierKey.leftCtrl,
          CliKeyModifierKey.rightCtrl,
        });
      },
    );

    test('releasing one side keeps logical modifier active', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightCtrl));

      state.apply(const CliKeyEvent.modifierUp(CliKeyModifierKey.leftCtrl));

      expect(state.isPhysicalPressed(CliKeyModifierKey.leftCtrl), isFalse);
      expect(state.isPhysicalPressed(CliKeyModifierKey.rightCtrl), isTrue);
      expect(state.isPressed(CliKeyModifier.ctrl), isTrue);
      expect(state.modifiers, {CliKeyModifier.ctrl});
    });

    test('releasing both sides clears logical modifier', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightCtrl));

      state.apply(const CliKeyEvent.modifierUp(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierUp(CliKeyModifierKey.rightCtrl));

      expect(state.isPressed(CliKeyModifier.ctrl), isFalse);
      expect(state.pressedModifiers, isEmpty);
      expect(state.modifiers, isEmpty);
    });

    test('tracks multiple different logical modifiers', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightAlt));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftShift));

      expect(state.modifiers, {
        CliKeyModifier.ctrl,
        CliKeyModifier.alt,
        CliKeyModifier.shift,
      });
    });

    test('ignores non-modifier key down events', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.keyDown(code: 65, text: 'A'));

      expect(state.pressedModifiers, isEmpty);
      expect(state.modifiers, isEmpty);
    });

    test('ignores non-modifier key up events', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.keyUp(code: 65, text: 'A'));

      expect(state.pressedModifiers, isEmpty);
      expect(state.modifiers, isEmpty);
    });

    test('removes only the requested physical modifier', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftShift));

      state.apply(const CliKeyEvent.modifierUp(CliKeyModifierKey.leftCtrl));

      expect(state.pressedModifiers, {CliKeyModifierKey.leftShift});
      expect(state.modifiers, {CliKeyModifier.shift});
    });

    test('clear removes all physical and logical modifiers', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightAlt));
      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftShift));

      state.clear();

      expect(state.pressedModifiers, isEmpty);
      expect(state.modifiers, isEmpty);
      expect(state.isPressed(CliKeyModifier.ctrl), isFalse);
      expect(state.isPressed(CliKeyModifier.alt), isFalse);
      expect(state.isPressed(CliKeyModifier.shift), isFalse);
    });

    test('pressedModifiers is unmodifiable', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      final modifiers = state.pressedModifiers;

      expect(
        () => modifiers.add(CliKeyModifierKey.rightCtrl),
        throwsUnsupportedError,
      );
    });

    test('modifiers is unmodifiable', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      final modifiers = state.modifiers;

      expect(() => modifiers.add(CliKeyModifier.alt), throwsUnsupportedError);
    });

    test('does not retain an unrelated modifier after clear', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      state.clear();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.rightShift));

      expect(state.pressedModifiers, {CliKeyModifierKey.rightShift});
      expect(state.modifiers, {CliKeyModifier.shift});
    });

    test('toString contains physical and logical state', () {
      final state = CliKeyState();

      state.apply(const CliKeyEvent.modifierDown(CliKeyModifierKey.leftCtrl));

      final value = state.toString();

      expect(value, contains('CliKeyState'));
      expect(value, contains('pressedModifiers'));
      expect(value, contains('modifiers'));
      expect(value, contains('CliKeyModifierKey.leftCtrl'));
      expect(value, contains('CliKeyModifier.ctrl'));
    });
  });
}
