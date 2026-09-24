import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/prompt/cli_help_prompt_position.dart';
import 'package:clix/src/prompt/multi_select_prompt.dart';
import 'package:test/test.dart';
import 'package:clix/src/core/terminal/cli_terminal_context.dart';
import '../core/terminal/fake_cli_terminal.dart';

import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('MultiSelect Prompt Tests', () {
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

    test('should expose prompt, options, defaults, and help', () {
      final options = ['Option 1', 'Option 2', 'Option 3'];

      final select = MultiSelect(
        prompt: 'Choose options',
        options: options,
        defaults: const [0, 2],
        help: false,
      );

      expect(select.prompt, equals('Choose options'));
      expect(select.options, equals(options));
      expect(select.defaults, equals([0, 2]));
      expect(select.help, isFalse);
    });

    test('should select an option with space', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should deselect a default option with space', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        defaults: const [0],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, isEmpty);
    });

    test('should select multiple options', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0, 1]));
    });

    test('should navigate up and down', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.arrowUp(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([1]));
    });

    test('should wrap from the last option to the first option', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should wrap from the first option to the last option', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowUp(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([2]));
    });

    test('should respect default selections', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        defaults: const [0, 2],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0, 2]));
    });

    test('should allow changing default selections', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        defaults: const [0],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([1]));
    });

    test('should return an empty list when nothing is selected', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, isEmpty);
    });

    test('should expose selection limits', () {
      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        minimumOptions: 1,
        maximumOptions: 2,
      );

      expect(select.minimumOptions, equals(1));
      expect(select.maximumOptions, equals(2));
    });

    test('should allow empty selection when minimumOptions is zero', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        minimumOptions: 0,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, isEmpty);
    });

    test('should require minimumOptions before confirming', () async {
      final keyboard = _createKeyboard([
        const CliKey.enter(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        minimumOptions: 1,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should enforce maximumOptions', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        maximumOptions: 2,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0, 1]));
    });

    test('should allow deselecting when maximumOptions is reached', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.space(),
        const CliKey.arrowUp(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        maximumOptions: 2,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([1]));
    });

    test('should reject a negative minimumOptions', () {
      expect(
        () => MultiSelect(
          prompt: 'Choose options',
          options: ['Option 1', 'Option 2'],
          minimumOptions: -1,
        ),
        throwsArgumentError,
      );
    });

    test('should reject a negative maximumOptions', () {
      expect(
        () => MultiSelect(
          prompt: 'Choose options',
          options: ['Option 1', 'Option 2'],
          maximumOptions: -1,
        ),
        throwsArgumentError,
      );
    });

    test('should reject minimumOptions greater than maximumOptions', () {
      expect(
        () => MultiSelect(
          prompt: 'Choose options',
          options: ['Option 1', 'Option 2', 'Option 3'],
          minimumOptions: 3,
          maximumOptions: 2,
        ),
        throwsArgumentError,
      );
    });

    test('should reject maximumOptions greater than options length', () {
      expect(
        () => MultiSelect(
          prompt: 'Choose options',
          options: ['Option 1', 'Option 2'],
          maximumOptions: 3,
        ),
        throwsArgumentError,
      );
    });

    test('should ignore unrelated keys', () async {
      final keyboard = _createKeyboard([
        const CliKey.character('x'),
        const CliKey.tab(),
        const CliKey.escape(),
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2', 'Option 3'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should start and stop the keyboard session', () async {
      final source = _FakeKeySource([const CliKey.enter()]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        keyboard: keyboard,
      );

      expect(keyboard.isStarted, isFalse);

      final result = await select.run(mockIO, theme);

      expect(result, isEmpty);
      expect(source.startCount, equals(1));
      expect(source.stopCount, equals(1));
      expect(keyboard.isStarted, isFalse);
    });

    test('should support help being disabled', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        help: false,
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should use help and top position by default', () {
      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
      );

      expect(select.help, isTrue);
      expect(select.helpPosition, equals(CliHelpPromptPosition.top));
    });

    test('should render help at the top', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        helpPosition: CliHelpPromptPosition.top,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      final outputs = mockIO.outputs;

      expect(outputs[0], contains('Choose options'));
      expect(outputs[1], contains('Navigate'));
      expect(outputs[2], contains('Option 1'));
      expect(outputs[3], contains('Option 2'));
    });

    test('should render help at the bottom', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        helpPosition: CliHelpPromptPosition.bottom,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      final outputs = mockIO.outputs;

      expect(outputs[0], contains('Choose options'));
      expect(outputs[1], contains('Option 1'));
      expect(outputs[2], contains('Option 2'));
      expect(outputs[3], contains('Navigate'));
    });

    test('should clear the bottom help line after confirmation', () async {
      final terminal = FakeCliTerminal();
      CliTerminalContext.current = terminal;

      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        helpPosition: CliHelpPromptPosition.bottom,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      expect(
        terminal.output.output,
        equals(
          '\x1B[2K'
          '\x1B[2K'
          '\x1B[2K'
          '\x1B[2K'
          '\x1B[4A'
          '\x1B[2K'
          '\x1B[2K'
          '\x1B[2K',
        ),
      );
    });

    test('should not render help when disabled', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: ['Option 1', 'Option 2'],
        help: false,
        helpPosition: CliHelpPromptPosition.bottom,
        keyboard: keyboard,
      );

      await select.run(mockIO, theme);

      expect(
        mockIO.outputs.any((output) => output.contains('Navigate')),
        isFalse,
      );
    });

    test('should support a single option', () async {
      final keyboard = _createKeyboard([
        const CliKey.space(),
        const CliKey.arrowDown(),
        const CliKey.arrowUp(),
        const CliKey.enter(),
      ]);

      final select = MultiSelect(
        prompt: 'Choose option',
        options: ['Only Option'],
        keyboard: keyboard,
      );

      final result = await select.run(mockIO, theme);

      expect(result, equals([0]));
    });

    test('should reject an empty options list', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final select = MultiSelect(
        prompt: 'Choose options',
        options: const [],
        keyboard: keyboard,
      );

      expect(() => select.run(mockIO, theme), throwsA(isA<StateError>()));
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
