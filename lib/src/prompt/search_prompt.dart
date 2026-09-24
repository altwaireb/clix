import 'prompt.dart';
import 'cli_help_prompt_position.dart';
import '../core/io/cli_io.dart';
import '../core/keyboard/cli_keyboard.dart';
import '../core/style/theme.dart';
import '../core/icons/cli_marks.dart';
import '../core/terminal/cli_terminal_control.dart';

class Search extends Prompt<int> {
  final String prompt;
  final dynamic options; // List<String> or Function
  final String? Function(String)? validator;
  final int minQueryLength;
  final int maxResults;
  final int? defaultIndex;
  final bool help;
  final CliHelpPromptPosition helpPosition;
  final CliKeyboard keyboard;

  Search({
    required this.prompt,
    required this.options,
    this.validator,
    this.minQueryLength = 1,
    this.maxResults = 10,
    this.defaultIndex,
    this.help = true,
    this.helpPosition = CliHelpPromptPosition.bottom,
    CliKeyboard? keyboard,
  }) : keyboard = keyboard ?? CliKeyboard();

  @override
  Future<int> run(CliIO io, CliTheme theme) async {
    while (true) {
      // Phase 1: Get search query
      final query = await _getSearchQuery(io, theme);

      if (query.isEmpty) continue;

      // Skip loading, go directly to results
      final results = await _getSearchResults(query);

      if (results.isEmpty) {
        await _showNoResults(io, theme);
        continue;
      }

      // Phase 4: Show results with Select-style interface
      final selectedIndex = await _showSelectResults(io, theme, results);

      if (selectedIndex == -1) {
        // User chose to search again.
        continue;
      }

      // Validate selection
      final selectedValue = results[selectedIndex];

      if (validator != null) {
        final error = validator!(selectedValue);

        if (error != null) {
          await _showValidationError(io, theme, error);
          continue;
        }
      }

      // Show confirmation and return original index
      final originalIndex = _findOriginalIndex(selectedValue, results);

      _showConfirmation(io, theme, selectedValue, results.length);

      return originalIndex;
    }
  }

  Future<String> _getSearchQuery(CliIO io, CliTheme theme) async {
    // Simple prompt like Input.
    io.write(theme.primary(prompt));

    final query = io.readLine().trim();

    return query;
  }

  Future<List<String>> _getSearchResults(String query) async {
    if (query.length < minQueryLength) {
      return [];
    }

    if (options is List<String>) {
      // Static list filtering.
      final list = options as List<String>;

      return list
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .take(maxResults)
          .toList();
    }

    if (options is Function) {
      // Dynamic function.
      try {
        final result = options(query);

        if (result is Future) {
          final asyncResult = await result;

          return List<String>.from(asyncResult).take(maxResults).toList();
        }

        return List<String>.from(result).take(maxResults).toList();
      } catch (_) {
        return [];
      }
    }

    return [];
  }

  Future<int> _showSelectResults(
    CliIO io,
    CliTheme theme,
    List<String> results,
  ) async {
    var selectedIndex = defaultIndex != null && defaultIndex! < results.length
        ? defaultIndex!
        : 0;

    // Show initial options directly below the search query.
    _renderSearchOptions(io, theme, results, selectedIndex, redraw: false);

    keyboard.start();

    try {
      while (true) {
        final key = keyboard.read();

        if (key.isArrowUp) {
          selectedIndex = (selectedIndex - 1 + results.length) % results.length;

          _renderSearchOptions(io, theme, results, selectedIndex, redraw: true);
        } else if (key.isArrowDown) {
          selectedIndex = (selectedIndex + 1) % results.length;

          _renderSearchOptions(io, theme, results, selectedIndex, redraw: true);
        } else if (key.isEnter) {
          return selectedIndex;
        } else if (key.isTab) {
          return -1;
        }
      }
    } finally {
      keyboard.stop();
    }
  }

  void _renderSearchOptions(
    CliIO io,
    CliTheme theme,
    List<String> results,
    int selectedIndex, {
    bool redraw = false,
    bool confirmed = false,
  }) {
    if (redraw) {
      final linesToMove = help ? results.length + 2 : results.length;

      CliTerminalControl.moveUp(linesToMove);
    }

    if (!confirmed && _shouldRenderHelpAtTop) {
      _renderHelp(io, theme);

      CliTerminalControl.clearLine();
      io.writeln('');
    }

    for (var i = 0; i < results.length; i++) {
      CliTerminalControl.clearLine();

      final isSelected = i == selectedIndex;
      final option = results[i];

      if (confirmed) {
        if (isSelected) {
          final mark = theme.success(CliMarks.check.symbol);
          final text = theme.primary(option);

          io.writeln('  $mark $text');
        } else {
          io.writeln('    ${theme.gray(option)}');
        }

        continue;
      }

      if (isSelected) {
        final mark = theme.primary(CliMarks.pointer.symbol);
        final text = theme.primary(option);

        io.writeln('  $mark $text');
      } else {
        io.writeln('    ${theme.plain(option)}');
      }
    }

    if (confirmed) {
      return;
    }

    if (_shouldRenderHelpAtBottom) {
      CliTerminalControl.clearLine();
      io.writeln('');

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
        '${CliMarks.enter.symbol} Enter Select '
        '${CliMarks.bullet.symbol} '
        '${CliMarks.tab.symbol} Tab Search Again',
      ),
    );
  }

  bool get _shouldRenderHelpAtTop {
    return help && helpPosition == CliHelpPromptPosition.top;
  }

  bool get _shouldRenderHelpAtBottom {
    return help && helpPosition == CliHelpPromptPosition.bottom;
  }

  Future<void> _showNoResults(CliIO io, CliTheme theme) async {
    io.writeln('');

    io.writeln(
      '${theme.error(CliMarks.cross.symbol)} '
      'No results found. Try a different search term.',
    );

    io.writeln(theme.plain('Press Enter to search again...'));

    await _waitForEnter();
  }

  Future<void> _showValidationError(
    CliIO io,
    CliTheme theme,
    String error,
  ) async {
    io.writeln('');

    io.writeln('${theme.error(CliMarks.cross.symbol)} $error');

    io.writeln(theme.plain('Press Enter to search again...'));

    await _waitForEnter();
  }

  Future<void> _waitForEnter() async {
    keyboard.start();

    try {
      while (true) {
        final key = keyboard.read();

        if (key.isEnter) {
          return;
        }
      }
    } finally {
      keyboard.stop();
    }
  }

  int _findOriginalIndex(String selectedValue, List<String> searchResults) {
    if (options is List<String>) {
      return (options as List<String>).indexOf(selectedValue);
    }

    // For dynamic searches, return the index from search results.
    return searchResults.indexOf(selectedValue);
  }

  void _showConfirmation(
    CliIO io,
    CliTheme theme,
    String result, [
    int? resultsCount,
  ]) {
    if (resultsCount != null && resultsCount > 1) {
      final linesToMove = resultsCount + (help ? 3 : 2);

      CliTerminalControl.moveUp(linesToMove);

      for (var i = 0; i < linesToMove; i++) {
        CliTerminalControl.clearLine();

        if (i < linesToMove - 1) {
          CliTerminalControl.moveDown();
        }
      }

      CliTerminalControl.moveUp(linesToMove - 1);
    } else {
      CliTerminalControl.moveUp();
      CliTerminalControl.clearLine();
    }

    final checkmark = theme.success(CliMarks.check.symbol);
    final question = theme.primary(prompt);
    final answer = theme.plain(result);

    io.writeln('$checkmark $question $answer');
  }
}
