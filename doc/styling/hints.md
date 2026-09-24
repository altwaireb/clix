# Hints

`HintSymbol` provides predefined symbols for hint text.

Available symbols:

`none`, `dot`, `arrow`, `dash`, `pipe`, `chevron`, `diamond`, `triangle`, `doubleArrow`, `star`, `info`, `lightBulb`.

## Apply a Symbol

```dart
final hint = HintSymbol.arrow.apply('Run tests next');
```

This produces text equivalent to:

```text
→ Run tests next
```

## Inline Spacing

Use `withSpacing` when the symbol itself is needed before another value:

```dart
final prefix = HintSymbol.dot.withSpacing;
```

`needsSpacing` reports whether the symbol is non-empty.
