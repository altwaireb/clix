import 'dart:async';

import '../core/context/cli_context.dart';
import '../core/icons/cli_icons.dart';
import '../core/icons/cli_marks.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';
import 'enums/spinner_type.dart';
import 'enums/task_status.dart';

/// Individual task in MultiSpinner
class SpinnerTask {
  final String id;
  String message;
  TaskStatus status;
  DateTime? startTime;
  DateTime? endTime;

  SpinnerTask({
    required this.id,
    required this.message,
    this.status = TaskStatus.pending,
  });

  /// Get elapsed time for this task
  String get elapsed {
    if (startTime == null) return '';
    final end = endTime ?? DateTime.now();
    final duration = end.difference(startTime!);
    final seconds = duration.inMilliseconds / 1000;
    return '(${seconds.toStringAsFixed(1)}s)';
  }
}

/// MultiSpinner for managing multiple concurrent tasks
class MultiSpinner {
  final CliIO _io;
  final Duration _interval;
  final SpinnerType _type;
  final CliTheme _theme;

  final Map<String, SpinnerTask> _tasks = {};
  Timer? _timer;
  int _frameIndex = 0;
  bool _isActive = false;

  MultiSpinner({
    CliTheme? theme,
    CliIO? io,
    Duration interval = const Duration(milliseconds: 100),
    SpinnerType type = SpinnerType.dots,
  }) : _theme = theme ?? CliContext.theme,
       _io = io ?? CliContext.io,
       _interval = interval,
       _type = type;

  /// Get animated symbol frames
  List<String> get _frames {
    switch (_type) {
      case SpinnerType.dots:
        return ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
      case SpinnerType.line:
        return ['-', '\\', '|', '/'];
      case SpinnerType.pipe:
        return ['┤', '┘', '┴', '└', '├', '┌', '┬', '┐'];
      case SpinnerType.clock:
        return [
          '🕛',
          '🕧',
          '🕐',
          '🕜',
          '🕑',
          '🕝',
          '🕒',
          '🕞',
          '🕓',
          '🕟',
          '🕔',
          '🕠',
        ];
      case SpinnerType.arrow:
        return ['←', '↖', '↑', '↗', '→', '↘', '↓', '↙'];
      case SpinnerType.triangle:
        return ['◢', '◣', '◤', '◥'];
      case SpinnerType.square:
        return ['■', '□', '▪', '▫'];
      case SpinnerType.circle:
        return ['◐', '◓', '◑', '◒'];
    }
  }

  /// Add a new task
  void add(String id, String message) {
    _tasks[id] = SpinnerTask(id: id, message: message);

    if (!_isActive) {
      start();
    }

    _render();
  }

  /// Start a specific task
  void startTask(String id) {
    final task = _tasks[id];
    if (task == null) return;

    task.status = TaskStatus.running;
    task.startTime = DateTime.now();
    _render();
  }

  /// Complete a specific task
  void complete(String id, [String? message]) {
    final task = _tasks[id];
    if (task == null) return;

    task.status = TaskStatus.completed;
    task.endTime = DateTime.now();
    if (message != null) task.message = message;

    _render();

    // Stop spinner if all tasks are done
    if (_allTasksFinished()) {
      stop();
    }
  }

  /// Fail a specific task
  void fail(String id, [String? message]) {
    final task = _tasks[id];
    if (task == null) return;

    task.status = TaskStatus.failed;
    task.endTime = DateTime.now();
    if (message != null) task.message = message;

    _render();

    // Stop spinner if all tasks are done
    if (_allTasksFinished()) {
      stop();
    }
  }

  /// Complete all remaining tasks at once
  void completeAll([
    String? finalMessage,
    bool withIcon = true,
    CliIcons icon = CliIcons.rocket,
  ]) {
    final pendingTasks = _tasks.values
        .where(
          (task) =>
              task.status == TaskStatus.pending ||
              task.status == TaskStatus.running,
        )
        .toList();

    // Complete all pending/running tasks
    for (final task in pendingTasks) {
      task.status = TaskStatus.completed;
      task.endTime = DateTime.now();
      task.startTime ??= DateTime.now();
    }

    // Do one final render to show all tasks as completed
    _renderFinalState();

    stop();

    // Show final message if provided
    if (finalMessage != null) {
      _io.write('\n');

      if (withIcon) {
        final styledIcon = _theme.success(icon.symbol);
        _io.writeln('$styledIcon $finalMessage');
      } else {
        final checkmark = _theme.success(CliMarks.check.symbol);
        _io.writeln('$checkmark $finalMessage');
      }
    }
  }

  /// Update message for a specific task
  void updateMessage(String id, String message) {
    final task = _tasks[id];
    if (task == null) return;

    task.message = message;
    _render();
  }

  /// Start the spinner animation
  void start() {
    if (_isActive) return;

    _isActive = true;
    _frameIndex = 0;

    // Hide cursor
    _io.write('\u001b[?25l');

    _timer = Timer.periodic(_interval, (timer) => _render());
  }

  /// Stop the spinner
  void stop() {
    if (!_isActive) return;

    _timer?.cancel();
    _timer = null;
    _isActive = false;

    // Show cursor
    _io.write('\u001b[?25h');
  }

  /// Render current state
  void _render() {
    if (_tasks.isEmpty) return;

    // Move cursor up to beginning of our block
    final lineCount = _tasks.length;
    if (lineCount > 1) {
      _io.write('\u001b[${lineCount - 1}A');
    }

    // Render each task
    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks.values.elementAt(i);
      _renderTask(task);

      if (i < _tasks.length - 1) {
        _io.write('\n');
      }
    }

    _frameIndex = (_frameIndex + 1) % _frames.length;
  }

  /// Render final state showing all tasks completed
  void _renderFinalState() {
    if (_tasks.isEmpty) return;

    // Move cursor up to beginning of our block
    final lineCount = _tasks.length;
    if (lineCount > 1) {
      _io.write('\u001b[${lineCount - 1}A');
    }

    // Render each task (all should be completed now)
    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks.values.elementAt(i);
      _renderTask(task);

      if (i < _tasks.length - 1) {
        _io.write('\n');
      }
    }
  }

  /// Render individual task
  void _renderTask(SpinnerTask task) {
    _io.write('\r\u001b[2K');

    String styledIcon;

    switch (task.status) {
      case TaskStatus.pending:
        styledIcon = _theme.gray('⏳');
        break;

      case TaskStatus.running:
        styledIcon = _theme.primary(_frames[_frameIndex]);
        break;

      case TaskStatus.completed:
        styledIcon = _theme.success(CliMarks.check.symbol);
        break;

      case TaskStatus.failed:
        styledIcon = _theme.error(CliMarks.cross.symbol);
        break;
    }

    final elapsed = task.elapsed.isNotEmpty
        ? ' ${_theme.gray(task.elapsed)}'
        : '';

    _io.write('$styledIcon ${task.message}$elapsed');
  }

  /// Check if all tasks are finished
  bool _allTasksFinished() {
    return _tasks.values.every(
      (task) =>
          task.status == TaskStatus.completed ||
          task.status == TaskStatus.failed,
    );
  }
}
