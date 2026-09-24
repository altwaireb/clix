import 'package:clix/src/args/cli_option.dart';
import 'package:test/test.dart';

void main() {
  group('CliOption', () {
    test('creates a flag option', () {
      final option = newCliOption(
        'verbose',
        'v',
        'Enable verbose output.',
        null,
        null,
        null,
        false,
        null,
        CliOptionType.flag,
      );

      expect(option.name, equals('verbose'));
      expect(option.abbr, equals('v'));
      expect(option.help, equals('Enable verbose output.'));
      expect(option.type, equals(CliOptionType.flag));
      expect(option.isFlag, isTrue);
      expect(option.isSingle, isFalse);
      expect(option.isMultiple, isFalse);
    });

    test('creates a single-value option', () {
      final option = newCliOption(
        'output',
        'o',
        'Output file.',
        'path',
        null,
        null,
        null,
        null,
        CliOptionType.single,
      );

      expect(option.name, equals('output'));
      expect(option.abbr, equals('o'));
      expect(option.valueHelp, equals('path'));
      expect(option.type, equals(CliOptionType.single));
      expect(option.isFlag, isFalse);
      expect(option.isSingle, isTrue);
      expect(option.isMultiple, isFalse);
    });

    test('creates a multiple-value option', () {
      final option = newCliOption(
        'tag',
        't',
        'Tags.',
        'tag',
        null,
        null,
        null,
        null,
        CliOptionType.multiple,
      );

      expect(option.type, equals(CliOptionType.multiple));
      expect(option.isFlag, isFalse);
      expect(option.isSingle, isFalse);
      expect(option.isMultiple, isTrue);
      expect(option.splitCommas, isTrue);
    });

    test('stores all option properties', () {
      void callback(Object? value) {}

      final option = newCliOption(
        'output',
        'o',
        'Output file.',
        'path',
        ['file', 'stdout'],
        {'file': 'Write to a file', 'stdout': 'Write to stdout'},
        'stdout',
        callback,
        CliOptionType.single,
        mandatory: true,
        hide: true,
        aliases: ['out', 'destination'],
      );

      expect(option.name, equals('output'));
      expect(option.abbr, equals('o'));
      expect(option.help, equals('Output file.'));
      expect(option.valueHelp, equals('path'));
      expect(option.allowed, equals(['file', 'stdout']));
      expect(
        option.allowedHelp,
        equals({'file': 'Write to a file', 'stdout': 'Write to stdout'}),
      );
      expect(option.defaultsTo, equals('stdout'));
      expect(option.callback, same(callback));
      expect(option.type, equals(CliOptionType.single));
      expect(option.mandatory, isTrue);
      expect(option.hide, isTrue);
      expect(option.aliases, equals(['out', 'destination']));
    });

    test('defaults splitCommas to true for multiple options', () {
      final option = newCliOption(
        'tag',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.multiple,
      );

      expect(option.splitCommas, isTrue);
    });

    test('defaults splitCommas to false for non-multiple options', () {
      final single = newCliOption(
        'output',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.single,
      );

      final flag = newCliOption(
        'verbose',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.flag,
      );

      expect(single.splitCommas, isFalse);
      expect(flag.splitCommas, isFalse);
    });

    test('accepts an explicit splitCommas value', () {
      final option = newCliOption(
        'tag',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.multiple,
        splitCommas: false,
      );

      expect(option.splitCommas, isFalse);
    });

    test('stores negatable and hideNegatedUsage', () {
      final option = newCliOption(
        'verbose',
        'v',
        null,
        null,
        null,
        null,
        false,
        null,
        CliOptionType.flag,
        negatable: true,
        hideNegatedUsage: true,
      );

      expect(option.negatable, isTrue);
      expect(option.hideNegatedUsage, isTrue);
    });

    test('allowed values are unmodifiable', () {
      final option = newCliOption(
        'format',
        null,
        null,
        null,
        ['json', 'yaml'],
        null,
        null,
        null,
        CliOptionType.single,
      );

      expect(() => option.allowed!.add('xml'), throwsUnsupportedError);
    });

    test('allowed help is unmodifiable', () {
      final option = newCliOption(
        'format',
        null,
        null,
        null,
        ['json'],
        {'json': 'JSON format'},
        null,
        null,
        CliOptionType.single,
      );

      expect(
        () => option.allowedHelp!['json'] = 'Changed',
        throwsUnsupportedError,
      );
    });

    test('aliases are stored as provided', () {
      final option = newCliOption(
        'output',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.single,
        aliases: ['out', 'dest'],
      );

      expect(option.aliases, equals(['out', 'dest']));
    });

    test('allows null abbreviation', () {
      final option = newCliOption(
        'verbose',
        null,
        null,
        null,
        null,
        null,
        false,
        null,
        CliOptionType.flag,
      );

      expect(option.abbr, isNull);
    });

    test('rejects an empty name', () {
      expect(
        () => newCliOption(
          '',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names starting with a hyphen', () {
      expect(
        () => newCliOption(
          '-verbose',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing spaces', () {
      expect(
        () => newCliOption(
          'verbose output',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing tabs', () {
      expect(
        () => newCliOption(
          'verbose\toutput',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing newlines', () {
      expect(
        () => newCliOption(
          'verbose\noutput',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing quotes', () {
      expect(
        () => newCliOption(
          'verbose"output',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing backslashes', () {
      expect(
        () => newCliOption(
          r'verbose\output',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects names containing slashes', () {
      expect(
        () => newCliOption(
          'verbose/output',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects an abbreviation longer than one character', () {
      expect(
        () => newCliOption(
          'verbose',
          'vv',
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a hyphen abbreviation', () {
      expect(
        () => newCliOption(
          'verbose',
          '-',
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('rejects an abbreviation containing invalid characters', () {
      expect(
        () => newCliOption(
          'verbose',
          ' ',
          null,
          null,
          null,
          null,
          null,
          null,
          CliOptionType.flag,
        ),
        throwsArgumentError,
      );
    });

    test('returns the provided value from valueOrDefault', () {
      final option = newCliOption(
        'output',
        null,
        null,
        null,
        null,
        null,
        'default.txt',
        null,
        CliOptionType.single,
      );

      expect(option.valueOrDefault('custom.txt'), equals('custom.txt'));
    });

    test('returns the default value for a single option', () {
      final option = newCliOption(
        'output',
        null,
        null,
        null,
        null,
        null,
        'default.txt',
        null,
        CliOptionType.single,
      );

      expect(option.valueOrDefault(null), equals('default.txt'));
    });

    test('returns null when a single option has no default', () {
      final option = newCliOption(
        'output',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.single,
      );

      expect(option.valueOrDefault(null), isNull);
    });

    test('returns an empty list for a multiple option without a default', () {
      final option = newCliOption(
        'tag',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        CliOptionType.multiple,
      );

      expect(option.valueOrDefault(null), equals(<String>[]));
    });

    test('returns the default list for a multiple option', () {
      final option = newCliOption(
        'tag',
        null,
        null,
        null,
        null,
        null,
        ['one', 'two'],
        null,
        CliOptionType.multiple,
      );

      expect(option.valueOrDefault(null), equals(['one', 'two']));
    });
  });

  group('CliOptionType', () {
    test('has the expected flag name', () {
      expect(CliOptionType.flag.name, equals('CliOptionType.flag'));
    });

    test('has the expected single name', () {
      expect(CliOptionType.single.name, equals('CliOptionType.single'));
    });

    test('has the expected multiple name', () {
      expect(CliOptionType.multiple.name, equals('CliOptionType.multiple'));
    });

    test('has distinct option type instances', () {
      expect(CliOptionType.flag, isNot(same(CliOptionType.single)));
      expect(CliOptionType.single, isNot(same(CliOptionType.multiple)));
      expect(CliOptionType.flag, isNot(same(CliOptionType.multiple)));
    });
  });
}
