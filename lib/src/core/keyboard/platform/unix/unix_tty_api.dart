import 'dart:ffi';

/// Abstraction over the native Unix terminal API.
abstract interface class UnixTtyApi {
  int tcgetattr(int fileDescriptor, Pointer<Void> termios);

  int tcsetattr(int fileDescriptor, int optionalActions, Pointer<Void> termios);

  void cfmakeraw(Pointer<Void> termios);
}

/// Native implementation backed by the process' Unix symbols.
final class NativeUnixTtyApi implements UnixTtyApi {
  NativeUnixTtyApi() {
    final library = DynamicLibrary.process();

    _tcgetattr = library.lookupFunction<_TcgetattrNative, _TcgetattrDart>(
      'tcgetattr',
    );

    _tcsetattr = library.lookupFunction<_TcsetattrNative, _TcsetattrDart>(
      'tcsetattr',
    );

    _cfmakeraw = library.lookupFunction<_CfmakerawNative, _CfmakerawDart>(
      'cfmakeraw',
    );
  }

  late final int Function(int, Pointer<Void>) _tcgetattr;

  late final int Function(int, int, Pointer<Void>) _tcsetattr;

  late final void Function(Pointer<Void>) _cfmakeraw;

  @override
  int tcgetattr(int fileDescriptor, Pointer<Void> termios) {
    return _tcgetattr(fileDescriptor, termios);
  }

  @override
  int tcsetattr(
    int fileDescriptor,
    int optionalActions,
    Pointer<Void> termios,
  ) {
    return _tcsetattr(fileDescriptor, optionalActions, termios);
  }

  @override
  void cfmakeraw(Pointer<Void> termios) {
    _cfmakeraw(termios);
  }
}

typedef _TcgetattrNative = Int32 Function(Int32 fd, Pointer<Void> termios);

typedef _TcgetattrDart = int Function(int fd, Pointer<Void> termios);

typedef _TcsetattrNative =
    Int32 Function(Int32 fd, Int32 optionalActions, Pointer<Void> termios);

typedef _TcsetattrDart =
    int Function(int fd, int optionalActions, Pointer<Void> termios);

typedef _CfmakerawNative = Void Function(Pointer<Void> termios);

typedef _CfmakerawDart = void Function(Pointer<Void> termios);
