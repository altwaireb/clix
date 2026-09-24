import 'prompt.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';

class Password extends Prompt<String> {
  final String prompt;
  final String? defaultValue;
  final String? Function(String)? validator;
  final bool confirmation;
  final String? confirmPrompt;
  final String? confirmError;

  Password({
    required this.prompt,
    this.defaultValue,
    this.validator,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  });

  @override
  Future<String> run(CliIO io, CliTheme theme) async {
    while (true) {
      // Get the main password
      final password = await _promptPassword(io, theme, prompt);

      // Validate the password if validator is provided
      if (validator != null) {
        final error = validator!(password);
        if (error != null) {
          io.writeln(theme.error(error));
          continue;
        }
      }

      // If confirmation is required
      if (confirmation) {
        final confirmMsg =
            confirmPrompt ?? 'Confirm ${prompt.replaceAll(':', '')}';

        final confirmPassword = await _promptPassword(io, theme, confirmMsg);

        if (password != confirmPassword) {
          final error = confirmError ?? 'Passwords do not match';
          io.writeln(theme.error(error));
          continue;
        }
      }

      return password;
    }
  }

  /// Helper method to prompt for a single password.
  Future<String> _promptPassword(
    CliIO io,
    CliTheme theme,
    String promptMessage,
  ) async {
    io.write('${theme.primary(promptMessage)} ');

    final password = io.read(mode: CliInputMode.hidden);

    io.writeln('');

    return password.isEmpty && defaultValue != null ? defaultValue! : password;
  }
}
