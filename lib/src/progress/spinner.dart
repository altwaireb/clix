/// Spinner - Animated loading indicators for indeterminate tasks
library;

import 'dart:async';

import '../core/context/cli_context.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';
import '../core/icons/cli_marks.dart';
import 'enums/spinner_type.dart';

/// **Spinner Class - Animated loading indicator**
///
/// Provides animated visual feedback for long-running operations where
/// completion time is unknown or variable.
class Spinner {
  /// **Animation Type** - Visual style of the spinner animation
  final SpinnerType _type;

  /// **Animation Interval** - Time between animation frames
  final Duration _interval;

  /// **Theme** - Color scheme for spinner styling
  final CliTheme _theme;

  /// **IO Interface** - Output operations for spinner display
  final CliIO _io;

  /// **Animation Timer** - Controls the spinning animation
  Timer? _timer;

  /// **Frame Index** - Current position in animation sequence
  int _frameIndex = 0;

  /// **Start Time** - When spinner started (for elapsed time)
  DateTime? _startTime;

  /// **Active State** - Whether spinner is currently running
  bool _isActive = false;

  /// **Current Message** - Text displayed with spinner
  String _currentMessage;

  /// **Constructor** - Create spinner with message and options
  ///
  /// ```dart
  /// // Basic spinner
  /// final spinner = Spinner('Loading...');
  ///
  /// // Custom spinner
  /// final spinner = Spinner(
  ///   'Processing data...',
  ///   type: SpinnerType.arrow,
  ///   theme: myTheme,
  ///   io: myIO,
  /// );
  /// ```
  Spinner(
    String message, {
    SpinnerType type = SpinnerType.dots,
    CliTheme? theme,
    CliIO? io,
    Duration interval = const Duration(milliseconds: 100),
  }) : _type = type,
       _theme = theme ?? CliContext.theme,
       _io = io ?? CliContext.io,
       _interval = interval,
       _currentMessage = message {
    start();
  }

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

  /// Start spinner display
  void start() {
    if (_isActive) return;

    _isActive = true;
    _startTime = DateTime.now();
    _frameIndex = 0;

    _io.write('\u001b[?25l');

    _showFrame();

    _timer = Timer.periodic(_interval, (timer) => _showFrame());
  }

  /// Update spinner message
  void update(String message) {
    _currentMessage = message;
  }

  /// Complete spinner successfully
  void complete([String? message]) {
    if (!_isActive) return;

    stop();

    final successMessage = message ?? _currentMessage;
    final elapsed = _formatElapsed();
    final checkmark = _theme.success(CliMarks.check.symbol);

    _io.write('${_clearLine()}\r');
    _io.writeln('$checkmark $successMessage $elapsed');
  }

  /// Complete spinner with failure
  void fail([String? message]) {
    if (!_isActive) return;

    stop();

    final failMessage = message ?? _currentMessage;
    final cross = _theme.error(CliMarks.cross.symbol);

    _io.write('${_clearLine()}\r');
    _io.writeln('$cross $failMessage');
  }

  /// Cancel spinner and hide line
  void cancel() {
    if (!_isActive) return;

    stop();
    _io.write('${_clearLine()}\r');
  }

  /// Stop spinner
  void stop() {
    if (!_isActive) return;

    _timer?.cancel();
    _timer = null;
    _isActive = false;

    _io.write('\u001b[?25h');

    _cleanup();
  }

  /// Display current frame
  void _showFrame() {
    if (!_isActive) return;

    final frame = _frames[_frameIndex];
    final elapsed = _formatElapsed();

    _io.write('\r${_clearLine()}');
    _io.write('\r${_theme.primary(frame)} $_currentMessage $elapsed');

    _frameIndex = (_frameIndex + 1) % _frames.length;
  }

  /// Format elapsed time
  String _formatElapsed() {
    if (_startTime == null) return '';

    final elapsed = DateTime.now().difference(_startTime!);
    final seconds = elapsed.inMilliseconds / 1000;

    return _theme.gray('(${seconds.toStringAsFixed(1)}s)');
  }

  /// Clear current line
  String _clearLine() {
    return '\u001b[2K';
  }

  /// Cleanup resources
  void _cleanup() {}
}
