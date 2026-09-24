import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../../cli_key.dart';
import '../../cli_key_reader.dart';
import '../../cli_key_sequence.dart';
import 'unix_tty.dart';

/// Unix terminal keyboard source for macOS and Linux.
///
/// The first byte is read synchronously from stdin. When that byte starts an
/// escape sequence or UTF-8 character, [poll] is used to collect the remaining
/// bytes without blocking forever on a standalone Escape key.
///
/// When reading from the real terminal, the source enables raw mode and
/// restores the original terminal state when disposed. Injected byte sources
/// are kept independent of terminal state so they remain suitable for tests.
final class UnixKeySource implements CliKeySource {
  static const _sequenceTimeoutMs = 30;

  final CliKeyByteSource? _injectedSource;
  final UnixTty? _tty;

  late final _UnixNativeApi _api;

  bool _disposed = false;
  bool _started = false;

  UnixKeySource({CliKeyByteSource? source})
    : _injectedSource = source,
      _tty = source == null ? UnixTty() : null {
    if (_injectedSource == null) {
      _api = _UnixNativeApi();
    }
  }

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_disposed) throw StateError('UnixKeySource has been disposed.');
    if (_started) return;

    _tty?.enterRaw();
    _started = true;
  }

  @override
  CliKey readKey() {
    if (_disposed) {
      throw StateError('UnixKeySource has been disposed.');
    }
    if (!_started) {
      throw StateError('UnixKeySource has not been started.');
    }

    final injected = _injectedSource;
    if (injected != null) {
      return CliKeySequenceParser.parse(injected.readKeySequence()) ??
          const CliKey.unknown();
    }

    final input = stdin;
    final first = input.readByteSync();

    if (first == 0x1b) {
      return CliKeySequenceParser.parse(_readEscapeSequence(first)) ??
          const CliKey.escape();
    }

    if (first >= 0x80) {
      return CliKeySequenceParser.parse(_readUtf8Sequence(first)) ??
          CliKey.unknown(code: first);
    }

    return CliKeySequenceParser.parse([first]) ?? const CliKey.unknown();
  }

  List<int> _readEscapeSequence(int first) {
    final bytes = <int>[first];

    // A standalone Escape must remain an Escape instead of blocking forever.
    if (!_waitForInput(_sequenceTimeoutMs)) return bytes;

    bytes.add(stdin.readByteSync());

    // CSI and SS3 sequences continue until their final byte.
    if (bytes.length >= 2 && (bytes[1] == 0x5b || bytes[1] == 0x4f)) {
      while (bytes.length < 32) {
        if (!_waitForInput(_sequenceTimeoutMs)) break;

        final byte = stdin.readByteSync();
        bytes.add(byte);

        if ((byte >= 0x40 && byte <= 0x7e) ||
            byte == 0x1b ||
            byte == 0x0a ||
            byte == 0x0d) {
          break;
        }
      }
    }

    return bytes;
  }

  List<int> _readUtf8Sequence(int first) {
    final expected = _utf8Length(first);
    if (expected <= 1) return [first];

    final bytes = <int>[first];

    while (bytes.length < expected && _waitForInput(_sequenceTimeoutMs)) {
      bytes.add(stdin.readByteSync());
    }

    return bytes;
  }

  int _utf8Length(int first) {
    if (first >= 0xc2 && first <= 0xdf) return 2;
    if (first >= 0xe0 && first <= 0xef) return 3;
    if (first >= 0xf0 && first <= 0xf4) return 4;
    return 1;
  }

  @override
  void stop() {
    if (_disposed || !_started) return;

    _tty?.restore();
    _started = false;
  }

  @override
  void dispose() {
    if (_disposed) return;

    stop();
    _tty?.dispose();
    _disposed = true;
  }

  bool _waitForInput(int timeoutMs) {
    final descriptor = calloc<_PollFd>();

    try {
      descriptor.ref.fd = 0;
      descriptor.ref.events = 0x0001; // POLLIN
      descriptor.ref.revents = 0;

      final result = _api.poll(descriptor, 1, timeoutMs);

      return result > 0 && (descriptor.ref.revents & 0x0001) != 0;
    } finally {
      calloc.free(descriptor);
    }
  }
}

final class _UnixNativeApi {
  _UnixNativeApi() {
    final library = DynamicLibrary.process();

    poll = library.lookupFunction<_PollNative, _PollDart>('poll');
  }

  late final int Function(Pointer<_PollFd>, int, int) poll;
}

final class _PollFd extends Struct {
  @Int32()
  external int fd;

  @Uint16()
  external int events;

  @Uint16()
  external int revents;
}

typedef _PollNative =
    Int32 Function(Pointer<_PollFd> fds, IntPtr nfds, Int32 timeout);

typedef _PollDart = int Function(Pointer<_PollFd> fds, int nfds, int timeout);
