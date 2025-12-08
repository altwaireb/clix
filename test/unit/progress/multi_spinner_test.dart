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

  group('MultiSpinner -', () {
    group('MultiSpinner Creation', () {
      test('should create multi-spinner with defaults', () {
        final multiSpinner = MultiSpinner();

        expect(multiSpinner, isA<MultiSpinner>());
      });

      test('should create multi-spinner with custom theme', () {
        final customTheme = CliTheme(primary: CliStyle(color: CliColor.cyan));

        final multiSpinner = MultiSpinner(theme: customTheme);

        expect(multiSpinner, isA<MultiSpinner>());
      });

      test('should create multi-spinner with custom interval', () {
        final multiSpinner = MultiSpinner(
          interval: const Duration(milliseconds: 200),
        );

        expect(multiSpinner, isA<MultiSpinner>());
      });

      test('should create multi-spinner with custom spinner type', () {
        final multiSpinner = MultiSpinner(type: SpinnerType.circle);

        expect(multiSpinner, isA<MultiSpinner>());
      });

      test('should create multi-spinner with logger', () {
        final multiSpinner = MultiSpinner(logger: logger);

        expect(multiSpinner, isA<MultiSpinner>());
      });
    });

    group('SpinnerTask Tests', () {
      test('should create task with required parameters', () {
        final task = SpinnerTask(id: 'test-task', message: 'Test message');

        expect(task.id, equals('test-task'));
        expect(task.message, equals('Test message'));
        expect(task.status, equals(TaskStatus.pending));
        expect(task.startTime, isNull);
        expect(task.endTime, isNull);
      });

      test('should create task with custom status', () {
        final task = SpinnerTask(
          id: 'running-task',
          message: 'Running task',
          status: TaskStatus.running,
        );

        expect(task.status, equals(TaskStatus.running));
      });

      test('should calculate elapsed time correctly', () {
        final task = SpinnerTask(id: 'timed-task', message: 'Timed task');

        // Task without start time should return empty elapsed
        expect(task.elapsed, equals(''));

        // Set start time
        task.startTime = DateTime.now().subtract(const Duration(seconds: 2));

        // Should return elapsed time string
        expect(task.elapsed, contains('('));
        expect(task.elapsed, contains('s)'));
      });

      test('should calculate elapsed time with end time', () {
        final now = DateTime.now();
        final task = SpinnerTask(
          id: 'completed-task',
          message: 'Completed task',
        );

        task.startTime = now.subtract(const Duration(seconds: 3));
        task.endTime = now;

        final elapsed = task.elapsed;
        expect(elapsed, contains('('));
        expect(elapsed, contains('3.'));
        expect(elapsed, contains('s)'));
      });
    });

    group('Task Management', () {
      test('should add tasks correctly', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.add('task1', 'First task'), returnsNormally);
        expect(() => multiSpinner.add('task2', 'Second task'), returnsNormally);

        multiSpinner.stop();
      });

      test('should start specific tasks', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        expect(() => multiSpinner.startTask('task1'), returnsNormally);

        multiSpinner.stop();
      });

      test('should handle starting non-existent task', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.startTask('non-existent'), returnsNormally);
      });

      test('should complete specific tasks', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        expect(() => multiSpinner.complete('task1'), returnsNormally);

        multiSpinner.stop();
      });

      test('should complete task with custom message', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        expect(
          () => multiSpinner.complete('task1', 'Custom completion'),
          returnsNormally,
        );

        multiSpinner.stop();
      });

      test('should fail specific tasks', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        expect(() => multiSpinner.fail('task1'), returnsNormally);

        multiSpinner.stop();
      });

      test('should fail task with custom message', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        expect(
          () => multiSpinner.fail('task1', 'Custom failure'),
          returnsNormally,
        );

        multiSpinner.stop();
      });

      test('should handle completing non-existent task', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.complete('non-existent'), returnsNormally);
      });

      test('should handle failing non-existent task', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.fail('non-existent'), returnsNormally);
      });
    });

    group('Bulk Operations', () {
      test('should complete all tasks at once', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        multiSpinner.add('task2', 'Second task');
        multiSpinner.add('task3', 'Third task');

        expect(() => multiSpinner.completeAll(), returnsNormally);

        multiSpinner.stop();
      });

      test('should complete all with custom final message', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        multiSpinner.add('task2', 'Second task');

        expect(
          () => multiSpinner.completeAll('All tasks finished!'),
          returnsNormally,
        );

        multiSpinner.stop();
      });

      test('should fail each task individually', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        multiSpinner.add('task2', 'Second task');
        multiSpinner.add('task3', 'Third task');

        // Fail each task individually since failAll doesn't exist
        multiSpinner.fail('task1');
        multiSpinner.fail('task2');
        multiSpinner.fail('task3');
      });

      test('should fail tasks with custom messages', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        multiSpinner.add('task2', 'Second task');

        multiSpinner.fail('task1', 'First task failed');
        multiSpinner.fail('task2', 'Second task failed');
      });

      test('should handle bulk operations on empty spinner', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.completeAll(), returnsNormally);
      });
    });

    group('Spinner Control', () {
      test('should start spinner manually', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.start(), returnsNormally);
        multiSpinner.stop();
      });

      test('should stop spinner manually', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.start();
        expect(() => multiSpinner.stop(), returnsNormally);
      });

      test('should handle multiple start attempts', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.start();
        expect(() => multiSpinner.start(), returnsNormally);
        multiSpinner.stop();
      });

      test('should handle multiple stop attempts', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.start();
        multiSpinner.stop();
        expect(() => multiSpinner.stop(), returnsNormally);
      });

      test('should auto-stop when all tasks finish', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'Only task');
        multiSpinner.complete('task1');

        // Spinner should auto-stop, subsequent operations should be safe
        expect(() => multiSpinner.stop(), returnsNormally);
      });
    });

    group('Task Status Management', () {
      test('should handle task workflow correctly', () {
        final multiSpinner = MultiSpinner();

        // Add task (starts as pending)
        multiSpinner.add('workflow-task', 'Workflow test');

        // Start task
        multiSpinner.startTask('workflow-task');

        // Complete task
        multiSpinner.complete('workflow-task', 'Workflow completed');

        multiSpinner.stop();
      });

      test('should handle mixed task statuses', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('task1', 'First task');
        multiSpinner.add('task2', 'Second task');
        multiSpinner.add('task3', 'Third task');

        multiSpinner.startTask('task1');
        multiSpinner.complete('task2');
        multiSpinner.fail('task3');

        multiSpinner.stop();
      });
    });

    group('Different Spinner Types', () {
      test('should work with all spinner types', () {
        final types = [
          SpinnerType.dots,
          SpinnerType.line,
          SpinnerType.pipe,
          SpinnerType.clock,
          SpinnerType.arrow,
          SpinnerType.triangle,
          SpinnerType.square,
          SpinnerType.circle,
        ];

        for (final type in types) {
          final multiSpinner = MultiSpinner(type: type);
          multiSpinner.add('test-task', 'Testing $type');
          expect(multiSpinner, isA<MultiSpinner>());
          multiSpinner.stop();
        }
      });
    });

    group('Edge Cases', () {
      test('should handle empty task IDs', () {
        final multiSpinner = MultiSpinner();

        expect(() => multiSpinner.add('', 'Empty ID task'), returnsNormally);
        expect(() => multiSpinner.complete(''), returnsNormally);
        multiSpinner.stop();
      });

      test('should handle empty messages', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('empty-msg', '');
        expect(() => multiSpinner.complete('empty-msg', ''), returnsNormally);
        multiSpinner.stop();
      });

      test('should handle unicode in task messages', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('unicode-task', '🚀 Loading data...');
        multiSpinner.complete('unicode-task', '✅ Data loaded successfully!');
        multiSpinner.stop();
      });

      test('should handle very long task messages', () {
        final multiSpinner = MultiSpinner();
        final longMessage =
            'This is a very long task message that might wrap around the terminal width and cause display issues but should not crash the multi-spinner';

        multiSpinner.add('long-msg', longMessage);
        multiSpinner.complete('long-msg');
        multiSpinner.stop();
      });

      test('should handle duplicate task IDs', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('duplicate', 'First message');
        multiSpinner.add('duplicate', 'Second message'); // Should overwrite

        expect(() => multiSpinner.complete('duplicate'), returnsNormally);
        multiSpinner.stop();
      });

      test('should handle very short intervals', () {
        final multiSpinner = MultiSpinner(
          interval: const Duration(milliseconds: 1),
        );

        multiSpinner.add('fast-task', 'Fast spinner task');
        multiSpinner.complete('fast-task');
      });

      test('should handle operations after completion', () {
        final multiSpinner = MultiSpinner();

        multiSpinner.add('post-complete-task', 'Test task');
        multiSpinner.complete('post-complete-task');

        // These should be safe after completion
        expect(
          () => multiSpinner.startTask('post-complete-task'),
          returnsNormally,
        );
        expect(() => multiSpinner.fail('post-complete-task'), returnsNormally);
      });
    });
  });

  group('Logger MultiSpinner Integration', () {
    test('should create multi-spinner through logger', () {
      final multiSpinner = logger.multiSpinner();

      expect(multiSpinner, isA<MultiSpinner>());
      multiSpinner.stop();
    });

    test('should inherit theme from logger', () {
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.magenta));
      final themedLogger = CliLogger(theme: customTheme, io: mockIO);

      final multiSpinner = themedLogger.multiSpinner();

      expect(multiSpinner, isA<MultiSpinner>());
      multiSpinner.stop();
    });

    test('should override theme when specified', () {
      final loggerTheme = CliTheme(primary: CliStyle(color: CliColor.green));
      final customTheme = CliTheme(primary: CliStyle(color: CliColor.cyan));
      final themedLogger = CliLogger(theme: loggerTheme, io: mockIO);

      final multiSpinner = themedLogger.multiSpinner(theme: customTheme);

      expect(multiSpinner, isA<MultiSpinner>());
      multiSpinner.stop();
    });

    test('should work with logger for task management', () {
      final multiSpinner = logger.multiSpinner();

      multiSpinner.add('logger-task1', 'First logger task');
      multiSpinner.add('logger-task2', 'Second logger task');

      multiSpinner.startTask('logger-task1');
      multiSpinner.complete('logger-task1', 'First task done');
      multiSpinner.complete('logger-task2', 'Second task done');
    });
  });
}
