import 'package:clix/src/core/keyboard/platform/unix/unix_tty.dart';
import 'package:test/test.dart';

import 'fake_unix_terminal_environment.dart';
import 'fake_unix_tty_api.dart';

void main() {
  group('UnixTty', () {
    test('starts in a non-raw state', () {
      final tty = UnixTty(
        api: FakeUnixTtyApi(),
        environment: FakeUnixTerminalEnvironment(),
      );

      expect(tty.isRaw, isFalse);

      tty.dispose();
    });

    test('enterRaw switches the terminal to raw mode', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();

      expect(tty.isRaw, isTrue);
      expect(api.tcgetattrCalls, 1);
      expect(api.cfmakerawCalls, 1);
      expect(api.tcsetattrCalls, 1);
      expect(api.lastFileDescriptor, 0);
      expect(api.lastOptionalActions, 0);

      tty.dispose();
    });

    test('enterRaw is idempotent', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.enterRaw();

      expect(tty.isRaw, isTrue);
      expect(api.tcgetattrCalls, 1);
      expect(api.cfmakerawCalls, 1);
      expect(api.tcsetattrCalls, 1);

      tty.dispose();
    });

    test('restore exits raw mode', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.restore();

      expect(tty.isRaw, isFalse);
      expect(api.tcgetattrCalls, 1);
      expect(api.cfmakerawCalls, 1);
      expect(api.tcsetattrCalls, 2);

      tty.dispose();
    });

    test('restore is idempotent', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.restore();
      tty.restore();

      expect(tty.isRaw, isFalse);
      expect(api.tcsetattrCalls, 2);

      tty.dispose();
    });

    test('dispose restores raw mode', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.dispose();

      expect(tty.isRaw, isFalse);
      expect(api.tcsetattrCalls, 2);
    });

    test('dispose is idempotent', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.dispose();
      tty.dispose();

      expect(api.tcsetattrCalls, 2);
    });

    test('throws when entering raw mode without a terminal', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(
        api: api,
        environment: FakeUnixTerminalEnvironment(hasTerminal: false),
      );

      expect(tty.enterRaw, throwsStateError);

      expect(tty.isRaw, isFalse);
      expect(api.tcgetattrCalls, 0);
      expect(api.cfmakerawCalls, 0);
      expect(api.tcsetattrCalls, 0);

      tty.dispose();
    });

    test('throws when tcgetattr fails', () {
      final api = FakeUnixTtyApi()..tcgetattrResult = -1;

      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      expect(tty.enterRaw, throwsStateError);

      expect(tty.isRaw, isFalse);
      expect(api.tcgetattrCalls, 1);
      expect(api.cfmakerawCalls, 0);
      expect(api.tcsetattrCalls, 0);

      tty.dispose();
    });

    test('throws when tcsetattr fails while entering raw mode', () {
      final api = FakeUnixTtyApi()..tcsetattrResult = -1;

      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      expect(tty.enterRaw, throwsStateError);

      expect(tty.isRaw, isFalse);
      expect(api.tcgetattrCalls, 1);
      expect(api.cfmakerawCalls, 1);
      expect(api.tcsetattrCalls, 1);

      tty.dispose();
    });

    test('enterRaw can be called again after a failed attempt', () {
      final api = FakeUnixTtyApi()..tcgetattrResult = -1;

      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      expect(tty.enterRaw, throwsStateError);

      api.tcgetattrResult = 0;

      tty.enterRaw();

      expect(tty.isRaw, isTrue);
      expect(api.tcgetattrCalls, 2);
      expect(api.cfmakerawCalls, 1);
      expect(api.tcsetattrCalls, 1);

      tty.dispose();
    });

    test('throws when entering raw mode after dispose', () {
      final tty = UnixTty(
        api: FakeUnixTtyApi(),
        environment: FakeUnixTerminalEnvironment(),
      );

      tty.dispose();

      expect(tty.enterRaw, throwsStateError);
    });

    test('restore does nothing after dispose', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();
      tty.dispose();

      final calls = api.tcsetattrCalls;

      tty.restore();

      expect(api.tcsetattrCalls, calls);
      expect(tty.isRaw, isFalse);
    });

    test('restore does nothing before enterRaw', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.restore();

      expect(api.tcsetattrCalls, 0);

      tty.dispose();
    });

    test('uses a separate raw buffer', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();

      expect(api.firstTcgetattrAddress, isNotNull);

      expect(api.firstCfmakerawAddress, isNotNull);

      expect(api.firstTcsetattrAddress, isNotNull);

      expect(api.firstCfmakerawAddress, api.firstTcsetattrAddress);

      expect(api.firstTcgetattrAddress, isNot(api.firstTcsetattrAddress));

      tty.dispose();
    });

    test('uses the original terminal buffer when restoring', () {
      final api = FakeUnixTtyApi();
      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      tty.enterRaw();

      final original = api.lastTcgetattrTermios;

      tty.restore();

      expect(api.lastTcsetattrTermios?.address, original?.address);

      tty.dispose();
    });

    test('isRaw remains false when tcsetattr fails', () {
      final api = FakeUnixTtyApi()..tcsetattrResult = -1;

      final tty = UnixTty(api: api, environment: FakeUnixTerminalEnvironment());

      expect(tty.enterRaw, throwsStateError);

      expect(tty.isRaw, isFalse);

      tty.dispose();
    });
  });
}
