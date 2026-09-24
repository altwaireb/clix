import 'cli_key_modifier.dart';

/// The physical transition represented by a keyboard event.
enum CliKeyEventType {
  /// A key was pressed.
  down,

  /// A key was released.
  up,
}

/// A normalized keyboard event before it is resolved into a [CliKey].
///
/// Platform backends produce events from their native input systems. The
/// keyboard state layer consumes these events and keeps track of modifier keys
/// across multiple physical events.
final class CliKeyEvent {
  final CliKeyEventType type;

  /// The physical modifier associated with this event, when the event
  /// represents a modifier key itself.
  final CliKeyModifierKey? modifier;

  /// Optional virtual/native key code supplied by the platform backend.
  final int? code;

  /// Optional textual representation supplied by the platform backend.
  final String? text;

  const CliKeyEvent({required this.type, this.modifier, this.code, this.text});

  const CliKeyEvent.keyDown({this.code, this.text})
    : type = CliKeyEventType.down,
      modifier = null;

  const CliKeyEvent.keyUp({this.code, this.text})
    : type = CliKeyEventType.up,
      modifier = null;

  const CliKeyEvent.modifierDown(this.modifier)
    : type = CliKeyEventType.down,
      code = null,
      text = null;

  const CliKeyEvent.modifierUp(this.modifier)
    : type = CliKeyEventType.up,
      code = null,
      text = null;

  @override
  String toString() {
    return 'CliKeyEvent('
        'type: $type, '
        'modifier: $modifier, '
        'code: $code, '
        'text: $text'
        ')';
  }
}

/// A physical modifier key.
///
/// This is deliberately more specific than [CliKeyModifier]. A platform may
/// distinguish left and right physical keys while the public Clix key model
/// only needs the logical modifier.
enum CliKeyModifierKey {
  leftCtrl,
  rightCtrl,
  leftAlt,
  rightAlt,
  leftShift,
  rightShift,
  leftCommand,
  rightCommand,
  leftWindows,
  rightWindows,
}

/// Converts a physical modifier key to its logical Clix modifier.
extension CliKeyModifierKeyExtension on CliKeyModifierKey {
  CliKeyModifier get logicalModifier {
    switch (this) {
      case CliKeyModifierKey.leftCtrl:
      case CliKeyModifierKey.rightCtrl:
        return CliKeyModifier.ctrl;

      case CliKeyModifierKey.leftAlt:
      case CliKeyModifierKey.rightAlt:
        return CliKeyModifier.alt;

      case CliKeyModifierKey.leftShift:
      case CliKeyModifierKey.rightShift:
        return CliKeyModifier.shift;

      case CliKeyModifierKey.leftCommand:
      case CliKeyModifierKey.rightCommand:
        return CliKeyModifier.command;

      case CliKeyModifierKey.leftWindows:
      case CliKeyModifierKey.rightWindows:
        return CliKeyModifier.windows;
    }
  }
}
