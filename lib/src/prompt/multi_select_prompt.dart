import 'dart:io';
import 'prompt.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';

class MultiSelect extends Prompt<List<int>> {
  final String prompt;
  final List<String> options;
  final List<int> defaults;
  final bool help;

  MultiSelect({
    required this.prompt,
    required this.options,
    this.defaults = const [],
    this.help = true,
  });

  @override
  Future<List<int>> run(CliIO io, CliTheme theme) async {
    io.writeln(theme.primary(prompt));
    if (help) {
      io.writeln(
        theme.primary(
          '(Use ↑/↓ to navigate, Space to select, Enter to confirm)',
        ),
      );
    }

    int currentIndex = 0;
    final selected = List<bool>.generate(
      options.length,
      (i) => defaults.contains(i),
    );

    // Enable raw mode for capturing arrow keys
    stdin.echoMode = false;
    stdin.lineMode = false;

    try {
      while (true) {
        _renderOptions(io, theme, currentIndex, selected);

        final input = stdin.readByteSync();

        if (input == 27) {
          // Escape sequence (arrow keys)
          final next1 = stdin.readByteSync();
          final next2 = stdin.readByteSync();

          if (next1 == 91) {
            if (next2 == 65) {
              // Up arrow
              currentIndex =
                  (currentIndex - 1 + options.length) % options.length;
            } else if (next2 == 66) {
              // Down arrow
              currentIndex = (currentIndex + 1) % options.length;
            }
          }
        } else if (input == 32) {
          // Space - toggle selection
          selected[currentIndex] = !selected[currentIndex];
        } else if (input == 10 || input == 13) {
          // Enter - confirm selection
          _clearOptions(io);
          final result = <int>[];
          for (int i = 0; i < options.length; i++) {
            if (selected[i]) {
              result.add(i); // Add index instead of value
            }
          }
          _showConfirmation(io, theme, result);
          return result;
        }
      }
    } finally {
      stdin.echoMode = true;
      stdin.lineMode = true;
    }
  }

  void _renderOptions(
    CliIO io,
    CliTheme theme,
    int currentIndex,
    List<bool> selected,
  ) {
    // Calculate number of lines to move up (message + help line if shown)
    final linesToMove = help ? options.length + 2 : options.length + 1;

    // Move cursor up to redraw options and message lines
    if (currentIndex > 0 || options.isNotEmpty) {
      io.write('\x1B[${linesToMove}A');
    }

    // Clear and reprint the message
    io.write('\x1B[2K');
    io.writeln(theme.primary(prompt));

    if (help) {
      io.write('\x1B[2K');
      io.writeln(
        theme.primary(
          '(Use ↑/↓ to navigate, Space to select, Enter to confirm)',
        ),
      );
    }

    // Clear and render options
    for (int i = 0; i < options.length; i++) {
      // Clear the line first
      io.write('\x1B[2K');

      final isCurrent = i == currentIndex;
      final isSelected = selected[i];
      final pointer = isCurrent ? '❯' : ' ';
      final radioButton = isSelected
          ? '●'
          : '○'; // Radio buttons instead of checkboxes
      final option = options[i];

      if (isCurrent) {
        // Current line highlighting
        if (isSelected) {
          // Selected item with primary color for radio button
          io.writeln(
            '  ${theme.primary(pointer)} ${theme.primary(radioButton)} ${theme.primary(option)}',
          );
        } else {
          // Unselected current item
          io.writeln(
            '  ${theme.primary(pointer)} $radioButton ${theme.primary(option)}',
          );
        }
      } else {
        // Non-current lines
        if (isSelected) {
          // Selected item with primary color for radio button
          io.writeln('  $pointer ${theme.primary(radioButton)} $option');
        } else {
          // Regular unselected item
          io.writeln('  $pointer $radioButton $option');
        }
      }
    }
  }

  void _clearOptions(CliIO io) {
    // Clear options + message lines (1 line for message + optional help line)
    final linesToClear = help ? options.length + 2 : options.length + 1;
    for (int i = 0; i < linesToClear; i++) {
      io.write('\x1B[2K\x1B[1A');
    }
    // Don't add extra line - we'll replace the question line
  }

  void _showConfirmation(CliIO io, CliTheme theme, List<int> selectedIndices) {
    // Show confirmation replacing the original question line
    final checkmark = theme.success('✓');
    final question = theme.primary(prompt);

    // Handle empty selection
    if (selectedIndices.isEmpty) {
      final answerText = theme.plain('None selected');
      io.writeln('$checkmark $question $answerText');
    } else {
      // Convert indices back to option text for display
      final selectedOptions = selectedIndices.map((i) => options[i]).toList();
      final answers = selectedOptions.join(', ');
      final answerText = theme.plain(answers); // Using plain for white color
      io.writeln('$checkmark $question $answerText');
    }
  }
}
