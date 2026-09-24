import 'dart:io';

import '../cli_key_reader.dart';
import 'unix/unix_key_source.dart';
import 'windows/windows_key_source.dart';

/// Creates the native keyboard source for the current operating system.
abstract final class CliPlatformKeySource {
  CliPlatformKeySource._();

  static CliKeySource create() {
    if (Platform.isWindows) return WindowsKeySource();
    return UnixKeySource();
  }
}
