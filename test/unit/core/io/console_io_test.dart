import 'dart:io';

import 'package:clix/src/core/io/cli_io.dart';
import 'package:clix/src/core/io/console_io.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';
import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:test/test.dart';

import 'fake_cli_key_source.dart';

void main() {
  group('ConsoleIO', () {
    test('isTTY reflects stdin terminal state', () {
      final io = ConsoleIO();

      expect(io.isTTY, stdin.hasTerminal);
    });

    test('CliInputMode contains line and hidden modes', () {
      expect(
        CliInputMode.values,
        containsAll(<CliInputMode>[CliInputMode.line, CliInputMode.hidden]),
      );
    });

    test('reads hidden input using keyboard characters', () {
      final source = FakeCliKeySource([
        const CliKey.character('s'),
        const CliKey.character('e'),
        const CliKey.character('c'),
        const CliKey.character('r'),
        const CliKey.character('e'),
        const CliKey.character('t'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'secret');

      expect(source.readCalls, 7);
      expect(source.isStarted, isFalse);
    });

    test('supports spaces in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('h'),
        const CliKey.character('i'),
        const CliKey.space(),
        const CliKey.character('t'),
        const CliKey.character('h'),
        const CliKey.character('e'),
        const CliKey.character('r'),
        const CliKey.character('e'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'hi there');

      expect(source.isStarted, isFalse);
    });

    test('supports backspace in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('s'),
        const CliKey.character('e'),
        const CliKey.character('c'),
        const CliKey.character('r'),
        const CliKey.backspace(),
        const CliKey.character('r'),
        const CliKey.character('e'),
        const CliKey.character('t'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'secret');

      expect(source.isStarted, isFalse);
    });

    test('ignores delete in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('s'),
        const CliKey.character('e'),
        const CliKey.character('c'),
        const CliKey.delete(),
        const CliKey.character('r'),
        const CliKey.character('e'),
        const CliKey.character('t'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'secret');

      expect(source.isStarted, isFalse);
    });

    test('stops keyboard when hidden input fails', () {
      final source = FakeCliKeySource([const CliKey.character('s')]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(() => io.read(mode: CliInputMode.hidden), throwsStateError);

      expect(source.isStarted, isFalse);
    });

    test('supports Arabic text in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('م'),
        const CliKey.character('ر'),
        const CliKey.character('ح'),
        const CliKey.character('ب'),
        const CliKey.character('ا'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'مرحبا');

      expect(source.isStarted, isFalse);
    });

    test('supports Japanese text in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('こ'),
        const CliKey.character('ん'),
        const CliKey.character('に'),
        const CliKey.character('ち'),
        const CliKey.character('は'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'こんにちは');

      expect(source.isStarted, isFalse);
    });

    test('supports emoji in hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('🔐'),
        const CliKey.character('🔑'),
        const CliKey.character('✨'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), '🔐🔑✨');

      expect(source.isStarted, isFalse);
    });

    test('supports backspace with Unicode text', () {
      final source = FakeCliKeySource([
        const CliKey.character('م'),
        const CliKey.character('ر'),
        const CliKey.character('ح'),
        const CliKey.character('ب'),
        const CliKey.character('ا'),
        const CliKey.backspace(),
        const CliKey.character('ا'),
        const CliKey.enter(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(io.read(mode: CliInputMode.hidden), 'مرحبا');

      expect(source.isStarted, isFalse);
    });

    test('propagates Ctrl+C during hidden input', () {
      final source = FakeCliKeySource([
        const CliKey.character('s'),
        const CliKey.ctrlC(),
      ]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final io = ConsoleIO(keyboard: keyboard);

      expect(() => io.read(mode: CliInputMode.hidden), throwsStateError);

      expect(source.isStarted, isFalse);
    });
  });
}
