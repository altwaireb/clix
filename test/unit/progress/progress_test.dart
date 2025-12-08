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

  group('Progress -', () {
    group('Progress Creation', () {
      test('should create progress with required total', () {
        final progress = Progress(total: 100, io: mockIO);

        expect(progress.total, equals(100));
      });

      test('should create progress with custom style', () {
        final progress = Progress(
          total: 50,
          style: ProgressStyle.detailed,
          io: mockIO,
        );

        expect(progress.total, equals(50));
        expect(progress.style, equals(ProgressStyle.detailed));
      });

      test('should create progress with custom width', () {
        final progress = Progress(total: 100, width: 60, io: mockIO);

        expect(progress.width, equals(60));
      });

      test('should create progress with theme', () {
        final customTheme = CliTheme(primary: CliStyle(color: CliColor.cyan));

        final progress = Progress(total: 100, theme: customTheme, io: mockIO);

        expect(progress.theme.primaryColor, equals(CliColor.cyan));
      });

      test('should use default values when not specified', () {
        final progress = Progress(total: 100, io: mockIO);

        expect(progress.width, equals(40));
        expect(progress.style, equals(ProgressStyle.basic));
        expect(progress.theme, isNotNull);
      });
    });

    group('Progress Updates', () {
      test('should update progress correctly', () {
        final progress = Progress(total: 100, io: mockIO);

        progress.update(25);
        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('25.0%'));

        progress.update(100);
        expect(mockIO.outputs.last, contains('100.0%'));
      });

      test('should increment progress correctly', () {
        final progress = Progress(total: 10, io: mockIO);

        mockIO.clearOutputs();
        progress.increment();
        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('10.0%'));

        progress.increment();
        expect(mockIO.outputs.last, contains('20.0%'));
      });

      test('should complete progress', () {
        final progress = Progress(total: 50, io: mockIO);

        progress.update(25);
        mockIO.clearOutputs();

        progress.complete();
        expect(mockIO.outputs, hasLength(2));
        expect(mockIO.outputs.first, contains('100.0%'));
        expect(mockIO.outputs.last, equals('\n'));
      });

      test('should handle updates beyond total', () {
        final progress = Progress(total: 10, io: mockIO);

        progress.update(15);
        expect(mockIO.outputs, isNotEmpty);
        // Percentage should be clamped to 100%
        expect(mockIO.outputs.last, contains('100.0%'));
      });
    });

    group('Progress Rendering', () {
      test('should render basic progress style', () {
        final progress = Progress(
          total: 10,
          width: 20,
          style: ProgressStyle.basic,
          io: mockIO,
        );

        progress.update(5);

        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('50.0%'));
        expect(mockIO.outputs.last, isNot(contains('(5/10)')));
      });

      test('should render detailed progress style', () {
        final progress = Progress(
          total: 10,
          width: 20,
          style: ProgressStyle.detailed,
          io: mockIO,
        );

        progress.update(3);

        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('30.0%'));
        expect(mockIO.outputs.last, contains('(3/10)'));
      });

      test('should render minimal progress style', () {
        final progress = Progress(
          total: 10,
          style: ProgressStyle.minimal,
          io: mockIO,
        );

        progress.update(7);

        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('70%'));
        expect(mockIO.outputs.last, isNot(contains('(7/10)')));
      });

      test('should render clean progress style', () {
        final progress = Progress(
          total: 10,
          style: ProgressStyle.clean,
          io: mockIO,
        );

        progress.update(4);

        expect(mockIO.outputs, isNotEmpty);
        // Clean style should not contain percentage text
        expect(mockIO.outputs.last, isNot(contains('%')));
      });

      test('should write carriage return for progress updates', () {
        final progress = Progress(total: 10, io: mockIO);

        progress.update(3);
        expect(mockIO.outputs.last, startsWith('\r'));
      });

      test('should write newline on completion', () {
        final progress = Progress(total: 5, io: mockIO);

        progress.complete();
        expect(mockIO.outputs, contains('\n'));
      });
    });

    group('Progress Edge Cases', () {
      test('should handle zero total gracefully', () {
        final progress = Progress(total: 0, io: mockIO);

        // Zero total should not cause crashes, even if percentage calculations are problematic
        expect(() => progress.update(1), throwsA(isA<UnsupportedError>()));
      });

      test('should handle negative updates', () {
        final progress = Progress(total: 10, io: mockIO);

        progress.update(-5);
        expect(mockIO.outputs, isNotEmpty);
        // Percentage should be clamped to 0%
        expect(mockIO.outputs.last, contains('0.0%'));
      });

      test('should handle multiple increments beyond total', () {
        final progress = Progress(total: 3, io: mockIO);

        for (int i = 0; i < 5; i++) {
          progress.increment();
        }

        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('100.0%'));
      });

      test('should handle zero width gracefully', () {
        final progress = Progress(total: 10, width: 0, io: mockIO);

        progress.update(5);
        expect(mockIO.outputs, isNotEmpty);
      });

      test('should handle very large width', () {
        final progress = Progress(total: 10, width: 200, io: mockIO);

        progress.update(5);
        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('50.0%'));
      });

      test('should handle rapid updates', () {
        final progress = Progress(total: 100, io: mockIO);

        for (int i = 0; i <= 100; i += 10) {
          progress.update(i);
        }

        expect(mockIO.outputs, isNotEmpty);
        expect(mockIO.outputs.last, contains('100.0%'));
      });
    });
  });

  group('Logger Progress Integration', () {
    test('should create progress through logger', () {
      mockIO.clearOutputs();

      final progress = logger.progress(total: 20);

      expect(progress, isA<Progress>());
      expect(progress.total, equals(20));
    });

    test('should create progress with custom style through logger', () {
      final progress = logger.progress(
        total: 15,
        style: ProgressStyle.detailed,
      );

      expect(progress, isA<Progress>());
      expect(progress.style, equals(ProgressStyle.detailed));
    });

    test('should create progress with custom width through logger', () {
      final progress = logger.progress(total: 10, width: 50);

      expect(progress, isA<Progress>());
      expect(progress.width, equals(50));
    });

    test('should inherit theme from logger', () {
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.magenta));
      final themedLogger = CliLogger(theme: customTheme, io: mockIO);

      final progress = themedLogger.progress(total: 25);

      expect(progress, isA<Progress>());
      expect(progress.theme.primaryColor, equals(CliColor.magenta));
    });

    test('should work with themed logger progress', () {
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.green));
      final themedLogger = CliLogger(theme: customTheme, io: mockIO);

      final progress = themedLogger.progress(total: 10);

      progress.update(5);
      expect(mockIO.outputs, isNotEmpty);
      expect(mockIO.outputs.last, contains('50.0%'));
    });

    test('should allow custom IO override', () {
      final customMockIO = MockIO();
      final progress = logger.progress(
        total: 20,
        io: customMockIO, // Override the logger's IO
      );

      progress.update(10);

      // Should use custom IO, not logger's IO
      expect(customMockIO.outputs, isNotEmpty);
      expect(customMockIO.outputs.last, contains('50.0%'));
      expect(mockIO.outputs, isEmpty); // Logger's IO should be unused
    });

    test('should default to logger IO when not specified', () {
      final progress = logger.progress(total: 5);

      progress.update(2);

      // Should use logger's IO by default
      expect(mockIO.outputs, isNotEmpty);
      expect(mockIO.outputs.last, contains('40.0%'));
    });
  });
}
