# Indentation

`IndentLevel` provides consistent two-space indentation.

| Level | Spaces |
|---|---:|
| `none` | 0 |
| `level1` | 2 |
| `level2` | 4 |
| `level3` | 6 |
| `level4` | 8 |
| `level5` | 10 |

```dart
logger.info(
  'Nested message',
  indent: IndentLevel.level2,
);
```

Use `level` when the numeric level is needed and `spacing` when the indentation string is needed.

## Tree Symbols

`TreeSymbol` provides hierarchical branch symbols from the root through level 5.

```dart
print('${TreeSymbol.root.symbol}Project');
print('${TreeSymbol.level1.symbol}src/');
print('${TreeSymbol.level2.symbol}main.dart');
print('${TreeSymbol.level1Last.symbol}test/');
```
