import 'dart:io';

import 'package:clix/src/core/keyboard/platform/windows/windows_key_source.dart';

void main() {
  if (!Platform.isWindows) {
    stderr.writeln('This probe only runs on Windows.');
    exitCode = 1;
    return;
  }

  final source = WindowsKeySource();

  source.start();

  stdout.writeln('========================================');
  stdout.writeln('       Clix Windows Keyboard Probe');
  stdout.writeln('========================================');
  stdout.writeln();
  stdout.writeln('Press keys to test the Windows Console API.');
  stdout.writeln();
  stdout.writeln('Test:');
  stdout.writeln('  Characters: A B C 1 2 3');
  stdout.writeln('  Space / Enter / Tab / Backspace');
  stdout.writeln('  Arrows: Up Down Left Right');
  stdout.writeln('  Home / End');
  stdout.writeln('  PageUp / PageDown');
  stdout.writeln('  Insert / Delete');
  stdout.writeln('  F1 / F12');
  stdout.writeln('  Shift + A');
  stdout.writeln('  Ctrl + C / Ctrl + R / Ctrl + E / Ctrl + D');
  stdout.writeln('  Alt + A');
  stdout.writeln();
  stdout.writeln('Press Escape to exit.');
  stdout.writeln('========================================');
  stdout.writeln();

  try {
    while (true) {
      final key = source.readKey();

      stdout.writeln(
        'type=${key.type.name}'
        ' | text=${key.text ?? '-'}'
        ' | code=${key.code ?? '-'}'
        ' | modifiers=${key.modifiers.map((m) => m.name).join(',')}',
      );

      if (key.type.name == 'escape' && key.modifiers.isEmpty) {
        break;
      }
    }
  } finally {
    source.dispose();
  }

  stdout.writeln();
  stdout.writeln('Probe finished.');
}
