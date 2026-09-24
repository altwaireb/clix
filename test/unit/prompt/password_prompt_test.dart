import 'package:clix/src/core/io/cli_io.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/prompt/password_prompt.dart';
import 'package:test/test.dart';

import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('Password Prompt Tests', () {
    late MockIO mockIO;
    late CliTheme theme;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    test('should return entered password', () async {
      mockIO.addInput('secret123');

      final prompt = Password(prompt: 'Password');

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('secret123'));
    });

    test('should use defaultValue when input is empty', () async {
      mockIO.addInput('');

      final prompt = Password(prompt: 'Password', defaultValue: 'default123');

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('default123'));
    });

    test(
      'should return empty string when input is empty without defaultValue',
      () async {
        mockIO.addInput('');

        final prompt = Password(prompt: 'Password');

        final result = await prompt.run(mockIO, theme);

        expect(result, isEmpty);
      },
    );

    test('should pass the entered password to validator', () async {
      mockIO.addInput('secret123');

      String? validatedValue;

      final prompt = Password(
        prompt: 'Password',
        validator: (value) {
          validatedValue = value;
          return null;
        },
      );

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('secret123'));
      expect(validatedValue, equals('secret123'));
    });

    test('should retry when validator returns an error', () async {
      mockIO.addInputs(['short', 'long-enough-password']);

      var attempts = 0;

      final prompt = Password(
        prompt: 'Password',
        validator: (value) {
          attempts++;

          if (value.length < 8) {
            return 'Password is too short';
          }

          return null;
        },
      );

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('long-enough-password'));
      expect(attempts, equals(2));
      expect(
        mockIO.outputs.map(stripAnsi),
        contains('Password is too short\n'),
      );
    });

    test('should confirm password when confirmation is enabled', () async {
      mockIO.addInputs(['secret123', 'secret123']);

      final prompt = Password(prompt: 'Password', confirmation: true);

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('secret123'));
    });

    test('should retry when passwords do not match', () async {
      mockIO.addInputs(['secret123', 'different123', 'secret456', 'secret456']);

      final prompt = Password(prompt: 'Password', confirmation: true);

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('secret456'));
      expect(
        mockIO.outputs.map(stripAnsi),
        contains('Passwords do not match\n'),
      );
    });

    test('should use custom confirmPrompt', () async {
      mockIO.addInputs(['secret123', 'secret123']);

      final prompt = Password(
        prompt: 'Password',
        confirmation: true,
        confirmPrompt: 'Repeat password',
      );

      final result = await prompt.run(mockIO, theme);

      expect(result, equals('secret123'));
      expect(mockIO.outputs.map(stripAnsi), contains('Repeat password '));
    });

    test('should not add a colon to the prompt automatically', () async {
      mockIO.addInput('secret123');

      final prompt = Password(prompt: 'Enter password');

      await prompt.run(mockIO, theme);

      expect(mockIO.outputs.map(stripAnsi), contains('Enter password '));

      expect(
        mockIO.outputs.map(stripAnsi),
        isNot(contains('Enter password: ')),
      );
    });

    test('should preserve a colon supplied by the developer', () async {
      mockIO.addInput('secret123');

      final prompt = Password(prompt: 'Enter password:');

      await prompt.run(mockIO, theme);

      expect(mockIO.outputs.map(stripAnsi), contains('Enter password: '));
    });

    test('should read password using hidden input mode', () async {
      final io = _TrackingIO();
      io.addInput('secret123');

      final prompt = Password(prompt: 'Password');

      final result = await prompt.run(io, theme);

      expect(result, equals('secret123'));
      expect(io.lastReadMode, equals(CliInputMode.hidden));
    });
  });
}

class _TrackingIO extends MockIO {
  CliInputMode? lastReadMode;

  @override
  String read({CliInputMode mode = CliInputMode.line}) {
    lastReadMode = mode;
    return super.read(mode: mode);
  }
}

String stripAnsi(String value) {
  return value.replaceAll(RegExp(r'\x1B\[[0-9;]*[A-Za-z]'), '');
}
