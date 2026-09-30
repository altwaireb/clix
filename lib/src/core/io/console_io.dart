import 'dart:io';

import '../keyboard/cli_key.dart';
import '../keyboard/cli_keyboard.dart';
import 'cli_io.dart';

class ConsoleIO implements CliIO {
  final CliKeyboard keyboard;

  ConsoleIO({CliKeyboard? keyboard}) : keyboard = keyboard ?? CliKeyboard();

  @override
  void write(String text) => stdout.write(text);

  @override
  void writeln([String text = '']) => stdout.write('$text\r\n');

  @override
  String readLine() => stdin.readLineSync() ?? '';

  @override
  String read({CliInputMode mode = CliInputMode.line}) {
    switch (mode) {
      case CliInputMode.line:
        return readLine();
      case CliInputMode.hidden:
        return _readHidden();
    }
  }

  @override
  bool get isTTY => stdin.hasTerminal;

  String _readHidden() {
    keyboard.start();

    final characters = <String>[];

    try {
      while (true) {
        final key = keyboard.read();

        if (key.isEnter) {
          return characters.join();
        }

        if (key.isBackspace) {
          if (characters.isNotEmpty) {
            characters.removeLast();
          }
          continue;
        }

        if (key.isDelete) {
          continue;
        }

        if (key.isPrintable) {
          characters.add(_characterFor(key));
        }
      }
    } finally {
      keyboard.stop();
    }
  }

  String _characterFor(CliKey key) {
    return key.text ?? '';
  }
}
