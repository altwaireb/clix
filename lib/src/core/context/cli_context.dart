import '../io/cli_io.dart';
import '../io/console_io.dart';
import '../style/theme.dart';

abstract final class CliContext {
  static CliIO io = ConsoleIO();
  static CliTheme theme = CliTheme.defaultTheme();

  static void configure({CliIO? io, CliTheme? theme}) {
    if (io != null) {
      CliContext.io = io;
    }

    if (theme != null) {
      CliContext.theme = theme;
    }
  }

  static void reset() {
    io = ConsoleIO();
    theme = CliTheme.defaultTheme();
  }
}
