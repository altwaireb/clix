import 'prompt.dart';
import 'cli_help_prompt_position.dart';
import '../core/icons/cli_marks.dart';
import '../core/io/cli_io.dart';
import '../core/keyboard/cli_keyboard.dart';
import '../core/style/theme.dart';
import '../core/terminal/cli_terminal_control.dart';

class Select extends Prompt<int> {
  final String prompt;
  final List<String> options;
  final int defaultIndex;
  final bool help;
  final CliHelpPromptPosition helpPosition;
  final CliKeyboard keyboard;

  Select({
    required this.prompt,
    required this.options,
    this.defaultIndex = 0,
    this.help = true,
    this.helpPosition = CliHelpPromptPosition.bottom,
    CliKeyboard? keyboard,
  }) : keyboard = keyboard ?? CliKeyboard();

  @override
  Future<int> run(CliIO io, CliTheme theme) async {
    if (options.isEmpty) {
      throw StateError('Select requires at least one option.');
    }

    var selectedIndex = defaultIndex.clamp(0, options.length - 1);

    CliTerminalControl.clearLine();
    io.writeln(theme.primary(prompt));

    _renderOptions(io, theme, selectedIndex, confirmed: false);

    keyboard.start();

    try {
      while (true) {
        final key = keyboard.read();

        if (key.isArrowUp) {
          selectedIndex = (selectedIndex - 1 + options.length) % options.length;

          _renderOptions(
            io,
            theme,
            selectedIndex,
            confirmed: false,
            redraw: true,
          );
        } else if (key.isArrowDown) {
          selectedIndex = (selectedIndex + 1) % options.length;

          _renderOptions(
            io,
            theme,
            selectedIndex,
            confirmed: false,
            redraw: true,
          );
        } else if (key.isEnter) {
          _renderOptions(
            io,
            theme,
            selectedIndex,
            confirmed: true,
            redraw: true,
          );

          return selectedIndex;
        }
      }
    } finally {
      keyboard.stop();
    }
  }

  void _renderOptions(
    CliIO io,
    CliTheme theme,
    int selectedIndex, {
    required bool confirmed,
    bool redraw = false,
  }) {
    if (redraw) {
      final lines = _renderedLines(confirmed: false);

      CliTerminalControl.moveUp(lines);
      CliTerminalControl.clearLines(lines);
    }

    if (_shouldRenderHelpAtTop(confirmed)) {
      _renderHelp(io, theme);

      CliTerminalControl.clearLine();
      io.writeln('');
    }

    for (var i = 0; i < options.length; i++) {
      CliTerminalControl.clearLine();

      final isSelected = i == selectedIndex;
      final option = options[i];

      if (confirmed) {
        if (isSelected) {
          final mark = theme.success(CliMarks.check.symbol);
          final text = theme.primary(option);

          io.writeln('  $mark $text');
        } else {
          io.writeln('    ${theme.gray(option)}');
        }
      } else if (isSelected) {
        final mark = theme.primary(CliMarks.pointer.symbol);
        final text = theme.primary(option);

        io.writeln('  $mark $text');
      } else {
        io.writeln('    ${theme.plain(option)}');
      }
    }

    if (_shouldRenderHelpAtBottom(confirmed)) {
      CliTerminalControl.clearLine();
      io.writeln('');

      _renderHelp(io, theme);
    }
  }

  int _renderedLines({required bool confirmed}) {
    if (confirmed || !help) {
      return options.length;
    }

    return options.length + 2;
  }

  bool _shouldRenderHelpAtTop(bool confirmed) {
    return help && !confirmed && helpPosition == CliHelpPromptPosition.top;
  }

  bool _shouldRenderHelpAtBottom(bool confirmed) {
    return help && !confirmed && helpPosition == CliHelpPromptPosition.bottom;
  }

  void _renderHelp(CliIO io, CliTheme theme) {
    CliTerminalControl.clearLine();

    io.writeln(
      theme.plain(
        '${CliMarks.arrowUp.symbol}'
        '${CliMarks.arrowDown.symbol} Navigate '
        '${CliMarks.bullet.symbol} '
        '${CliMarks.enter.symbol} Enter to confirm',
      ),
    );
  }
}
