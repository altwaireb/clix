import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_reader.dart';
import 'package:clix/src/core/keyboard/cli_keyboard.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/prompt/cli_help_prompt_position.dart';
import 'package:clix/src/prompt/search_prompt.dart';
import 'package:clix/src/core/terminal/cli_terminal_context.dart';
import '../core/terminal/fake_cli_terminal.dart';
import 'package:test/test.dart';

import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Search Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;
    late List<String> options;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = CliTheme.defaultTheme();
      options = ['flutter', 'react', 'vue', 'angular', 'svelte'];

      CliTerminalContext.current = FakeCliTerminal();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
      CliTerminalContext.reset();
    });

    test('should initialize with correct properties', () {
      final search = Search(prompt: 'Choose framework', options: options);

      expect(search.prompt, equals('Choose framework'));
      expect(search.options, equals(options));
      expect(search.minQueryLength, equals(1));
      expect(search.maxResults, equals(10));
      expect(search.defaultIndex, isNull);
      expect(search.help, isTrue);
      expect(search.helpPosition, equals(CliHelpPromptPosition.bottom));
    });

    test('should use custom configuration', () {
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        minQueryLength: 2,
        maxResults: 5,
        defaultIndex: 2,
      );

      expect(search.minQueryLength, equals(2));
      expect(search.maxResults, equals(5));
      expect(search.defaultIndex, equals(2));
    });

    test('should use custom help configuration', () {
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        help: false,
        helpPosition: CliHelpPromptPosition.top,
      );

      expect(search.help, isFalse);
      expect(search.helpPosition, equals(CliHelpPromptPosition.top));
    });

    test('should render help at the bottom by default', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework',
        options: options,
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      await search.run(mockIO, theme);

      final output = TestUtils.getAllOutputs(mockIO);

      expect(
        output,
        contains('↑↓ Navigate • ↵ Enter Select • ⇥ Tab Search Again'),
      );
    });

    test('should render help at the top', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework',
        options: options,
        helpPosition: CliHelpPromptPosition.top,
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      await search.run(mockIO, theme);

      final output = TestUtils.getAllOutputs(mockIO);

      final helpIndex = output.indexOf(
        '↑↓ Navigate • ↵ Enter Select • ⇥ Tab Search Again',
      );
      final resultIndex = output.indexOf('flutter');

      expect(helpIndex, isNot(-1));
      expect(resultIndex, isNot(-1));
      expect(helpIndex, lessThan(resultIndex));
    });

    test('should not render help when disabled', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework',
        options: options,
        help: false,
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      await search.run(mockIO, theme);

      final output = TestUtils.getAllOutputs(mockIO);

      expect(
        output,
        isNot(contains('↑↓ Navigate • ↵ Enter Select • ⇥ Tab Search Again')),
      );
    });

    test('should remove help after confirmation', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework',
        options: options,
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      await search.run(mockIO, theme);

      final output = TestUtils.getAllOutputs(mockIO);

      final confirmationIndex = output.lastIndexOf('✓');
      final helpIndex = output.lastIndexOf(
        '↑↓ Navigate • ↵ Enter Select • ⇥ Tab Search Again',
      );

      expect(confirmationIndex, isNot(-1));
      expect(helpIndex, isNot(-1));
      expect(helpIndex, lessThan(confirmationIndex));
    });

    test('should handle string list options', () {
      final search = Search(prompt: 'Choose framework', options: options);

      expect(search.options, isA<List<String>>());
    });

    test('should handle function as options provider', () {
      List<String> searchFunction(String query) {
        return options.where((option) => option.contains(query)).toList();
      }

      final search = Search(
        prompt: 'Choose framework',
        options: searchFunction,
      );

      expect(search.options, isA<Function>());
    });

    test('should expose validator', () {
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        validator: (value) {
          if (value.length < 2) {
            return 'Value too short';
          }

          return null;
        },
      );

      expect(search.validator, isNotNull);
    });

    test('should handle empty options list', () {
      final search = Search(
        prompt: 'Choose framework',
        options: const <String>[],
      );

      expect(search.options, isEmpty);
    });

    test('should limit max results', () {
      final manyOptions = List.generate(20, (index) => 'Option $index');

      final search = Search(
        prompt: 'Choose option',
        options: manyOptions,
        maxResults: 5,
      );

      expect(search.maxResults, equals(5));
    });

    test('should handle minimum query length requirement', () {
      final search = Search(
        prompt: 'Choose framework',
        options: options,
        minQueryLength: 3,
      );

      expect(search.minQueryLength, equals(3));
    });

    test('should return the selected index for a single result', () async {
      final keyboard = _createKeyboard([
        const CliKey.enter(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter'],
        keyboard: keyboard,
      );

      mockIO.addInput('flut');

      final result = await search.run(mockIO, theme);

      expect(result, equals(0));
    });

    test('should navigate down and select the next result', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowDown(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react', 'vue'],
        keyboard: keyboard,
      );

      mockIO.addInput('r');

      final result = await search.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should navigate up and wrap to the last result', () async {
      final keyboard = _createKeyboard([
        const CliKey.arrowUp(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['react', 'react native', 'react router'],
        keyboard: keyboard,
      );

      mockIO.addInput('react');

      final result = await search.run(mockIO, theme);

      expect(result, equals(2));
    });

    test('should return to search when Tab is pressed', () async {
      final keyboard = _createKeyboard([
        const CliKey.tab(),
        const CliKey.enter(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react', 'vue'],
        keyboard: keyboard,
      );

      mockIO.addInputs(['r', 'vue']);

      final result = await search.run(mockIO, theme);

      expect(result, equals(2));
    });

    test('should use default index for the initial selection', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react', 'vue'],
        defaultIndex: 1,
        keyboard: keyboard,
      );

      mockIO.addInput('r');

      final result = await search.run(mockIO, theme);

      expect(result, equals(1));
    });

    test('should apply maxResults to list search results', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: [
          'react',
          'react native',
          'react router',
          'react query',
          'react hook form',
        ],
        maxResults: 3,
        keyboard: keyboard,
      );

      mockIO.addInput('react');

      final result = await search.run(mockIO, theme);

      expect(result, equals(0));
    });

    test('should reject a selection when validator returns an error', () async {
      final keyboard = _createKeyboard([
        const CliKey.enter(),
        const CliKey.enter(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react'],
        validator: (value) {
          if (value == 'flutter') {
            return 'Flutter is not allowed';
          }

          return null;
        },
        keyboard: keyboard,
      );

      mockIO.addInputs(['f', 'rea']);

      final result = await search.run(mockIO, theme);

      expect(result, equals(1));
      expect(mockIO.outputs.join(), contains('Flutter is not allowed'));
    });

    test('should accept a selection when validator passes', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react'],
        validator: (_) => null,
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      final result = await search.run(mockIO, theme);

      expect(result, equals(0));
    });

    test('should start and stop the keyboard session', () async {
      final source = _FakeKeySource([const CliKey.enter()]);

      final keyboard = CliKeyboard(reader: CliKeyReader(source: source));

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter'],
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      expect(keyboard.isStarted, isFalse);

      final result = await search.run(mockIO, theme);

      expect(result, equals(0));
      expect(source.startCount, equals(1));
      expect(source.stopCount, equals(1));
      expect(keyboard.isStarted, isFalse);
    });

    test(
      'should display the confirmed selection in the results list',
      () async {
        final keyboard = _createKeyboard([const CliKey.enter()]);

        final search = Search(
          prompt: 'Choose framework: ',
          options: ['flutter', 'react'],
          keyboard: keyboard,
        );

        mockIO.addInput('f');

        await search.run(mockIO, theme);

        final output = mockIO.outputs.join();

        expect(output, contains('✓'));
        expect(output, contains('flutter'));
      },
    );

    test('should preserve the developer-provided prompt', () async {
      final keyboard = _createKeyboard([const CliKey.enter()]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter'],
        keyboard: keyboard,
      );

      mockIO.addInput('f');

      await search.run(mockIO, theme);

      expect(mockIO.outputs.first, equals(theme.primary('Choose framework: ')));
    });

    test('should handle no results and allow another search', () async {
      final keyboard = _createKeyboard([
        const CliKey.enter(),
        const CliKey.enter(),
      ]);

      final search = Search(
        prompt: 'Choose framework: ',
        options: ['flutter', 'react'],
        keyboard: keyboard,
      );

      mockIO.addInputs(['xyz', 'f']);

      final result = await search.run(mockIO, theme);

      expect(result, equals(0));
      expect(mockIO.outputs.join(), contains('No results found'));
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
