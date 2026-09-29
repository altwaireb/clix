/// Clix - A comprehensive CLI development toolkit for Dart
///
/// **Complete CLI solution combining logging, styling, prompts, and progress tracking**
///
/// Combines the best features of Interact, Tint, and Durham Logger
/// into a single, cohesive package for building interactive CLI applications.
///
/// ## Core Features:
/// - **Advanced Styling**: Colors, themes, and formatting
/// - **Rich Logging**: Multiple levels with timestamps and styling
/// - **Interactive Prompts**: Input, select, confirm, and more
/// - **Progress Tracking**: Bars, spinners, and multi-task progress
/// - **Data Tables**: Formatted table output with alignment
/// - **Configuration**: Easy setup and customization
/// - **Testing Utilities**: CLI testing tools and helpers
///
/// ## Quick Start:
/// ```dart
/// import 'package:clix/clix.dart';
///
/// void main() {
///   // Simple logging
///   Clix.logger.info('Hello from Clix!');
///
///   // Interactive prompt
///   final name = InputPrompt('What is your name?').ask();
///
///   // Progress tracking
///   final progress = Progress(total: 100);
///   progress.update(50);
/// }
/// ```
library;

// Core imports for Clix class functionality
import 'src/core/io/console_io.dart';
import 'src/core/io/cli_io.dart';
import 'src/core/style/theme.dart';
import 'src/core/context/cli_context.dart';
import 'src/logger/logger.dart';

///
/// ## Exported Components:
///
/// ### **Logging System**
/// - [CliLogger] - Main logger with multiple levels and formatting
/// - [LogLevel] - Debug, info, warning, error, and success levels

export 'src/logger/logger.dart';
export 'src/logger/log_level.dart';

/// ### **IO & Core Infrastructure**
/// - [CliIO] - Abstract IO interface for testing and flexibility
/// - [ConsoleIO] - Real console implementation for production use

export 'src/core/io/cli_io.dart';
export 'src/core/io/console_io.dart';

/// ### **Styling & Theming**
/// - [CliStyle] - Text styling with colors and formatting
/// - [CliColor] - Comprehensive color system (25+ colors + hex)
/// - [CliTheme] - Consistent theming across components
/// - [Padding] - Layout and spacing control
/// - [LineSpacing] - Line height and vertical spacing

export 'src/core/style/style.dart';
export 'src/core/style/color.dart';
export 'src/core/style/theme.dart';
export 'src/core/style/padding.dart';
export 'src/core/style/spacing.dart';
export 'src/core/style/hint_symbol.dart';
export 'src/core/style/line_spacing.dart';

/// ### **Icons & Visual Elements**
/// - [CliIcons] - Ready-to-use CLI icons and symbols
/// - [CliMarks] - Text-based CLI marks and symbols

export 'src/core/icons/cli_icons.dart';
export 'src/core/icons/cli_marks.dart';

/// ### **Layout & Structure**
/// - [IndentLevel] - Hierarchical indentation control
/// - [TreeSymbol] - Tree-like structure visualization

export 'src/core/indentation/indent_level.dart';
export 'src/core/indentation/tree_symbol.dart';

/// ### **Formatting System**
/// - [CliFormatter] - Text and output formatting interface
/// - [BasicFormatter] - Standard formatting implementation

export 'src/core/formatter/formatter.dart';
export 'src/core/formatter/basic_formatter.dart';

/// ### **Interactive Prompts**
/// - [Prompt] - Base prompt functionality
/// - [InputPrompt] - Text input with validation
/// - [ConfirmPrompt] - Yes/no confirmation prompts
/// - [SelectPrompt] - Single selection from list
/// - [NumberPrompt] - Numeric input with validation
/// - [DecimalPrompt] - Decimal number input
/// - [SearchPrompt] - Searchable selection prompt
/// - [MultiSelectPrompt] - Multiple selection from list
/// - [PasswordPrompt] - Hidden password input
/// - [CliHelpPromptPosition] - Help prompt position

export 'src/prompt/prompt.dart';
export 'src/prompt/input_prompt.dart';
export 'src/prompt/confirm_prompt.dart';
export 'src/prompt/select_prompt.dart';
export 'src/prompt/number_prompt.dart';
export 'src/prompt/decimal_prompt.dart';
export 'src/prompt/search_prompt.dart';
export 'src/prompt/multi_select_prompt.dart';
export 'src/prompt/password_prompt.dart';
export 'src/prompt/cli_help_prompt_position.dart';

/// ### **Input Validation**
/// - [Validator] - Static validation methods for common patterns
/// - [ValidationRules] - Fluent builder for validation chains

export 'src/validation/validator.dart';
export 'src/validation/validation_rules.dart';

/// ### **Progress & Loading**
/// - [Progress] - Progress bars with multiple styles
/// - [Spinner] - Loading spinners (8+ animation types)
/// - [MultiSpinner] - Multi-task progress tracking
/// - [ProgressStyle] - Progress bar styling options
/// - [SpinnerType] - Available spinner animations
/// - [TaskStatus] - Task state management (pending, running, completed, failed)

export 'src/progress/progress.dart';
export 'src/progress/spinner.dart';
export 'src/progress/multi_spinner.dart';
export 'src/progress/enums/progress_style.dart';
export 'src/progress/enums/spinner_type.dart';
export 'src/progress/enums/task_status.dart';

/// ### **Data Tables**
/// - [Table] - Formatted table output with customization
/// - [TableAlignment] - Text alignment options (left, center, right)

export 'src/table/table.dart';
export 'src/table/enums/table_alignment.dart';

/// ### **Command-Line Arguments**
/// - [CliParser] - Command-line argument parser
/// - [CliOption] - Command-line option definition
/// - [CliArgResults] - Parsed command-line results
/// - [CliArgParserException] - Argument parsing exception
/// - [CliUsageException] - Usage-related exception
/// - [CliCommandRunner] - Command and subcommand runner
/// - [CliHelpCommand] - Built-in help command
/// - [CliUsage] - Usage generation and formatting
/// - [CliAllowAnythingParser] - Parser that allows unknown arguments

export 'src/args/cli_parser.dart';
export 'src/args/cli_option.dart';
export 'src/args/cli_arg_results.dart';
export 'src/args/cli_arg_parser_exception.dart';
export 'src/args/cli_usage_exception.dart';
export 'src/args/cli_command_runner.dart';
export 'src/args/cli_help_command.dart';
export 'src/args/cli_usage.dart';
export 'src/args/cli_allow_anything_parser.dart';

/// ### **Configuration & Exceptions**
/// - [CliConfig] - Application configuration management
/// - [CliException] - Standardized error handling

export 'src/config/cli_config.dart';
export 'src/exceptions/exceptions.dart';

/// ### **Terminal**
/// - [CliTerminal] - Terminal abstraction
/// - [CliTerminalInput] - Terminal input interface
/// - [CliTerminalOutput] - Terminal output interface
/// - [CliTerminalContext] - Current terminal context
/// - [CliTerminalControl] - Terminal screen and cursor controls
/// - [CliTerminalInfo] - Terminal capabilities and dimensions
/// - [CliTerminalSize] - Terminal dimensions
/// - [CliTerminalState] - Terminal input state snapshot

export 'src/core/terminal/cli_terminal.dart';
export 'src/core/terminal/cli_terminal_context.dart';
export 'src/core/terminal/cli_terminal_control.dart';
export 'src/core/terminal/cli_terminal_info.dart';
export 'src/core/terminal/cli_terminal_state.dart';

/// ### **Keyboard**
/// - [CliKeyboard] - Cross-platform keyboard input
/// - [CliKey] - Normalized keyboard key
/// - [CliKeyType] - Keyboard key types
/// - [CliKeyModifier] - Logical keyboard modifiers
/// - [CliKeyEvent] - Normalized keyboard event
/// - [CliKeyEventType] - Keyboard event transition type
/// - [CliKeyModifierKey] - Physical modifier keys
/// - [CliKeyState] - Physical and logical keyboard state

export 'src/core/keyboard/cli_keyboard.dart';
export 'src/core/keyboard/cli_key.dart';
export 'src/core/keyboard/cli_key_event.dart';
export 'src/core/keyboard/cli_key_modifier.dart';
export 'src/core/keyboard/cli_key_state.dart';
export 'src/core/keyboard/cli_key_type.dart';

/// **Main Clix class - Global access point for CLI operations**
///
/// Provides static access to core Clix functionality including:
/// - Global IO operations
/// - Global theme management
/// - Ready-to-use logger
///
/// ## Usage Examples:
/// ```dart
/// // Use default logger
/// Clix.logger.info('Application started');
///
/// // Apply custom theme
/// final myTheme = CliTheme(
///   primary: CliColor.cyan,
///   secondary: CliColor.orange,
/// );
/// Clix.useTheme(myTheme);
///
/// // Access IO operations
/// Clix.io.write('Hello World!');
/// ```
class Clix {
  /// **IO Operations** - Current global console input/output.
  ///
  /// Uses the IO configured in [CliContext].
  static CliIO get io => CliContext.io;

  /// **Active Theme** - Current global styling theme.
  ///
  /// Uses the theme configured in [CliContext].
  static CliTheme get theme => CliContext.theme;

  /// **Logger Instance** - Logger configured with the current global
  /// IO and theme.
  ///
  /// A new logger is created from the current [CliContext] whenever
  /// this getter is accessed, ensuring that it always uses the latest
  /// configuration.
  static CliLogger get logger {
    return CliLogger(io: CliContext.io, theme: CliContext.theme);
  }

  /// **Configure Global Clix Context**
  ///
  /// Updates the global IO and/or theme used by Clix components.
  ///
  /// Only the values provided are changed.
  ///
  /// ```dart
  /// Clix.configure(
  ///   io: myIO,
  ///   theme: myTheme,
  /// );
  /// ```
  static void configure({CliIO? io, CliTheme? theme}) {
    CliContext.configure(io: io, theme: theme);
  }

  /// **Set Global Theme** - Apply a custom theme to all Clix components.
  ///
  /// Updates the global theme used by Clix components that do not provide
  /// an explicit theme.
  ///
  /// ```dart
  /// final darkTheme = CliTheme(
  ///   primary: CliColor.cyan,
  ///   background: CliColor.black,
  /// );
  /// Clix.useTheme(darkTheme);
  /// ```
  static void useTheme(CliTheme newTheme) {
    CliContext.configure(theme: newTheme);
  }

  /// **Reset Global Configuration** - Restore Clix defaults.
  ///
  /// Resets the global IO and theme to their default values.
  static void reset() {
    CliContext.reset();
  }
}
