import 'prompt.dart';
import '../core/icons/cli_marks.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';
import '../core/terminal/cli_terminal_control.dart';

class Decimal extends Prompt<double> {
  final String prompt;
  final double? min;
  final double? max;
  final double? defaultValue;

  Decimal({required this.prompt, this.min, this.max, this.defaultValue});

  @override
  Future<double> run(CliIO io, CliTheme theme) async {
    while (true) {
      var promptText = theme.primary(prompt);

      if (min != null || max != null) {
        final range = 'Range: ${min ?? '-∞'} to ${max ?? '∞'}';
        promptText = '$promptText ($range)';
      }

      if (defaultValue != null) {
        promptText = '$promptText [$defaultValue]';
      }

      io.write('$promptText ');
      final input = io.readLine().trim();

      if (input.isEmpty && defaultValue != null) {
        _showConfirmation(io, theme, defaultValue!);
        return defaultValue!;
      }

      final value = double.tryParse(input);

      if (value == null) {
        io.writeln(theme.error('Invalid decimal number. Please try again.'));
        continue;
      }

      if (min != null && value < min!) {
        io.writeln(theme.error('Number must be at least $min'));
        continue;
      }

      if (max != null && value > max!) {
        io.writeln(theme.error('Number must be at most $max'));
        continue;
      }

      _showConfirmation(io, theme, value);
      return value;
    }
  }

  void _showConfirmation(CliIO io, CliTheme theme, double result) {
    CliTerminalControl.moveUp();
    CliTerminalControl.clearLine();

    final checkmark = theme.success(CliMarks.check.symbol);
    final question = theme.primary(prompt);
    final answer = theme.plain(result.toString());

    io.writeln('$checkmark $question $answer');
    io.writeln('');
  }
}
