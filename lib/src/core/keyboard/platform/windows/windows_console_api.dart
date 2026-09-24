import 'dart:ffi';

import 'package:ffi/ffi.dart';

/// A keyboard event read from the Windows console.
final class WindowsConsoleInputRecord {
  final int eventType;
  final bool keyDown;
  final int repeatCount;
  final int virtualKeyCode;
  final int virtualScanCode;
  final int unicodeChar;
  final int controlKeyState;

  const WindowsConsoleInputRecord({
    required this.eventType,
    required this.keyDown,
    required this.repeatCount,
    required this.virtualKeyCode,
    required this.virtualScanCode,
    required this.unicodeChar,
    required this.controlKeyState,
  });
}

/// Abstraction over the native Windows console API.
///
/// The abstraction keeps [WindowsKeySource] independent from FFI so its
/// behavior can be tested deterministically.
abstract interface class WindowsConsoleApi {
  int getStdHandle(int standardHandle);

  int getConsoleMode(int handle, Pointer<Uint32> mode);

  int setConsoleMode(int handle, int mode);

  WindowsConsoleInputRecord? readConsoleInput(int handle);
}

/// Native implementation backed by kernel32.dll.
final class NativeWindowsConsoleApi implements WindowsConsoleApi {
  NativeWindowsConsoleApi() {
    final library = DynamicLibrary.open('kernel32.dll');

    _getStdHandle = library
        .lookupFunction<_GetStdHandleNative, _GetStdHandleDart>('GetStdHandle');

    _getConsoleMode = library
        .lookupFunction<_GetConsoleModeNative, _GetConsoleModeDart>(
          'GetConsoleMode',
        );

    _setConsoleMode = library
        .lookupFunction<_SetConsoleModeNative, _SetConsoleModeDart>(
          'SetConsoleMode',
        );

    _readConsoleInput = library
        .lookupFunction<_ReadConsoleInputNative, _ReadConsoleInputDart>(
          'ReadConsoleInputW',
        );
  }

  late final int Function(int) _getStdHandle;

  late final int Function(int, Pointer<Uint32>) _getConsoleMode;

  late final int Function(int, int) _setConsoleMode;

  late final int Function(int, Pointer<_InputRecord>, int, Pointer<Uint32>)
  _readConsoleInput;

  @override
  int getStdHandle(int standardHandle) {
    return _getStdHandle(standardHandle);
  }

  @override
  int getConsoleMode(int handle, Pointer<Uint32> mode) {
    return _getConsoleMode(handle, mode);
  }

  @override
  int setConsoleMode(int handle, int mode) {
    return _setConsoleMode(handle, mode);
  }

  @override
  WindowsConsoleInputRecord? readConsoleInput(int handle) {
    final record = calloc<_InputRecord>();
    final count = calloc<Uint32>();

    try {
      final result = _readConsoleInput(handle, record, 1, count);

      if (result == 0) {
        throw StateError('Unable to read a Windows console input event.');
      }

      if (count.value == 0) {
        return null;
      }

      final value = record.ref;

      return WindowsConsoleInputRecord(
        eventType: value.eventType,
        keyDown: value.keyDown != 0,
        repeatCount: value.repeatCount,
        virtualKeyCode: value.virtualKeyCode,
        virtualScanCode: value.virtualScanCode,
        unicodeChar: value.unicodeChar,
        controlKeyState: value.controlKeyState,
      );
    } finally {
      calloc.free(record);
      calloc.free(count);
    }
  }
}

final class _InputRecord extends Struct {
  @Uint16()
  external int eventType;

  // Required to preserve the native INPUT_RECORD memory layout.
  @Uint16()
  // ignore: unused_field
  external int _padding;

  @Uint32()
  external int keyDown;

  @Uint16()
  external int repeatCount;

  @Uint16()
  external int virtualKeyCode;

  @Uint16()
  external int virtualScanCode;

  @Uint16()
  external int unicodeChar;

  @Uint32()
  external int controlKeyState;
}

typedef _GetStdHandleNative = IntPtr Function(Int32 nStdHandle);
typedef _GetStdHandleDart = int Function(int nStdHandle);

typedef _GetConsoleModeNative =
    Int32 Function(IntPtr hConsoleHandle, Pointer<Uint32> lpMode);

typedef _GetConsoleModeDart =
    int Function(int hConsoleHandle, Pointer<Uint32> lpMode);

typedef _SetConsoleModeNative =
    Int32 Function(IntPtr hConsoleHandle, Uint32 dwMode);

typedef _SetConsoleModeDart = int Function(int hConsoleHandle, int mode);

typedef _ReadConsoleInputNative =
    Int32 Function(
      IntPtr hConsoleInput,
      Pointer<_InputRecord> lpBuffer,
      Uint32 nLength,
      Pointer<Uint32> lpNumberOfEventsRead,
    );

typedef _ReadConsoleInputDart =
    int Function(
      int hConsoleHandle,
      Pointer<_InputRecord> lpBuffer,
      int nLength,
      Pointer<Uint32> lpNumberOfEventsRead,
    );
