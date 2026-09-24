/// Collection of predefined icons for CLI applications.
///
/// Each icon represents a visual pictorial symbol that can be used with
/// logger methods or directly accessed via the `symbol` getter.
///
/// For text-based CLI marks such as bullets, checks, arrows, and symbols,
/// see [CliMarks].
///
/// Example usage:
/// ```dart
/// logger.withIcon('Success!', icon: CliIcons.success);
/// logger.withIcon('Building...', icon: CliIcons.build);
/// ```
enum CliIcons {
  // Basic status icons

  /// ✅ Success/completion icon
  success,

  /// ❌ Error/failure icon
  error,

  /// ⚠️ Warning/caution icon
  warning,

  /// ℹ️ Information icon
  info,

  /// 💡 Idea/tip/suggestion icon
  idea,

  // File and folder icons

  /// 📄 Document/file icon
  file,

  /// 📁 Directory/folder icon
  folder,

  // Development and operations icons

  /// 🚀 Launch/rocket icon
  rocket,

  /// 🔨 Build/compile icon
  build,

  /// 🧪 Test/experiment icon
  test,

  /// 📦 Deploy/package icon
  deploy,

  // Utility icons

  /// 🔍 Search/find icon
  search,

  /// 🔒 Security/locked icon
  lock,

  /// 🔑 Key/credentials icon
  key,

  /// 👤 User/account icon
  user,

  /// 🗄️ Database/storage icon
  database,

  /// 🔗 Link/connection icon
  link,

  /// 🗑️ Delete/remove icon
  trash;

  /// Returns the visual symbol for this icon.
  ///
  /// Example:
  /// ```dart
  /// print(CliIcons.success.symbol); // prints: ✅
  /// print(CliIcons.rocket.symbol);  // prints: 🚀
  /// print(CliIcons.search.symbol);  // prints: 🔍
  /// ```
  String get symbol {
    switch (this) {
      case CliIcons.success:
        return '✅';
      case CliIcons.error:
        return '❌';
      case CliIcons.warning:
        return '⚠️ ';
      case CliIcons.info:
        return 'ℹ️ ';
      case CliIcons.idea:
        return '💡';
      case CliIcons.file:
        return '📄';
      case CliIcons.folder:
        return '📁';
      case CliIcons.rocket:
        return '🚀';
      case CliIcons.build:
        return '🔨';
      case CliIcons.test:
        return '🧪';
      case CliIcons.deploy:
        return '📦';
      case CliIcons.search:
        return '🔍';
      case CliIcons.lock:
        return '🔒';
      case CliIcons.key:
        return '🔑';
      case CliIcons.user:
        return '👤';
      case CliIcons.database:
        return '🗄️';
      case CliIcons.link:
        return '🔗';
      case CliIcons.trash:
        return '🗑️';
    }
  }

  @override
  String toString() => symbol;
}
