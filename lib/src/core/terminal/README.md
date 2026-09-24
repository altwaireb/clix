# Clix Terminal Core

The terminal core is the platform boundary for interactive terminal behavior in Clix.

Phase 1 establishes:

- terminal input/output abstractions;
- the default `dart:io` implementation;
- injectable global terminal context;
- raw-mode state capture/restoration;
- terminal dimensions and availability;
- basic ANSI screen/cursor controls.

Keyboard decoding and platform-specific interactive input are deliberately a later phase. This keeps the first integration small and avoids pretending that `dart:io` byte input is a complete Windows keyboard backend.

The architecture was informed by the public `terminice_core` source supplied for this work. Clix owns this API and implementation; it does not depend on `terminice_core`.
