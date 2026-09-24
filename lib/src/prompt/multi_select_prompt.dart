import 'prompt.dart';
import 'cli_help_prompt_position.dart';
import '../core/icons/cli_marks.dart';
import '../core/io/cli_io.dart';
import '../core/keyboard/cli_keyboard.dart';
import '../core/style/theme.dart';
import '../core/terminal/cli_terminal_control.dart';

class MultiSelect extends Prompt<List<int>> {
  final String prompt;
  final List<String> options;
  final List<int> defaults;
  final bool help;
  final CliHelpPromptPosition helpPosition;
  final int minimumOptions;
  final int? maximumOptions;
  final CliKeyboard keyboard;

  MultiSelect({
    required this.prompt,
    required this.options,
    this.defaults = const [],
    this.help = true,
    this.helpPosition = CliHelpPromptPosition.top,
    this.minimumOptions = 0,
    this.maximumOptions,
    CliKeyboard? keyboard,
  }) : keyboard = keyboard ?? CliKeyboard() {
    if (minimumOptions < 0) {
      throw ArgumentError.value(
        minimumOptions,
        'minimumOptions',
        'must be greater than or equal to 0.',
      );
    }

    if (maximumOptions != null && maximumOptions! < 0) {
      throw ArgumentError.value(
        maximumOptions,
        'maximumOptions',
        'must be greater than or equal to 0.',
      );
    }

    if (maximumOptions != null && minimumOptions > maximumOptions!) {
      throw ArgumentError(
        'minimumOptions cannot be greater than maximumOptions.',
      );
    }

    if (maximumOptions != null && maximumOptions! > options.length) {
      throw ArgumentError.value(
        maximumOptions,
        'maximumOptions',
        'cannot be greater than the number of options.',
      );
    }
  }

  @override
  Future<List<int>> run(CliIO io, CliTheme theme) async {
    if (options.isEmpty) {
      throw StateError('MultiSelect requires at least one option.');
    }

    var currentIndex = 0;

    final selected = List<bool>.generate(
      options.length,
      (i) => defaults.contains(i),
    );

    keyboard.start();

    try {
      _renderOptions(io, theme, currentIndex, selected, redraw: false);

      while (true) {
        final key = keyboard.read();

        if (key.isArrowUp) {
          currentIndex = (currentIndex - 1 + options.length) % options.length;
          _renderOptions(io, theme, currentIndex, selected, redraw: true);
        } else if (key.isArrowDown) {
          currentIndex = (currentIndex + 1) % options.length;
          _renderOptions(io, theme, currentIndex, selected, redraw: true);
        } else if (key.isSpace) {
          final isSelected = selected[currentIndex];

          if (isSelected || !_hasReachedMaximum(selected)) {
            selected[currentIndex] = !isSelected;
            _renderOptions(io, theme, currentIndex, selected, redraw: true);
          }
        } else if (key.isEnter) {
          if (_hasReachedMinimum(selected)) {
            final result = <int>[];

            for (var i = 0; i < options.length; i++) {
              if (selected[i]) {
                result.add(i);
              }
            }

            _renderConfirmation(io, theme, selected);

            return result;
          }
        }
      }
    } finally {
      keyboard.stop();
    }
  }

  bool _hasReachedMinimum(List<bool> selected) {
    return _selectedCount(selected) >= minimumOptions;
  }

  bool _hasReachedMaximum(List<bool> selected) {
    if (maximumOptions == null) {
      return false;
    }

    return _selectedCount(selected) >= maximumOptions!;
  }

  int _selectedCount(List<bool> selected) {
    return selected.where((value) => value).length;
  }

  void _renderOptions(
    CliIO io,
    CliTheme theme,
    int currentIndex,
    List<bool> selected, {
    required bool redraw,
  }) {
    final linesToMove = _linesToMove;

    if (redraw) {
      CliTerminalControl.moveUp(linesToMove);
    }

    CliTerminalControl.clearLine();
    io.writeln(theme.primary(prompt));

    if (_shouldRenderHelpAtTop) {
      _renderHelp(io, theme);
    }

    for (var i = 0; i < options.length; i++) {
      CliTerminalControl.clearLine();

      final isCurrent = i == currentIndex;
      final isSelected = selected[i];

      final pointer = isCurrent ? CliMarks.pointer.symbol : ' ';
      final selectionMark = isSelected
          ? CliMarks.selectedCircle.symbol
          : CliMarks.circle.symbol;

      final option = isCurrent
          ? theme.primary(options[i])
          : theme.plain(options[i]);

      io.writeln('  $pointer $selectionMark $option');
    }

    if (_shouldRenderHelpAtBottom) {
      _renderHelp(io, theme);
    }
  }

  void _renderHelp(CliIO io, CliTheme theme) {
    CliTerminalControl.clearLine();
    io.writeln(
      theme.plain(
        '${CliMarks.arrowUp.symbol}'
        '${CliMarks.arrowDown.symbol} Navigate '
        '${CliMarks.bullet.symbol} '
        '${CliMarks.space.symbol} Space to select  '
        '${CliMarks.bullet.symbol} '
        '${CliMarks.enter.symbol} Enter to confirm  ',
      ),
    );
  }

  void _renderConfirmation(CliIO io, CliTheme theme, List<bool> selected) {
    CliTerminalControl.moveUp(_linesToMove);

    CliTerminalControl.clearLine();
    io.writeln(theme.primary(prompt));

    for (var i = 0; i < options.length; i++) {
      CliTerminalControl.clearLine();

      final isSelected = selected[i];

      if (isSelected) {
        final mark = theme.success(CliMarks.check.symbol);
        final text = theme.primary(options[i]);

        io.writeln('  $mark $text');
      } else {
        io.writeln('    ${theme.gray(options[i])}');
      }
    }
  }

  int get _linesToMove {
    return options.length + (help ? 2 : 1);
  }

  bool get _shouldRenderHelpAtTop {
    return help && helpPosition == CliHelpPromptPosition.top;
  }

  bool get _shouldRenderHelpAtBottom {
    return help && helpPosition == CliHelpPromptPosition.bottom;
  }
}
