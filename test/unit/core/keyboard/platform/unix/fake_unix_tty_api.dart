import 'dart:ffi';

import 'package:clix/src/core/keyboard/platform/unix/unix_tty_api.dart';

final class FakeUnixTtyApi implements UnixTtyApi {
  int tcgetattrResult = 0;
  int tcsetattrResult = 0;

  int tcgetattrCalls = 0;
  int tcsetattrCalls = 0;
  int cfmakerawCalls = 0;

  int? lastFileDescriptor;
  int? lastOptionalActions;

  Pointer<Void>? lastTcgetattrTermios;
  Pointer<Void>? lastTcsetattrTermios;
  Pointer<Void>? lastCfmakerawTermios;

  int? firstTcgetattrAddress;
  int? firstTcsetattrAddress;
  int? firstCfmakerawAddress;

  @override
  int tcgetattr(int fileDescriptor, Pointer<Void> termios) {
    tcgetattrCalls++;
    lastFileDescriptor = fileDescriptor;
    lastTcgetattrTermios = termios;
    firstTcgetattrAddress ??= termios.address;

    for (var index = 0; index < 256; index++) {
      termios.cast<Uint8>()[index] = index & 0xFF;
    }

    return tcgetattrResult;
  }

  @override
  int tcsetattr(
    int fileDescriptor,
    int optionalActions,
    Pointer<Void> termios,
  ) {
    tcsetattrCalls++;
    lastFileDescriptor = fileDescriptor;
    lastOptionalActions = optionalActions;
    lastTcsetattrTermios = termios;
    firstTcsetattrAddress ??= termios.address;

    return tcsetattrResult;
  }

  @override
  void cfmakeraw(Pointer<Void> termios) {
    cfmakerawCalls++;
    lastCfmakerawTermios = termios;
    firstCfmakerawAddress ??= termios.address;
  }
}
