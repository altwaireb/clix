import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'unix_terminal_environment.dart';
import 'unix_tty_api.dart';

/// Manages the terminal state used by the Unix keyboard backend.
///
/// Supports macOS and Linux.
///
/// The native `termios` structure is intentionally treated as an opaque
/// buffer. This avoids depending on platform-specific struct layouts.
final class UnixTty {
  static const int _stdinFileDescriptor = 0;
  static const int _tcsanow = 0;

  // Deliberately larger than the termios structure used by supported
  // macOS/Linux targets.
  static const int _termiosBufferSize = 256;

  final UnixTtyApi _api;
  final UnixTerminalEnvironment _environment;

  Pointer<Uint8>? _originalState;
  bool _disposed = false;
  bool _raw = false;

  UnixTty({UnixTtyApi? api, UnixTerminalEnvironment? environment})
    : _api = api ?? NativeUnixTtyApi(),
      _environment = environment ?? const SystemUnixTerminalEnvironment();

  static bool get isSupportedPlatform => Platform.isLinux || Platform.isMacOS;

  bool get isRaw => _raw;

  /// Saves the current terminal state and switches the terminal to raw mode.
  void enterRaw() {
    _ensureNotDisposed();

    if (_raw) return;

    if (!_environment.hasTerminal) {
      throw StateError('Standard input is not connected to a terminal.');
    }

    final original = calloc<Uint8>(_termiosBufferSize);
    final raw = calloc<Uint8>(_termiosBufferSize);

    try {
      if (_api.tcgetattr(_stdinFileDescriptor, original.cast()) != 0) {
        throw StateError('Unable to read the Unix terminal state.');
      }

      _copy(source: original, destination: raw, length: _termiosBufferSize);

      _api.cfmakeraw(raw.cast());

      if (_api.tcsetattr(_stdinFileDescriptor, _tcsanow, raw.cast()) != 0) {
        throw StateError('Unable to enable Unix raw terminal mode.');
      }

      _originalState = original;
      _raw = true;
    } catch (_) {
      calloc.free(original);
      rethrow;
    } finally {
      calloc.free(raw);
    }
  }

  /// Restores the terminal state captured by [enterRaw].
  void restore() {
    if (_disposed || !_raw) return;

    final original = _originalState;
    if (original == null) return;

    try {
      _api.tcsetattr(_stdinFileDescriptor, _tcsanow, original.cast());
    } finally {
      calloc.free(original);
      _originalState = null;
      _raw = false;
    }
  }

  /// Restores the terminal and releases resources.
  void dispose() {
    if (_disposed) return;

    restore();
    _disposed = true;
  }

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError('UnixTty has been disposed.');
    }
  }

  static void _copy({
    required Pointer<Uint8> source,
    required Pointer<Uint8> destination,
    required int length,
  }) {
    for (var index = 0; index < length; index++) {
      destination[index] = source[index];
    }
  }
}
