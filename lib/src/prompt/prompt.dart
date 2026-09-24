import '../core/context/cli_context.dart';
import '../core/io/cli_io.dart';
import '../core/style/theme.dart';

abstract class Prompt<T> {
  Future<T> run(CliIO io, CliTheme theme);

  Future<T> interact([CliIO? io, CliTheme? theme]) {
    final effectiveIO = io ?? CliContext.io;
    final effectiveTheme = theme ?? CliContext.theme;

    return run(effectiveIO, effectiveTheme);
  }
}
