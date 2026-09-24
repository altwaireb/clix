import 'package:clix/src/core/keyboard/cli_key.dart';
import 'package:clix/src/core/keyboard/cli_key_modifier.dart';
import 'package:clix/src/core/keyboard/platform/windows/windows_console_api.dart';
import 'package:clix/src/core/keyboard/platform/windows/windows_key_source.dart';
import 'package:clix/src/core/keyboard/cli_key_type.dart';
import 'package:clix/src/core/keyboard/platform/windows/windows_key_event_adapter.dart';
import 'package:test/test.dart';

import 'fake_windows_console_api.dart';

void main() {
  group('WindowsKeySource', () {
    test('acquires the standard input handle', () {
      final api = FakeWindowsConsoleApi();

      final source = WindowsKeySource(api: api);

      expect(api.getStdHandleCalled, isTrue);

      source.dispose();
    });

    test('reports not started initially', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('starts and configures console mode', () {
      final api = FakeWindowsConsoleApi()..consoleMode = 0xFFFF;

      final source = WindowsKeySource(api: api);

      source.start();

      expect(source.isStarted, isTrue);
      expect(api.getConsoleModeCalls, 1);
      expect(api.setConsoleModeCalls, 1);
      expect(api.lastSetMode, isNotNull);

      source.dispose();
    });

    test('start is idempotent', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.start();
      source.start();

      expect(api.getConsoleModeCalls, 1);
      expect(api.setConsoleModeCalls, 1);

      source.dispose();
    });

    test('stop restores the original console mode', () {
      final api = FakeWindowsConsoleApi()..consoleMode = 0x1234;

      final source = WindowsKeySource(api: api);

      source.start();
      source.stop();

      expect(source.isStarted, isFalse);
      expect(api.setConsoleModeCalls, 2);
      expect(api.lastSetMode, 0x1234);
    });

    test('stop is idempotent', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.start();
      source.stop();
      source.stop();

      expect(api.setConsoleModeCalls, 2);
    });

    test('throws when starting after dispose', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.dispose();

      expect(source.start, throwsStateError);
    });

    test('throws when reading before start', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      expect(source.readKey, throwsStateError);

      source.dispose();
    });

    test('throws when reading after dispose', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.dispose();

      expect(source.readKey, throwsStateError);
    });

    test('reads a regular character', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x61,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('a'));

      source.dispose();
    });

    test('ignores non-key events', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(null)
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x42,
            virtualScanCode: 0,
            unicodeChar: 0x62,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('b'));
      expect(api.readConsoleInputCalls, 2);

      source.dispose();
    });

    test('ignores key-up events', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: false,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x61,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x42,
            virtualScanCode: 0,
            unicodeChar: 0x62,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('b'));
      expect(api.readConsoleInputCalls, 2);

      source.dispose();
    });

    test('tracks Ctrl modifier state', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xA2,
            virtualScanCode: 0x1D,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x61,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key.type, CliKeyType.ctrlGeneric);
      expect(key.text, 'a');
      expect(key.isCtrl, isTrue);

      source.dispose();
    });

    test('clears modifier state on stop', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xA2,
            virtualScanCode: 0x1D,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x01,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();
      source.readKey();
      source.stop();

      api.events.add(
        const WindowsConsoleInputRecord(
          eventType: 0x0001,
          keyDown: true,
          repeatCount: 1,
          virtualKeyCode: 0x42,
          virtualScanCode: 0,
          unicodeChar: 0x62,
          controlKeyState: 0,
        ),
      );

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('b'));
      expect(key.hasModifier(CliKeyModifier.ctrl), isFalse);

      source.dispose();
    });

    test('disposes the source and stops it', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.start();
      source.dispose();

      expect(source.isStarted, isFalse);

      source.dispose();

      expect(source.start, throwsStateError);
    });

    test('throws when GetConsoleMode fails', () {
      final api = FakeWindowsConsoleApi()..getConsoleModeResult = 0;

      final source = WindowsKeySource(api: api);

      expect(source.start, throwsStateError);

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('throws when SetConsoleMode fails', () {
      final api = FakeWindowsConsoleApi()..setConsoleModeResult = 0;

      final source = WindowsKeySource(api: api);

      expect(source.start, throwsStateError);

      expect(source.isStarted, isFalse);

      source.dispose();
    });

    test('throws when the input handle is invalid', () {
      final api = FakeWindowsConsoleApi()..handle = -1;

      expect(() => WindowsKeySource(api: api), throwsStateError);
    });

    test('reads Ctrl+C', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x43,
            virtualScanCode: 0,
            unicodeChar: 3,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      // The Ctrl modifier must be pressed first.
      // Windows emits it as a separate modifier event.
      api.events.insert(
        0,
        const WindowsConsoleInputRecord(
          eventType: 0x0001,
          keyDown: true,
          repeatCount: 1,
          virtualKeyCode: 0xA2,
          virtualScanCode: 0x1D,
          unicodeChar: 0,
          controlKeyState: 0,
        ),
      );

      final key = source.readKey();

      expect(key, const CliKey.ctrlC());

      source.dispose();
    });

    test('reads Ctrl+D', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xA2,
            virtualScanCode: 0x1D,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x44,
            virtualScanCode: 0,
            unicodeChar: 4,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.ctrlD());

      source.dispose();
    });

    test('reads Ctrl+R', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xA2,
            virtualScanCode: 0x1D,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x52,
            virtualScanCode: 0,
            unicodeChar: 18,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.ctrlR());

      source.dispose();
    });

    test('reads Ctrl+E', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xA2,
            virtualScanCode: 0x1D,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x45,
            virtualScanCode: 0,
            unicodeChar: 5,
            controlKeyState: 0x0008,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.ctrlE());

      source.dispose();
    });

    test('reads function keys F1 through F12', () {
      for (var functionNumber = 1; functionNumber <= 12; functionNumber++) {
        final api = FakeWindowsConsoleApi()
          ..events.add(
            WindowsConsoleInputRecord(
              eventType: 0x0001,
              keyDown: true,
              repeatCount: 1,
              virtualKeyCode: WindowsKeyEventAdapter.vkF1 + functionNumber - 1,
              virtualScanCode: 0,
              unicodeChar: 0,
              controlKeyState: 0,
            ),
          );

        final source = WindowsKeySource(api: api);

        source.start();

        final key = source.readKey();

        expect(key, CliKey.functionKey(functionNumber));

        source.dispose();
      }
    });

    test('reads navigation keys', () {
      final cases = <int, CliKey Function()>{
        WindowsKeyEventAdapter.vkUp: CliKey.arrowUp,
        WindowsKeyEventAdapter.vkDown: CliKey.arrowDown,
        WindowsKeyEventAdapter.vkLeft: CliKey.arrowLeft,
        WindowsKeyEventAdapter.vkRight: CliKey.arrowRight,
        WindowsKeyEventAdapter.vkHome: CliKey.home,
        WindowsKeyEventAdapter.vkEnd: CliKey.end,
        WindowsKeyEventAdapter.vkPageUp: CliKey.pageUp,
        WindowsKeyEventAdapter.vkPageDown: CliKey.pageDown,
        WindowsKeyEventAdapter.vkInsert: CliKey.insert,
        WindowsKeyEventAdapter.vkDelete: CliKey.delete,
      };

      for (final entry in cases.entries) {
        final api = FakeWindowsConsoleApi()
          ..events.add(
            WindowsConsoleInputRecord(
              eventType: 0x0001,
              keyDown: true,
              repeatCount: 1,
              virtualKeyCode: entry.key,
              virtualScanCode: 0,
              unicodeChar: 0,
              controlKeyState: 0,
            ),
          );

        final source = WindowsKeySource(api: api);

        source.start();

        final key = source.readKey();

        expect(key, entry.value());

        source.dispose();
      }
    });

    test('reads basic control keys', () {
      final cases = <int, CliKey Function()>{
        WindowsKeyEventAdapter.vkBackspace: CliKey.backspace,
        WindowsKeyEventAdapter.vkTab: CliKey.tab,
        WindowsKeyEventAdapter.vkEnter: CliKey.enter,
        WindowsKeyEventAdapter.vkEscape: CliKey.escape,
      };

      for (final entry in cases.entries) {
        final api = FakeWindowsConsoleApi()
          ..events.add(
            WindowsConsoleInputRecord(
              eventType: 0x0001,
              keyDown: true,
              repeatCount: 1,
              virtualKeyCode: entry.key,
              virtualScanCode: 0,
              unicodeChar: 0,
              controlKeyState: 0,
            ),
          );

        final source = WindowsKeySource(api: api);

        source.start();

        final key = source.readKey();

        expect(key, entry.value());

        source.dispose();
      }
    });

    test('preserves Shift modifier for a character', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: WindowsKeyEventAdapter.vkLShift,
            virtualScanCode: 0x2A,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x41,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(
        key,
        const CliKey.character('A', modifiers: {CliKeyModifier.shift}),
      );

      source.dispose();
    });

    test('preserves Alt modifier for a character', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: WindowsKeyEventAdapter.vkLAlt,
            virtualScanCode: 0x38,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        )
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0x41,
            virtualScanCode: 0,
            unicodeChar: 0x61,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.character('a', modifiers: {CliKeyModifier.alt}));

      source.dispose();
    });

    test('reads an unknown key', () {
      final api = FakeWindowsConsoleApi()
        ..events.add(
          const WindowsConsoleInputRecord(
            eventType: 0x0001,
            keyDown: true,
            repeatCount: 1,
            virtualKeyCode: 0xFF,
            virtualScanCode: 0,
            unicodeChar: 0,
            controlKeyState: 0,
          ),
        );

      final source = WindowsKeySource(api: api);

      source.start();

      final key = source.readKey();

      expect(key, const CliKey.unknown(code: 0xFF));

      source.dispose();
    });

    test('propagates console read errors', () {
      final api = FakeWindowsConsoleApi();
      final source = WindowsKeySource(api: api);

      source.start();

      expect(source.readKey, throwsStateError);

      source.dispose();
    });
  });
}
