import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../../cli_key.dart';
import '../../cli_key_event.dart';
import '../../cli_key_modifier.dart';
import '../../cli_key_reader.dart';
import '../../cli_key_state.dart';
import 'windows_console_api.dart';
import 'windows_key_event_adapter.dart';

/// Native Windows Console keyboard source.
///
/// Windows Console emits structured KEY_EVENT_RECORD values. Reading those
/// records avoids the stdin byte-mode limitations of Windows and preserves
/// modifier state for the Clix key model.
final class WindowsKeySource implements CliKeySource {
  static const _stdInputHandle = -10;
  static const _keyEvent = 0x0001;

  static const _enableProcessedInput = 0x0001;
  static const _enableLineInput = 0x0002;
  static const _enableEchoInput = 0x0004;
  static const _enableQuickEditMode = 0x0040;
  static const _enableExtendedFlags = 0x0080;

  late final int _handle;

  final WindowsConsoleApi _api;
  final WindowsKeyEventAdapter _adapter;
  final CliKeyState _state;

  int? _originalMode;
  bool _disposed = false;
  bool _started = false;

  WindowsKeySource({
    WindowsConsoleApi? api,
    WindowsKeyEventAdapter? adapter,
    CliKeyState? state,
  }) : _api = api ?? NativeWindowsConsoleApi(),
       _adapter = adapter ?? WindowsKeyEventAdapter(),
       _state = state ?? CliKeyState() {
    if (!Platform.isWindows) {
      throw UnsupportedError('WindowsKeySource is only available on Windows.');
    }

    _handle = _api.getStdHandle(_stdInputHandle);

    if (_handle == 0 || _handle == -1) {
      throw StateError('Unable to acquire the Windows console input handle.');
    }
  }

  @override
  bool get isStarted => _started;

  /// Starts a console input session suitable for structured key events.
  @override
  void start() {
    if (_disposed) {
      throw StateError('WindowsKeySource has been disposed.');
    }

    if (_started) return;

    final modePointer = calloc<Uint32>();

    try {
      if (_api.getConsoleMode(_handle, modePointer) == 0) {
        throw StateError('Unable to read the Windows console input mode.');
      }

      final original = modePointer.value;
      _originalMode = original;

      final mode =
          (original &
              ~(_enableLineInput |
                  _enableEchoInput |
                  _enableProcessedInput |
                  _enableQuickEditMode)) |
          _enableExtendedFlags;

      if (_api.setConsoleMode(_handle, mode) == 0) {
        _originalMode = null;

        throw StateError('Unable to configure the Windows console input mode.');
      }

      _started = true;
    } finally {
      calloc.free(modePointer);
    }
  }

  /// Stops the console input session and restores its previous mode.
  @override
  void stop() {
    if (_disposed || !_started) return;

    final original = _originalMode;

    try {
      if (original != null) {
        _api.setConsoleMode(_handle, original);
      }
    } finally {
      _originalMode = null;
      _started = false;
      _state.clear();
    }
  }

  @override
  CliKey readKey() {
    if (_disposed) {
      throw StateError('WindowsKeySource has been disposed.');
    }

    if (!_started) {
      throw StateError('WindowsKeySource has not been started.');
    }

    while (true) {
      final record = _api.readConsoleInput(_handle);

      if (record == null || record.eventType != _keyEvent) {
        continue;
      }

      final event = _toCliKeyEvent(record);

      if (event.modifier != null) {
        _state.apply(event);
        continue;
      }

      if (event.type != CliKeyEventType.down) {
        continue;
      }

      return _toCliKey(event);
    }
  }

  CliKeyEvent _toCliKeyEvent(WindowsConsoleInputRecord record) {
    return _adapter.convert(
      virtualKeyCode: record.virtualKeyCode,
      virtualScanCode: record.virtualScanCode,
      unicodeChar: record.unicodeChar,
      controlKeyState: record.controlKeyState,
      keyDown: record.keyDown,
    );
  }

  CliKey _toCliKey(CliKeyEvent event) {
    final code = event.code;
    final text = event.text;
    final modifiers = _state.modifiers;

    if (modifiers.contains(CliKeyModifier.ctrl) && text != null) {
      final characterCode = text.codeUnitAt(0);

      switch (characterCode) {
        case 3:
          return const CliKey.ctrlC();

        case 4:
          return const CliKey.ctrlD();

        case 18:
          return const CliKey.ctrlR();

        case 5:
          return const CliKey.ctrlE();
      }

      if (text.length == 1 && characterCode >= 0x20) {
        return CliKey.ctrlGeneric(text);
      }
    }

    switch (code) {
      case WindowsKeyEventAdapter.vkBackspace:
        return CliKey.backspace(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkTab:
        return CliKey.tab(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkEnter:
        return CliKey.enter(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkEscape:
        return CliKey.escape(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkPageUp:
        return CliKey.pageUp(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkPageDown:
        return CliKey.pageDown(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkEnd:
        return CliKey.end(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkHome:
        return CliKey.home(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkLeft:
        return CliKey.arrowLeft(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkUp:
        return CliKey.arrowUp(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkRight:
        return CliKey.arrowRight(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkDown:
        return CliKey.arrowDown(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkInsert:
        return CliKey.insert(modifiers: modifiers);

      case WindowsKeyEventAdapter.vkDelete:
        return CliKey.delete(modifiers: modifiers);
    }

    if (code != null &&
        code >= WindowsKeyEventAdapter.vkF1 &&
        code <= WindowsKeyEventAdapter.vkF12) {
      return CliKey.functionKey(
        code - WindowsKeyEventAdapter.vkF1 + 1,
        modifiers: modifiers,
      );
    }

    if (text == ' ') {
      return CliKey.space(modifiers: modifiers);
    }

    if (text != null) {
      return CliKey.character(text, modifiers: modifiers);
    }

    return CliKey.unknown(code: code, text: text, modifiers: modifiers);
  }

  @override
  void dispose() {
    if (_disposed) return;

    stop();
    _state.clear();
    _disposed = true;
  }
}
