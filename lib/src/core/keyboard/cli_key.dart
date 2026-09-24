import 'cli_key_modifier.dart';
import 'cli_key_type.dart';

/// A normalized keyboard input event.
final class CliKey {
  final CliKeyType type;
  final String? text;
  final int? code;
  final int? functionNumber;
  final Set<CliKeyModifier> modifiers;

  const CliKey(
    this.type, {
    this.text,
    this.code,
    this.functionNumber,
    this.modifiers = const {},
  });

  const CliKey.character(
    String value, {
    Set<CliKeyModifier> modifiers = const {},
  }) : this(CliKeyType.character, text: value, modifiers: modifiers);

  const CliKey.space({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.space, text: ' ', modifiers: modifiers);

  const CliKey.enter({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.enter, modifiers: modifiers);

  const CliKey.tab({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.tab, modifiers: modifiers);

  const CliKey.escape({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.escape, modifiers: modifiers);

  const CliKey.backspace({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.backspace, modifiers: modifiers);

  const CliKey.delete({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.delete, modifiers: modifiers);

  const CliKey.arrowUp({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.arrowUp, modifiers: modifiers);

  const CliKey.arrowDown({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.arrowDown, modifiers: modifiers);

  const CliKey.arrowLeft({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.arrowLeft, modifiers: modifiers);

  const CliKey.arrowRight({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.arrowRight, modifiers: modifiers);

  const CliKey.home({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.home, modifiers: modifiers);

  const CliKey.end({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.end, modifiers: modifiers);

  const CliKey.pageUp({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.pageUp, modifiers: modifiers);

  const CliKey.pageDown({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.pageDown, modifiers: modifiers);

  const CliKey.insert({Set<CliKeyModifier> modifiers = const {}})
    : this(CliKeyType.insert, modifiers: modifiers);

  const CliKey.ctrlC()
    : this(CliKeyType.ctrlC, modifiers: const {CliKeyModifier.ctrl});

  const CliKey.ctrlD()
    : this(CliKeyType.ctrlD, modifiers: const {CliKeyModifier.ctrl});

  const CliKey.ctrlR()
    : this(CliKeyType.ctrlR, modifiers: const {CliKeyModifier.ctrl});

  const CliKey.ctrlE()
    : this(CliKeyType.ctrlE, modifiers: const {CliKeyModifier.ctrl});

  const CliKey.ctrlGeneric(String value)
    : this(
        CliKeyType.ctrlGeneric,
        text: value,
        modifiers: const {CliKeyModifier.ctrl},
      );

  const CliKey.functionKey(
    int number, {
    Set<CliKeyModifier> modifiers = const {},
  }) : this(CliKeyType.function, functionNumber: number, modifiers: modifiers);

  const CliKey.unknown({
    int? code,
    String? text,
    Set<CliKeyModifier> modifiers = const {},
  }) : this(CliKeyType.unknown, code: code, text: text, modifiers: modifiers);

  bool get isCharacter => type == CliKeyType.character;

  bool get isPrintable => isCharacter || type == CliKeyType.space;

  bool get isArrow =>
      type == CliKeyType.arrowUp ||
      type == CliKeyType.arrowDown ||
      type == CliKeyType.arrowLeft ||
      type == CliKeyType.arrowRight;

  bool get isArrowUp => type == CliKeyType.arrowUp;

  bool get isArrowDown => type == CliKeyType.arrowDown;

  bool get isArrowLeft => type == CliKeyType.arrowLeft;

  bool get isArrowRight => type == CliKeyType.arrowRight;

  bool get isEnter => type == CliKeyType.enter;

  bool get isSpace => type == CliKeyType.space;

  bool get isTab => type == CliKeyType.tab;

  bool get isEscape => type == CliKeyType.escape;

  bool get isBackspace => type == CliKeyType.backspace;

  bool get isDelete => type == CliKeyType.delete;

  bool get isHome => type == CliKeyType.home;

  bool get isEnd => type == CliKeyType.end;

  bool get isPageUp => type == CliKeyType.pageUp;

  bool get isPageDown => type == CliKeyType.pageDown;

  bool get isInsert => type == CliKeyType.insert;

  bool get isFunctionKey => type == CliKeyType.function;

  bool get isControl =>
      type == CliKeyType.ctrlC ||
      type == CliKeyType.ctrlD ||
      type == CliKeyType.ctrlR ||
      type == CliKeyType.ctrlE ||
      type == CliKeyType.ctrlGeneric;

  bool hasModifier(CliKeyModifier modifier) => modifiers.contains(modifier);

  bool get isCtrl => hasModifier(CliKeyModifier.ctrl);

  bool get isAlt => hasModifier(CliKeyModifier.alt);

  bool get isShift => hasModifier(CliKeyModifier.shift);

  bool get isCommand => hasModifier(CliKeyModifier.command);

  bool get isWindows => hasModifier(CliKeyModifier.windows);

  @override
  String toString() {
    final suffix = modifiers.isEmpty ? '' : ', modifiers: $modifiers';

    if (type == CliKeyType.character || type == CliKeyType.ctrlGeneric) {
      return 'CliKey($type, $text$suffix)';
    }

    if (type == CliKeyType.function) {
      return 'CliKey($type, F$functionNumber$suffix)';
    }

    return 'CliKey($type$suffix)';
  }

  @override
  bool operator ==(Object other) =>
      other is CliKey &&
      other.type == type &&
      other.text == text &&
      other.code == code &&
      other.functionNumber == functionNumber &&
      _setEquals(other.modifiers, modifiers);

  @override
  int get hashCode => Object.hash(
    type,
    text,
    code,
    functionNumber,
    Object.hashAllUnordered(modifiers),
  );

  static bool _setEquals(Set<CliKeyModifier> left, Set<CliKeyModifier> right) =>
      left.length == right.length && left.containsAll(right);
}
