import 'cli_key.dart';
import 'cli_key_reader.dart';

/// High-level keyboard facade used by interactive Clix components.
///
/// A keyboard session owns the platform input mode. Call [start] before
/// reading keys and [stop] when interactive input is finished.
final class CliKeyboard {
  final CliKeyReader reader;

  CliKeyboard({CliKeyReader? reader}) : reader = reader ?? CliKeyReader();

  bool get isStarted => reader.isStarted;

  void start() => reader.start();

  CliKey read() => reader.read();

  void stop() => reader.stop();

  void dispose() => reader.dispose();
}
