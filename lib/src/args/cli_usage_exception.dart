/// An exception thrown when command-line usage is invalid.
class CliUsageException implements Exception {
  final String message;
  final String usage;

  CliUsageException(this.message, this.usage);

  @override
  String toString() => '$message\n\n$usage';
}
