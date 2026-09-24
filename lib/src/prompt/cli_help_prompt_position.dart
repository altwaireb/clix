/// Defines where the help prompt is displayed.
///
/// Use this enum to control whether the help prompt appears above or below
/// the available options in an interactive prompt.
///
/// Example:
///
/// ```dart
/// Select(
///   prompt: 'Choose a color:',
///   options: ['Red', 'Green', 'Blue'],
///   helpPosition: CliHelpPromptPosition.top,
/// );
/// ```
///
/// See also:
///
/// - [CliHelpPromptPosition.top] - Displays the help prompt above the options.
/// - [CliHelpPromptPosition.bottom] - Displays the help prompt below the options.
enum CliHelpPromptPosition {
  /// Displays the help prompt above the available options.
  top,

  /// Displays the help prompt below the available options.
  bottom,
}
