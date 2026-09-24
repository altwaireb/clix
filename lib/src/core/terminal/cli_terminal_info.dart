import 'cli_terminal_context.dart';

/// Safe access to terminal capabilities and dimensions.
abstract final class CliTerminalInfo {
  static const defaultColumns = 80;
  static const defaultRows = 24;

  CliTerminalInfo._();

  static bool get hasTerminal {
    try {
      return CliTerminalContext.output.hasTerminal;
    } catch (_) {
      return false;
    }
  }

  static int get columns {
    try {
      final output = CliTerminalContext.output;
      return output.hasTerminal ? output.terminalColumns : defaultColumns;
    } catch (_) {
      return defaultColumns;
    }
  }

  static int get rows {
    try {
      final output = CliTerminalContext.output;
      return output.hasTerminal ? output.terminalLines : defaultRows;
    } catch (_) {
      return defaultRows;
    }
  }

  static CliTerminalSize get size =>
      CliTerminalSize(columns: columns, rows: rows);
}

final class CliTerminalSize {
  final int columns;
  final int rows;

  const CliTerminalSize({required this.columns, required this.rows});

  @override
  String toString() => '$columns x $rows';

  @override
  bool operator ==(Object other) =>
      other is CliTerminalSize &&
      other.columns == columns &&
      other.rows == rows;

  @override
  int get hashCode => Object.hash(columns, rows);
}
