import 'dart:convert';

import 'cli_key.dart';
import 'cli_key_modifier.dart';

/// Parses complete byte sequences into normalized [CliKey] values.
///
/// This parser understands the common ANSI/xterm modifier encoding used by
/// Unix terminals. Native Windows console events are normalized directly by
/// the Windows input backend.
abstract final class CliKeySequenceParser {
  CliKeySequenceParser._();

  static CliKey? parse(List<int> bytes) {
    if (bytes.isEmpty) return null;

    final first = bytes.first;

    switch (first) {
      case 3:
        return const CliKey.ctrlC();
      case 4:
        return const CliKey.ctrlD();
      case 5:
        return const CliKey.ctrlE();
      case 9:
        return const CliKey.tab();
      case 10:
      case 13:
        return const CliKey.enter();
      case 18:
        return const CliKey.ctrlR();
      case 27:
        return _parseEscape(bytes);
      case 32:
        return const CliKey.space();
      case 8:
      case 127:
        return const CliKey.backspace();
    }

    if (first >= 1 && first <= 26) {
      return CliKey.ctrlGeneric(String.fromCharCode(first + 96));
    }

    if (first == 0) {
      return const CliKey.unknown(code: 0);
    }

    if (bytes.length == 1 && first >= 0x20 && first < 0x7f) {
      return CliKey.character(String.fromCharCode(first));
    }

    try {
      final text = utf8.decode(bytes, allowMalformed: false);
      if (text.isEmpty) return null;
      return CliKey.character(text);
    } on FormatException {
      return CliKey.unknown(code: first);
    }
  }

  static CliKey _parseEscape(List<int> bytes) {
    if (bytes.length == 1) return const CliKey.escape();

    // CSI: ESC [ ...
    if (bytes.length >= 3 && bytes[1] == 0x5b) {
      final finalByte = bytes.last;
      final parameters = _parseCsiParameters(bytes);
      final modifiers = _modifiersFromCsi(parameters);

      switch (finalByte) {
        case 0x41:
          return CliKey.arrowUp(modifiers: modifiers);
        case 0x42:
          return CliKey.arrowDown(modifiers: modifiers);
        case 0x43:
          return CliKey.arrowRight(modifiers: modifiers);
        case 0x44:
          return CliKey.arrowLeft(modifiers: modifiers);
        case 0x48:
          return CliKey.home(modifiers: modifiers);
        case 0x46:
          return CliKey.end(modifiers: modifiers);
        case 0x7e:
          return _parseTildeSequence(bytes, modifiers: modifiers);
      }
    }

    // SS3 sequences: ESC O P/Q/R/S for F1-F4.
    if (bytes.length == 3 && bytes[1] == 0x4f) {
      switch (bytes[2]) {
        case 0x50:
          return const CliKey.functionKey(1);
        case 0x51:
          return const CliKey.functionKey(2);
        case 0x52:
          return const CliKey.functionKey(3);
        case 0x53:
          return const CliKey.functionKey(4);
      }
    }

    return CliKey.unknown(code: bytes.length > 1 ? bytes[1] : 27);
  }

  static List<int> _parseCsiParameters(List<int> bytes) {
    if (bytes.length <= 3) return const [];
    final body = String.fromCharCodes(bytes.sublist(2, bytes.length - 1));
    return body
        .split(';')
        .map(int.tryParse)
        .whereType<int>()
        .toList(growable: false);
  }

  static Set<CliKeyModifier> _modifiersFromCsi(List<int> parameters) {
    if (parameters.length < 2) return const {};

    final value = parameters.last;
    final modifiers = <CliKeyModifier>{};

    // xterm modifier parameter: 1 + bitmask
    // 2=Shift, 3=Alt, 4=Alt+Shift, 5=Ctrl, 6=Ctrl+Shift,
    // 7=Ctrl+Alt, 8=Ctrl+Alt+Shift.
    final mask = value - 1;
    if (mask < 0 || mask > 7) return const {};

    if ((mask & 1) != 0) modifiers.add(CliKeyModifier.shift);
    if ((mask & 2) != 0) modifiers.add(CliKeyModifier.alt);
    if ((mask & 4) != 0) modifiers.add(CliKeyModifier.ctrl);

    return Set.unmodifiable(modifiers);
  }

  static CliKey _parseTildeSequence(
    List<int> bytes, {
    Set<CliKeyModifier> modifiers = const {},
  }) {
    final body = String.fromCharCodes(bytes.sublist(2, bytes.length - 1));
    final number = int.tryParse(body.split(';').first);

    switch (number) {
      case 1:
      case 7:
        return CliKey.home(modifiers: modifiers);
      case 2:
        return CliKey.insert(modifiers: modifiers);
      case 3:
        return CliKey.delete(modifiers: modifiers);
      case 4:
      case 8:
        return CliKey.end(modifiers: modifiers);
      case 5:
        return CliKey.pageUp(modifiers: modifiers);
      case 6:
        return CliKey.pageDown(modifiers: modifiers);
      case 11:
        return CliKey.functionKey(1, modifiers: modifiers);
      case 12:
        return CliKey.functionKey(2, modifiers: modifiers);
      case 13:
        return CliKey.functionKey(3, modifiers: modifiers);
      case 14:
        return CliKey.functionKey(4, modifiers: modifiers);
      case 15:
        return CliKey.functionKey(5, modifiers: modifiers);
      case 17:
        return CliKey.functionKey(6, modifiers: modifiers);
      case 18:
        return CliKey.functionKey(7, modifiers: modifiers);
      case 19:
        return CliKey.functionKey(8, modifiers: modifiers);
      case 20:
        return CliKey.functionKey(9, modifiers: modifiers);
      case 21:
        return CliKey.functionKey(10, modifiers: modifiers);
      case 23:
        return CliKey.functionKey(11, modifiers: modifiers);
      case 24:
        return CliKey.functionKey(12, modifiers: modifiers);
      default:
        return CliKey.unknown(code: number);
    }
  }
}
