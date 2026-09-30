import 'cli_terminal_context.dart';

/// Low-level terminal state and ANSI controls used by interactive Clix APIs.
abstract final class CliTerminalControl {
  CliTerminalControl._();

  /// Clears the entire terminal screen.
  static void clearScreen() {
    CliTerminalContext.output.write('\x1B[2J');
  }

  /// Moves the cursor to the home position.
  static void home() {
    CliTerminalContext.output.write('\x1B[H');
  }

  /// Clears the screen and moves the cursor to the home position.
  static void clearAndHome() {
    final output = CliTerminalContext.output;
    output.write('\x1B[2J');
    output.write('\x1B[H');
  }

  /// Moves the cursor up by [lines].
  static void moveUp([int lines = 1]) {
    if (lines <= 0) return;

    CliTerminalContext.output.write('\x1B[${lines}A');
  }

  /// Moves the cursor down by [lines].
  static void moveDown([int lines = 1]) {
    if (lines <= 0) return;

    CliTerminalContext.output.write('\x1B[${lines}B');
  }

  /// Moves the cursor to the beginning of the current line.
  static void moveToLineStart() {
    CliTerminalContext.output.write('\r');
  }

  /// Clears the current terminal line.
  static void clearLine() {
    CliTerminalContext.output.write('\x1B[2K');
  }

  /// Clears [lines] and restores the cursor to its original position.
  static void clearLines(int lines) {
    if (lines <= 0) return;

    final output = CliTerminalContext.output;

    for (var index = 0; index < lines; index++) {
      output.write('\x1B[2K');

      if (index < lines - 1) {
        output.write('\x1B[1B');
      }
    }

    if (lines > 1) {
      output.write('\x1B[${lines - 1}A');
    }
  }

  /// Hides the terminal cursor.
  static void hideCursor() {
    CliTerminalContext.output.write('\x1B[?25l');
  }

  /// Shows the terminal cursor.
  static void showCursor() {
    CliTerminalContext.output.write('\x1B[?25h');
  }
}
