import 'package:clix/src/core/terminal/cli_terminal_context.dart';
import 'package:clix/src/core/terminal/cli_terminal_control.dart';
import 'package:test/test.dart';

import 'fake_cli_terminal.dart';

void main() {
  late FakeCliTerminal terminal;

  setUp(() {
    terminal = FakeCliTerminal();
    CliTerminalContext.current = terminal;
  });

  tearDown(() {
    CliTerminalContext.reset();
  });

  group('CliTerminalControl', () {
    test('clears the screen', () {
      CliTerminalControl.clearScreen();

      expect(terminal.output.output, '\x1B[2J');
    });

    test('moves cursor home', () {
      CliTerminalControl.home();

      expect(terminal.output.output, '\x1B[H');
    });

    test('clears screen and moves home', () {
      CliTerminalControl.clearAndHome();

      expect(terminal.output.output, '\x1B[2J\x1B[H');
    });

    test('moves cursor up one line by default', () {
      CliTerminalControl.moveUp();

      expect(terminal.output.output, '\x1B[1A');
    });

    test('moves cursor up by multiple lines', () {
      CliTerminalControl.moveUp(3);

      expect(terminal.output.output, '\x1B[3A');
    });

    test('ignores non-positive move up values', () {
      CliTerminalControl.moveUp(0);
      CliTerminalControl.moveUp(-1);

      expect(terminal.output.output, isEmpty);
    });

    test('moves cursor down one line by default', () {
      CliTerminalControl.moveDown();

      expect(terminal.output.output, '\x1B[1B');
    });

    test('moves cursor down by multiple lines', () {
      CliTerminalControl.moveDown(3);

      expect(terminal.output.output, '\x1B[3B');
    });

    test('ignores non-positive move down values', () {
      CliTerminalControl.moveDown(0);
      CliTerminalControl.moveDown(-1);

      expect(terminal.output.output, isEmpty);
    });

    test('moves cursor to the beginning of the current line', () {
      CliTerminalControl.moveToLineStart();

      expect(terminal.output.output, '\r');
    });

    test('clears the current line', () {
      CliTerminalControl.clearLine();

      expect(terminal.output.output, '\x1B[2K');
    });

    test('clears multiple lines and restores cursor position', () {
      CliTerminalControl.clearLines(3);

      expect(
        terminal.output.output,
        '\x1B[2K\x1B[1B'
        '\x1B[2K\x1B[1B'
        '\x1B[2K'
        '\x1B[2A',
      );
    });

    test('ignores non-positive clear line counts', () {
      CliTerminalControl.clearLines(0);
      CliTerminalControl.clearLines(-1);

      expect(terminal.output.output, isEmpty);
    });

    test('hides the cursor', () {
      CliTerminalControl.hideCursor();

      expect(terminal.output.output, '\x1B[?25l');
    });

    test('shows the cursor', () {
      CliTerminalControl.showCursor();

      expect(terminal.output.output, '\x1B[?25h');
    });
  });
}
