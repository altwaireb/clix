import 'package:test/test.dart';
import 'package:clix/src/logger/logger.dart';
import 'package:clix/src/logger/log_level.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/core/formatter/basic_formatter.dart';
import 'package:clix/src/core/indentation/indent_level.dart';
import 'package:clix/src/core/icons/cli_icons.dart';
import 'package:clix/src/core/indentation/tree_symbol.dart';
import 'package:clix/src/core/style/point_style.dart';
import 'package:clix/src/core/style/color.dart';
import 'package:clix/src/core/style/padding.dart';
import 'package:clix/src/core/style/line_spacing.dart';
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('CliLogger Tests', () {
    late MockIO mockIO;
    late CliTheme theme;
    late CliLogger logger;

    setUp(() {
      mockIO = TestUtils.createMockIO();
      theme = TestUtils.createTestTheme();
      logger = CliLogger(
        io: mockIO,
        theme: theme,
        formatter: BasicFormatter(),
        minimumLevel: LogLevel.plain,
        showTimestamps: false,
      );
    });

    tearDown(() {
      TestUtils.resetMockIO(mockIO);
    });

    group('Constructor Tests', () {
      test('should create logger with default parameters', () {
        final defaultLogger = CliLogger.defaults();

        expect(defaultLogger.minimumLevel, equals(LogLevel.plain));
        expect(defaultLogger.showTimestamps, isFalse);
        expect(defaultLogger.io, isNotNull);
        expect(defaultLogger.theme, isNotNull);
        expect(defaultLogger.formatter, isNotNull);
      });

      test('should create logger with factory constructor', () {
        final factoryLogger = CliLogger.create(
          minimumLevel: LogLevel.info,
          showTimestamps: true,
        );

        expect(factoryLogger.minimumLevel, equals(LogLevel.info));
        expect(factoryLogger.showTimestamps, isTrue);
      });

      test('should create logger with custom parameters', () {
        final customLogger = CliLogger(
          io: mockIO,
          theme: theme,
          minimumLevel: LogLevel.debug,
          showTimestamps: true,
        );

        expect(customLogger.minimumLevel, equals(LogLevel.debug));
        expect(customLogger.showTimestamps, isTrue);
        expect(customLogger.io, equals(mockIO));
        expect(customLogger.theme, equals(theme));
      });
    });

    group('Basic Logging Methods', () {
      test('should log plain message', () {
        logger.plain('Test plain message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test plain message'));
      });

      test('should log debug message when level allows', () {
        logger.minimumLevel = LogLevel.debug;
        logger.debug('Test debug message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test debug message'));
      });

      test('should not log debug message when level is higher', () {
        logger.minimumLevel = LogLevel.info;
        logger.debug('Test debug message');

        expect(mockIO.outputs, isEmpty);
      });

      test('should log info message', () {
        logger.info('Test info message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test info message'));
      });

      test('should log warning message', () {
        logger.warn('Test warning message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test warning message'));
      });

      test('should log error message', () {
        logger.error('Test error message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test error message'));
      });

      test('should log success message', () {
        logger.success('Test success message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Test success message'));
      });
    });

    group('Color Methods', () {
      test('should log primary color message', () {
        logger.primary('Primary message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Primary message'));
      });

      test('should log secondary color message', () {
        logger.secondary('Secondary message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Secondary message'));
      });

      test('should log white color message', () {
        logger.white('White message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('White message'));
      });

      test('should log red color message', () {
        logger.red('Red message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Red message'));
      });

      test('should log green color message', () {
        logger.green('Green message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Green message'));
      });

      test('should log blue color message', () {
        logger.blue('Blue message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Blue message'));
      });

      test('should log yellow color message', () {
        logger.yellow('Yellow message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Yellow message'));
      });

      test('should log cyan color message', () {
        logger.cyan('Cyan message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Cyan message'));
      });
    });

    group('Background Color Methods', () {
      test('should log message with red background', () {
        logger.onRed('Message on red background');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Message on red background'));
      });

      test('should log message with green background', () {
        logger.onGreen('Message on green background');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Message on green background'));
      });

      test('should log message with custom background', () {
        logger.onBackground(
          'Custom background message',
          textColor: CliColor.white,
          backgroundColor: CliColor.blue,
        );

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Custom background message'));
      });
    });

    group('Icon Methods', () {
      test('should log message with predefined icon', () {
        logger.withIcon(
          'Message with icon',
          icon: CliIcons.success,
          color: CliColor.green,
        );

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Message with icon'));
      });

      test('should log message with custom icon', () {
        logger.withIconCustom(
          'Message with custom icon',
          icon: '🎯',
          color: CliColor.blue,
        );

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('🎯'));
        expect(mockIO.outputs.first, contains('Message with custom icon'));
      });

      test('should log success message with icon', () {
        logger.successIcon('Success with icon');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Success with icon'));
      });

      test('should log error message with icon', () {
        logger.errorIcon('Error with icon');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Error with icon'));
      });

      test('should log warning message with icon', () {
        logger.warnIcon('Warning with icon');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Warning with icon'));
      });

      test('should log info message with icon', () {
        logger.infoIcon('Info with icon');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Info with icon'));
      });

      test('should log idea message with icon', () {
        logger.ideaIcon('Idea with icon');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Idea with icon'));
      });
    });

    group('Tree Structure Methods', () {
      test('should log message with tree structure', () {
        logger.tree('Root message', symbol: TreeSymbol.root);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Root message'));
      });

      test('should log message with tree and icon', () {
        logger.treeWithIcon(
          'Tree with icon',
          icon: CliIcons.info,
          symbol: TreeSymbol.level1,
        );

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Tree with icon'));
      });

      test('should log message with tree and point', () {
        logger.treePoint(
          'Tree point message',
          style: PointStyle.bullet,
          symbol: TreeSymbol.level2,
        );

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Tree point message'));
      });
    });

    group('Point Style Methods', () {
      test('should log message with bullet point', () {
        logger.point('Bullet point message', style: PointStyle.bullet);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Bullet point message'));
      });

      test('should log message with arrow point', () {
        logger.point('Arrow point message', style: PointStyle.arrow);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Arrow point message'));
      });

      test('should log message with dash point', () {
        logger.point('Dash point message', style: PointStyle.dash);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Dash point message'));
      });
    });

    group('Indentation Tests', () {
      test('should log message with level 1 indentation', () {
        logger.plain('Indented message', indent: IndentLevel.level1);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Indented message'));
        // Check that output contains indentation spacing
        expect(mockIO.outputs.first, contains('  Indented message'));
      });

      test('should log message with level 2 indentation', () {
        logger.info('Level 2 indented', indent: IndentLevel.level2);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Level 2 indented'));
        // Check for deeper indentation
        expect(mockIO.outputs.first, contains('    Level 2 indented'));
      });
    });

    group('Prefix and Timestamp Tests', () {
      test('should show prefix when enabled', () {
        logger.showTimestamps = false;
        logger.info('Message with prefix', showPrefix: true);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('[INFO]'));
        expect(mockIO.outputs.first, contains('Message with prefix'));
      });

      test('should show timestamp when enabled', () {
        logger.showTimestamps = true;
        logger.plain('Message with timestamp');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Message with timestamp'));
        // Check for timestamp format (starts with [)
        expect(mockIO.outputs.first.contains('['), isTrue);
      });

      test('should show both prefix and timestamp', () {
        logger.showTimestamps = true;
        logger.error('Message with both', showPrefix: true);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('[ERROR]'));
        expect(mockIO.outputs.first, contains('Message with both'));
      });
    });

    group('Multiple Lines Methods', () {
      test('should log multiple lines with default spacing', () {
        final messages = ['Line 1', 'Line 2', 'Line 3'];
        logger.lines(messages);

        expect(mockIO.outputs, hasLength(3));
        expect(mockIO.outputs[0], contains('Line 1'));
        expect(mockIO.outputs[1], contains('Line 2'));
        expect(mockIO.outputs[2], contains('Line 3'));
      });

      test('should log multiple lines with spacing', () {
        final messages = ['Line 1', 'Line 2'];
        logger.lines(messages, lineSpacing: LineSpacing.single);

        // Should have messages + spacing lines
        expect(mockIO.outputs.length, greaterThan(2));
      });

      test('should log multiple lines with specific level', () {
        final messages = ['Info 1', 'Info 2'];
        logger.lines(messages, level: LogLevel.info);

        expect(mockIO.outputs, hasLength(2));
        expect(mockIO.outputs[0], contains('Info 1'));
        expect(mockIO.outputs[1], contains('Info 2'));
      });
    });

    group('New Line Method', () {
      test('should print single new line', () {
        logger.newLine();

        expect(mockIO.outputs, hasLength(1));
        // writeln adds \n, so we expect empty string with newline
        expect(mockIO.outputs.first.trim(), equals(''));
      });

      test('should print multiple new lines', () {
        logger.newLine(3);

        expect(mockIO.outputs, hasLength(3));
        // Check that all outputs are empty (after trimming newlines)
        expect(mockIO.outputs.every((line) => line.trim() == ''), isTrue);
      });
    });

    group('Result and Output Methods', () {
      test('should log result message', () {
        logger.result('Result message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Result message'));
      });

      test('should log output message (alias for result)', () {
        logger.output('Output message');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Output message'));
      });
    });

    group('Prompt Result Methods', () {
      test('should display prompt result with question and answer', () {
        logger.promptResult('What is your name?', 'John');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('What is your name?'));
        expect(mockIO.outputs.first, contains('John'));
        expect(mockIO.outputs.first, contains('✓'));
      });

      test('should display multi-prompt result', () {
        logger.multiPromptResult('Select options:', [
          'Option 1',
          'Option 2',
          'Option 3',
        ]);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Select options:'));
        expect(mockIO.outputs.first, contains('Option 1, Option 2, Option 3'));
        expect(mockIO.outputs.first, contains('✓'));
      });

      test('should display multi-prompt result with custom separator', () {
        logger.multiPromptResult('Select items:', [
          'Item A',
          'Item B',
        ], separator: ' | ');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Item A | Item B'));
      });
    });

    group('Log Level Filtering', () {
      test('should respect minimum log level for debug', () {
        logger.minimumLevel = LogLevel.info;

        logger.debug('Should not appear');
        logger.info('Should appear');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Should appear'));
      });

      test('should respect minimum log level for warning', () {
        logger.minimumLevel = LogLevel.error;

        logger.warn('Should not appear');
        logger.error('Should appear');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Should appear'));
      });

      test('should log all levels when minimum is plain', () {
        logger.minimumLevel = LogLevel.plain;

        logger.debug('Debug message');
        logger.info('Info message');
        logger.warn('Warning message');
        logger.error('Error message');
        logger.success('Success message');
        logger.plain('Plain message');

        expect(mockIO.outputs, hasLength(6));
      });
    });

    group('Padding Tests', () {
      test('should apply padding to background message', () {
        logger.onRed('Padded message', padding: Padding.small);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Padded message'));
      });

      test('should apply different padding levels', () {
        logger.onBlue('Large padded message', padding: Padding.large);

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Large padded message'));
      });
    });

    group('Enhanced Background Tests', () {
      test('should log with dark red background', () {
        logger.onDarkRed('Dark red background');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Dark red background'));
      });

      test('should log with deep red background', () {
        logger.onDeepRed('Deep red background');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Deep red background'));
      });

      test('should log with maroon background', () {
        logger.onMaroon('Maroon background');

        expect(mockIO.outputs, hasLength(1));
        expect(mockIO.outputs.first, contains('Maroon background'));
      });
    });
  });
}
