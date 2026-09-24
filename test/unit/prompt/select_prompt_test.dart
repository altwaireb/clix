import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/prompt/cli_help_prompt_position.dart';
import 'package:clix/src/prompt/select_prompt.dart';
import 'package:test/test.dart';
import 'package:clix/src/core/terminal/cli_terminal_context.dart';
import '../core/terminal/fake_cli_terminal.dart';

import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Select Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
      CliTerminalContext.current = FakeCliTerminal();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
      CliTerminalContext.reset();
    });

    test('should expose prompt, options, and default index', () {
      final options = ['Option 1', 'Option 2', 'Option 3'];

      final select = Select(
        prompt: 'Choose option',
        options: options,
        defaultIndex: 1,
      );

      expect(select.prompt, equals('Choose option'));
      expect(select.options, equals(options));
      expect(select.defaultIndex, equals(1));
    });

    test('should enable help by default', () {
      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2'],
      );

      expect(select.help, isTrue);
      expect(select.helpPosition, equals(CliHelpPromptPosition.bottom));
    });

    test('should use bottom help position by default', () {
      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2'],
        help: true,
      );

      expect(select.helpPosition, equals(CliHelpPromptPosition.bottom));
    });

    test('should render help at the bottom when enabled', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2'],
        help: true,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      expect(mockIO.outputs.length, equals(7));
      expect(mockIO.outputs[0], contains('Choose option'));
      expect(mockIO.outputs[1], contains('Option 1'));
      expect(mockIO.outputs[2], contains('Option 2'));
      expect(mockIO.outputs[3], equals('\n'));
      expect(mockIO.outputs[4], contains('Navigate'));
    });

    test('should render help at the top when requested', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2'],
        help: true,
        helpPosition: CliHelpPromptPosition.top,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      expect(mockIO.outputs[0], contains('Choose option'));
      expect(mockIO.outputs[1], contains('Navigate'));
      expect(mockIO.outputs[2], equals('\n'));
      expect(mockIO.outputs[3], contains('Option 1'));
      expect(mockIO.outputs[4], contains('Option 2'));
    });

    test(
      'should remove help from the rendered output after confirmation',
      () async {
        final keyboard = _createKeyboard([const CliKey.enter()]);

        final select = Select(
          prompt: 'Choose option',
          options: ['Option 1', 'Option 2'],
          help: true,
          keyboard: keyboard,
        );

        await select.run(mockIO, theme);

        final finalRender = mockIO.outputs.sublist(5);

        expect(
          finalRender.every((output) => !output.contains('Navigate')),
          isTrue,
        );
        expect(finalRender[0], contains('Option 1'));
        expect(finalRender[1], contains('Option 2'));
      },
    );

    test(
      'should render help at the top when a help position is provided',
      () async {
        final keyboard = _createKeyboard([const CliKey.enter()]);

        final select = Select(
          prompt: 'Choose option',
          options: ['Option 1', 'Option 2'],
          helpPosition: CliHelpPromptPosition.top,
          keyboard: keyboard,
        );

        await select.run(mockIO, theme);

        expect(mockIO.outputs.length, equals(7));

        final helpIndex = mockIO.outputs.indexWhere(
          (output) => output.contains('Navigate'),
        );
        final optionIndex = mockIO.outputs.indexWhere(
          (output) => output.contains('Option 1'),
        );

        expect(helpIndex, isNot(-1));
        expect(optionIndex, isNot(-1));
        expect(helpIndex, lessThan(optionIndex));
      },
    );

    test('should use the first option by default', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(0));
    });

    test('should return the selected option after moving down', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should return the selected option after moving up', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.arrowUp(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should wrap from the last option to the first option', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(0));
    });

    test('should wrap from the first option to the last option', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowUp(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(2));
    });

    test('should respect the default index', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        defaultIndex: 1,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should clamp a negative default index to zero', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        defaultIndex: -10,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(0));
    });

    test(
      'should clamp an oversized default index to the last option',
      () async {
        final keyboard = _createKeyboard([const CliKey.enter()]);

        final select = Select(
          prompt: 'Choose option',
          options: ['Option 1', 'Option 2', 'Option 3'],
          defaultIndex: 10,
          keyboard: keyboard,
        );

        final result = await select.run(mockIO, theme);

        expect(result, equals(2));
      },
    );

    test('should ignore unrelated keys', () async {
      final keyboard = _createKeyboard([
        const CliKey.character('x'),
        const CliKey.space(),
        const CliKey.tab(),
        const CliKey.arrowDown(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should start and stop the keyboard session', () async {
      final source = _FakeKeySource([const CliKey.enter()]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final select = Select(
        prompt: 'Choose option',
        options: ['Option 1', 'Option 2'],
        keyboard: keyboard,
      );

      expect(keyboard.isStarted, isFalse);

      final result = await select.run(mockIO, theme);

      expect(result, equals(0));
      expect(source.startCount, equals(1));
      expect(source.stopCount, equals(1));
      expect(keyboard.isStarted, isFalse);
    });

    test('should reject an empty options list', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = Select(
        prompt: 'Choose option',
        options: const [],
        keyboard: keyboard,
      );

      expect(() => select.run(mockIO, theme), throwsA(isA<StateError>()));
    });

    test('should support a single option', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.arrowUp(),
        const CliKey.enter(),
      ]);

      final select = Select(
        prompt: 'Choose option',
        options: ['Only Option'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals(0));
    });
  });
}

CliKeyboard _createKeyboard(List<CliKey> keys) {
  return CliKeyboard(reader: CliKeyReader(source: _FakeKeySource(keys)));
}

final class _FakeKeySource implements CliKeySource {
  final List<CliKey> _keys;

  int _index = 0;
  bool _started = false;
  bool _disposed = false;

  int startCount = 0;
  int stopCount = 0;

  _FakeKeySource(Iterable<CliKey> keys) : _keys = List.of(keys);

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_disposed) {
      throw StateError('Fake key source has been disposed.');
    }

    _started = true;
    startCount++;
  }

  @override
  CliKey readKey() {
    if (_disposed) {
      throw StateError('Fake key source has been disposed.');
    }

    if (!_started) {
      throw StateError('Fake key source has not been started.');
    }

    if (_index >= _keys.length) {
      throw StateError('No more fake keys are available.');
    }

    return _keys[_index++];
  }

  @override
  void stop() {
    if (_disposed) {
      return;
    }

    _started = false;
    stopCount++;
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    stop();
    _disposed = true;
  }
}
