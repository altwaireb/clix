import 'dart:ffi';

import 'package:clix/src/core/keyboard/platform/windows/windows_console_api.dart';

final class FakeWindowsConsoleApi implements WindowsConsoleApi {
  static const defaultHandle = 123;

  int handle = defaultHandle;
  int consoleMode = 0xFFFF;

  bool getStdHandleCalled = false;
  int getConsoleModeCalls = 0;
  int setConsoleModeCalls = 0;
  int readConsoleInputCalls = 0;

  int? getConsoleModeResult = 1;
  int? setConsoleModeResult = 1;

  final List<WindowsConsoleInputRecord?> events = [];

  int? lastSetMode;

  @override
  int getStdHandle(int standardHandle) {
    getStdHandleCalled = true;
    return handle;
  }

  @override
  int getConsoleMode(int handle, Pointer<Uint32> mode) {
    getConsoleModeCalls++;

    final result = getConsoleModeResult ?? 1;

    if (result != 0) {
      mode.value = consoleMode;
    }

    return result;
  }

  @override
  int setConsoleMode(int handle, int mode) {
    setConsoleModeCalls++;
    lastSetMode = mode;

    return setConsoleModeResult ?? 1;
  }

  @override
  WindowsConsoleInputRecord? readConsoleInput(int handle) {
    readConsoleInputCalls++;

    if (events.isEmpty) {
      throw StateError('FakeWindowsConsoleApi has no more events.');
    }

    return events.removeAt(0);
  }
}
