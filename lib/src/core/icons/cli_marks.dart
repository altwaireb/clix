/// Collection of predefined marks and symbols for CLI applications.
///
/// Each mark represents a text-based symbol that can be used with
/// logger methods or directly accessed via the `symbol` getter.
///
/// For visual pictorial icons such as success, error, build, and test,
/// see [CliIcons].
///
/// Example usage:
/// ```dart
/// logger.withMark(
///   'Task completed',
///   mark: CliMarks.check,
/// );
///
/// logger.withMark(
///   'Next step',
///   mark: CliMarks.arrow,
/// );
/// ```
enum CliMarks {
  // Basic marks

  /// • Bullet point mark
  bullet,

  /// ↵ Enter mark
  enter,

  /// ⇥ Tap mark
  tab,

  /// - Dash mark
  dash,

  /// ␣ Space mark
  space,

  /// ✓ Check/completion mark
  check,

  /// ✗ Cross/cancel mark
  cross,

  /// + Plus mark
  plus,

  /// − Minus mark
  minus,

  // Selection / navigation
  pointer,

  // Direction marks

  /// → General/right arrow mark
  arrow,

  /// ↑ Up arrow mark
  arrowUp,

  /// ↓ Down arrow mark
  arrowDown,

  /// ← Left arrow mark
  arrowLeft,

  /// → Right arrow mark
  arrowRight,

  // Decorative marks

  /// ★ Star mark
  star,

  /// ◆ Diamond mark
  diamond,

  /// ○ Circle mark
  circle,

  /// ◉ Selected circle mark
  selectedCircle,

  /// ■ Square mark
  square,

  /// ▶ Triangle mark
  triangle,

  /// · Dot mark
  dot,

  // Status marks

  /// ⓘ Information mark
  info,

  /// △ Warning mark
  warning;

  /// Returns the visual symbol for this mark.
  ///
  /// Example:
  /// ```dart
  /// print(CliMarks.check.symbol); // prints: ✓
  /// print(CliMarks.arrow.symbol); // prints: →
  /// print(CliMarks.plus.symbol);  // prints: +
  /// ```
  String get symbol {
    switch (this) {
      case CliMarks.bullet:
        return '•';
      case CliMarks.enter:
        return '↵';
      case CliMarks.tab:
        return '⇥';
      case CliMarks.dash:
        return '-';
      case CliMarks.space:
        return '␣';
      case CliMarks.check:
        return '✓';
      case CliMarks.cross:
        return '✗';
      case CliMarks.plus:
        return '+';
      case CliMarks.minus:
        return '−';
      case CliMarks.pointer:
        return '❯';
      case CliMarks.arrow:
        return '→';
      case CliMarks.arrowUp:
        return '↑';
      case CliMarks.arrowDown:
        return '↓';
      case CliMarks.arrowLeft:
        return '←';
      case CliMarks.arrowRight:
        return '→';
      case CliMarks.star:
        return '★';
      case CliMarks.diamond:
        return '◆';
      case CliMarks.circle:
        return '○';
      case CliMarks.selectedCircle:
        return '◉';
      case CliMarks.square:
        return '■';
      case CliMarks.triangle:
        return '▶';
      case CliMarks.dot:
        return '·';
      case CliMarks.info:
        return 'ⓘ';
      case CliMarks.warning:
        return '△';
    }
  }

  @override
  String toString() => symbol;
}
