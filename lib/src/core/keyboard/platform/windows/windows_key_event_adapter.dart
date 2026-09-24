import '../../cli_key_event.dart';

/// Converts native Windows KEY_EVENT_RECORD values into normalized
/// [CliKeyEvent] instances.
///
/// This adapter intentionally contains no console I/O and no mutable keyboard
/// state. That makes the Windows input mapping independently testable.
final class WindowsKeyEventAdapter {
  static const int vkBackspace = 0x08;
  static const int vkTab = 0x09;
  static const int vkEnter = 0x0D;
  static const int vkShift = 0x10;
  static const int vkControl = 0x11;
  static const int vkAlt = 0x12;
  static const int vkPause = 0x13;
  static const int vkCapsLock = 0x14;
  static const int vkEscape = 0x1B;
  static const int vkSpace = 0x20;
  static const int vkPageUp = 0x21;
  static const int vkPageDown = 0x22;
  static const int vkEnd = 0x23;
  static const int vkHome = 0x24;
  static const int vkLeft = 0x25;
  static const int vkUp = 0x26;
  static const int vkRight = 0x27;
  static const int vkDown = 0x28;
  static const int vkInsert = 0x2D;
  static const int vkDelete = 0x2E;

  static const int vkLWin = 0x5B;
  static const int vkRWin = 0x5C;

  static const int vkLShift = 0xA0;
  static const int vkRShift = 0xA1;
  static const int vkLControl = 0xA2;
  static const int vkRControl = 0xA3;
  static const int vkLAlt = 0xA4;
  static const int vkRAlt = 0xA5;

  static const int vkF1 = 0x70;
  static const int vkF12 = 0x7B;

  /// Right Alt is pressed.
  static const int rightAltPressed = 0x0001;

  /// Left Alt is pressed.
  static const int leftAltPressed = 0x0002;

  /// Right Ctrl is pressed.
  static const int rightCtrlPressed = 0x0004;

  /// Left Ctrl is pressed.
  static const int leftCtrlPressed = 0x0008;

  /// Shift is pressed.
  static const int shiftPressed = 0x0010;

  /// Converts a Windows keyboard event into a normalized Clix event.
  ///
  /// [virtualKeyCode], [virtualScanCode], [unicodeChar], and
  /// [controlKeyState] correspond to the fields of Windows
  /// `KEY_EVENT_RECORD`.
  ///
  /// [keyDown] determines whether the event represents a press or release.
  CliKeyEvent convert({
    required int virtualKeyCode,
    required int virtualScanCode,
    required int unicodeChar,
    required int controlKeyState,
    required bool keyDown,
  }) {
    final modifier = _modifierFor(
      virtualKeyCode: virtualKeyCode,
      virtualScanCode: virtualScanCode,
      controlKeyState: controlKeyState,
    );

    if (modifier != null) {
      return keyDown
          ? CliKeyEvent.modifierDown(modifier)
          : CliKeyEvent.modifierUp(modifier);
    }

    return keyDown
        ? CliKeyEvent.keyDown(
            code: virtualKeyCode,
            text: _textFor(
              virtualKeyCode: virtualKeyCode,
              unicodeChar: unicodeChar,
            ),
          )
        : CliKeyEvent.keyUp(
            code: virtualKeyCode,
            text: _textFor(
              virtualKeyCode: virtualKeyCode,
              unicodeChar: unicodeChar,
            ),
          );
  }

  CliKeyModifierKey? _modifierFor({
    required int virtualKeyCode,
    required int virtualScanCode,
    required int controlKeyState,
  }) {
    switch (virtualKeyCode) {
      case vkLControl:
        return CliKeyModifierKey.leftCtrl;

      case vkRControl:
        return CliKeyModifierKey.rightCtrl;

      case vkLAlt:
        return CliKeyModifierKey.leftAlt;

      case vkRAlt:
        return CliKeyModifierKey.rightAlt;

      case vkLShift:
        return CliKeyModifierKey.leftShift;

      case vkRShift:
        return CliKeyModifierKey.rightShift;

      case vkLWin:
        return CliKeyModifierKey.leftWindows;

      case vkRWin:
        return CliKeyModifierKey.rightWindows;

      case vkControl:
        return _controlModifier(controlKeyState: controlKeyState);

      case vkAlt:
        return _altModifier(controlKeyState: controlKeyState);

      case vkShift:
        return _shiftModifier(virtualScanCode: virtualScanCode);
    }

    return null;
  }

  CliKeyModifierKey? _controlModifier({required int controlKeyState}) {
    final hasLeft = (controlKeyState & leftCtrlPressed) != 0;
    final hasRight = (controlKeyState & rightCtrlPressed) != 0;

    if (hasLeft && !hasRight) {
      return CliKeyModifierKey.leftCtrl;
    }

    if (hasRight && !hasLeft) {
      return CliKeyModifierKey.rightCtrl;
    }

    return hasLeft
        ? CliKeyModifierKey.leftCtrl
        : hasRight
        ? CliKeyModifierKey.rightCtrl
        : null;
  }

  CliKeyModifierKey? _altModifier({required int controlKeyState}) {
    final hasLeft = (controlKeyState & leftAltPressed) != 0;
    final hasRight = (controlKeyState & rightAltPressed) != 0;

    if (hasLeft && !hasRight) {
      return CliKeyModifierKey.leftAlt;
    }

    if (hasRight && !hasLeft) {
      return CliKeyModifierKey.rightAlt;
    }

    return hasLeft
        ? CliKeyModifierKey.leftAlt
        : hasRight
        ? CliKeyModifierKey.rightAlt
        : null;
  }

  CliKeyModifierKey _shiftModifier({required int virtualScanCode}) {
    // Windows uses scan code 0x2A for left Shift and 0x36 for right Shift.
    if (virtualScanCode == 0x36) {
      return CliKeyModifierKey.rightShift;
    }

    return CliKeyModifierKey.leftShift;
  }

  String? _textFor({required int virtualKeyCode, required int unicodeChar}) {
    if (unicodeChar != 0) {
      return String.fromCharCode(unicodeChar);
    }

    if (virtualKeyCode == vkSpace) {
      return ' ';
    }

    return null;
  }
}
