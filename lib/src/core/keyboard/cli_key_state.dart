import 'cli_key_event.dart';
import 'cli_key_modifier.dart';

/// Tracks physical modifier keys and exposes their logical state.
///
/// The state deliberately tracks physical left/right modifier keys instead
/// of only storing logical modifiers. This prevents one physical key from
/// releasing a logical modifier that is still held by its other counterpart.
///
/// For example:
///
/// ```text
/// Left Ctrl  down
/// Right Ctrl down
/// Left Ctrl  up
/// ```
///
/// must still report `ctrl` as pressed.
final class CliKeyState {
  final Set<CliKeyModifierKey> _pressedModifiers = {};

  /// The physical modifier keys currently held down.
  Set<CliKeyModifierKey> get pressedModifiers =>
      Set.unmodifiable(_pressedModifiers);

  /// The logical modifiers currently active.
  Set<CliKeyModifier> get modifiers {
    final result = <CliKeyModifier>{};

    for (final modifier in _pressedModifiers) {
      result.add(modifier.logicalModifier);
    }

    return Set.unmodifiable(result);
  }

  /// Whether [modifier] is currently active.
  bool isPressed(CliKeyModifier modifier) => modifiers.contains(modifier);

  /// Whether a physical modifier key is currently held.
  bool isPhysicalPressed(CliKeyModifierKey modifier) =>
      _pressedModifiers.contains(modifier);

  /// Applies a modifier event to the current state.
  ///
  /// Non-modifier events are ignored.
  void apply(CliKeyEvent event) {
    final modifier = event.modifier;
    if (modifier == null) return;

    switch (event.type) {
      case CliKeyEventType.down:
        _pressedModifiers.add(modifier);

      case CliKeyEventType.up:
        _pressedModifiers.remove(modifier);
    }
  }

  /// Clears all modifier state.
  ///
  /// This is useful when a terminal session ends or when a platform backend
  /// needs to recover from an interrupted input sequence.
  void clear() {
    _pressedModifiers.clear();
  }

  @override
  String toString() {
    return 'CliKeyState('
        'pressedModifiers: $_pressedModifiers, '
        'modifiers: $modifiers'
        ')';
  }
}
