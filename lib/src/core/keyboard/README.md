# Clix Keyboard Core — Phase 3

Phase 3 adds the platform input boundary for Windows, macOS, and Linux.

## Architecture

```text
CliKeyboard
    ↓
CliKeyReader
    ↓
CliKeySource
    ├── WindowsKeySource
    │   └── Windows Console API / KEY_EVENT_RECORD
    └── UnixKeySource
        └── macOS + Linux terminal bytes / ANSI sequences
```

The public key model remains platform-independent.

### Windows

Windows uses `ReadConsoleInputW` so navigation keys and modifier state are read
from native console events rather than relying on `stdin.readByteSync()`.

### macOS / Linux

Unix terminals use ANSI/xterm byte sequences. The parser understands standard
modifier parameters such as `CSI 1;2A` (Shift+Up), `CSI 1;3A` (Alt+Left), and
`CSI 1;5C` (Ctrl+Right).

`Command (⌘)` is intentionally represented in the common key model, but a
terminal application cannot generally receive Command shortcuts such as
`⌘C`/`⌘V`: terminal emulators normally consume those shortcuts themselves.
This is an operating-system/terminal boundary, not a parser limitation.

## Dependency

The Windows FFI backend uses the small `ffi` package internally. Clix owns the
keyboard API; platform details are not exposed through the public API.
