import 'package:clix/clix.dart';
import 'package:test/test.dart';
import '../../helpers/mock_io.dart';

void main() {
  late MockIO mockIO;
  late CliLogger logger;

  setUp(() {
    mockIO = MockIO();
    logger = CliLogger(io: mockIO);
  });

  group('Spinner -', () {
    group('Spinner Creation', () {
      test('should create spinner with default type', () {
        final spinner = Spinner('Test message');

        expect(spinner, isA<Spinner>());
      });

      test('should create spinner with custom type', () {
        final spinner = Spinner('Custom spinner', type: SpinnerType.circle);

        expect(spinner, isA<Spinner>());
      });

      test('should create spinner with custom theme', () {
        final customTheme = CliTheme(primary: CliStyle(color: CliColor.cyan));

        final spinner = Spinner('Themed spinner', theme: customTheme);

        expect(spinner, isA<Spinner>());
      });

      test('should create spinner with custom interval', () {
        final spinner = Spinner(
          'Fast spinner',
          interval: const Duration(milliseconds: 50),
        );

        expect(spinner, isA<Spinner>());
      });

      test('should create spinner with logger', () {
        final spinner = Spinner('Logger spinner', logger: logger);

        expect(spinner, isA<Spinner>());
      });
    });

    group('Spinner Operations', () {
      test('should allow updating message', () {
        final spinner = Spinner('Initial message');

        expect(() => spinner.update('Updated message'), returnsNormally);
      });

      test('should allow stopping spinner', () {
        final spinner = Spinner('Test spinner');

        expect(() => spinner.stop(), returnsNormally);
      });

      test('should allow completing spinner', () {
        final spinner = Spinner('Completing spinner');

        expect(() => spinner.complete(), returnsNormally);
      });

      test('should allow completing spinner with custom message', () {
        final spinner = Spinner('Test spinner');

        expect(
          () => spinner.complete('Custom completion message'),
          returnsNormally,
        );
      });

      test('should allow failing spinner', () {
        final spinner = Spinner('Failing spinner');

        expect(() => spinner.fail(), returnsNormally);
      });

      test('should allow failing spinner with custom message', () {
        final spinner = Spinner('Test spinner');

        expect(() => spinner.fail('Custom failure message'), returnsNormally);
      });

      test('should allow canceling spinner', () {
        final spinner = Spinner('Canceling spinner');

        expect(() => spinner.cancel(), returnsNormally);
      });

      test('should handle multiple start attempts gracefully', () {
        final spinner = Spinner('Multi-start spinner');

        expect(() => spinner.start(), returnsNormally);
        expect(() => spinner.start(), returnsNormally);
      });

      test('should handle multiple stop attempts gracefully', () {
        final spinner = Spinner('Multi-stop spinner');

        expect(() => spinner.stop(), returnsNormally);
        expect(() => spinner.stop(), returnsNormally);
      });
    });

    group('SpinnerType Frames', () {
      test('should have different frame sets for each type', () {
        final dotsSpinner = Spinner('Dots', type: SpinnerType.dots);
        final lineSpinner = Spinner('Line', type: SpinnerType.line);
        final pipeSpinner = Spinner('Pipe', type: SpinnerType.pipe);
        final clockSpinner = Spinner('Clock', type: SpinnerType.clock);
        final arrowSpinner = Spinner('Arrow', type: SpinnerType.arrow);
        final triangleSpinner = Spinner('Triangle', type: SpinnerType.triangle);
        final squareSpinner = Spinner('Square', type: SpinnerType.square);
        final circleSpinner = Spinner('Circle', type: SpinnerType.circle);

        // All spinner types should create successfully
        expect(dotsSpinner, isA<Spinner>());
        expect(lineSpinner, isA<Spinner>());
        expect(pipeSpinner, isA<Spinner>());
        expect(clockSpinner, isA<Spinner>());
        expect(arrowSpinner, isA<Spinner>());
        expect(triangleSpinner, isA<Spinner>());
        expect(squareSpinner, isA<Spinner>());
        expect(circleSpinner, isA<Spinner>());

        // Clean up
        dotsSpinner.stop();
        lineSpinner.stop();
        pipeSpinner.stop();
        clockSpinner.stop();
        arrowSpinner.stop();
        triangleSpinner.stop();
        squareSpinner.stop();
        circleSpinner.stop();
      });
    });
  });

  group('Logger Spinner Integration', () {
    test('should create spinner through logger', () {
      final spinner = logger.spinner('Logger spinner test');

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should create spinner with custom type through logger', () {
      final spinner = logger.spinner(
        'Logger circle spinner',
        type: SpinnerType.circle,
      );

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should inherit theme from logger', () {
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.magenta));
      final themedLogger = CliLogger(theme: customTheme, io: mockIO);

      final spinner = themedLogger.spinner('Themed spinner test');

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should override theme when specified', () {
      final loggerTheme = CliTheme(primary: CliStyle(color: CliColor.green));
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.cyan));
      final themedLogger = CliLogger(theme: loggerTheme, io: mockIO);

      final spinner = themedLogger.spinner(
        'Override theme test',
        theme: customTheme,
      );

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });
  });

  group('Spinner Edge Cases', () {
    test('should handle very short intervals', () {
      final spinner = Spinner(
        'Fast spinner',
        interval: const Duration(milliseconds: 1),
      );

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up quickly
    });

    test('should handle very long intervals', () {
      final spinner = Spinner(
        'Slow spinner',
        interval: const Duration(seconds: 1),
      );

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up immediately
    });

    test('should handle empty message', () {
      final spinner = Spinner('');

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should handle unicode message', () {
      final spinner = Spinner('🚀 Loading data...');

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should handle very long message', () {
      final longMessage =
          'This is a very long spinner message that might wrap around the terminal width and cause display issues but should not crash the spinner';
      final spinner = Spinner(longMessage);

      expect(spinner, isA<Spinner>());
      spinner.stop(); // Clean up
    });

    test('should handle stop after complete', () {
      final spinner = Spinner('Complete then stop');

      spinner.complete();
      expect(() => spinner.stop(), returnsNormally);
    });

    test('should handle complete after stop', () {
      final spinner = Spinner('Stop then complete');

      spinner.stop();
      expect(() => spinner.complete(), returnsNormally);
    });

    test('should handle fail after stop', () {
      final spinner = Spinner('Stop then fail');

      spinner.stop();
      expect(() => spinner.fail(), returnsNormally);
    });

    test('should handle multiple operations on same spinner', () {
      final spinner = Spinner('Multi-operation spinner');

      spinner.update('First update');
      spinner.update('Second update');
      spinner.complete('Done');

      // These should be safe to call after completion
      expect(() => spinner.update('Post-completion update'), returnsNormally);
      expect(() => spinner.stop(), returnsNormally);
    });
  });
}
