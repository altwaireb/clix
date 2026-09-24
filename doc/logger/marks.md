# Marks

Clix uses `CliMarks` for text-based symbols. Marks are separate from pictorial `CliIcons`.

## Example

```dart
logger.errorMark(
  'Build failed',
  indent: IndentLevel.level2,
);
```

## Mark Logging Methods

- `withMark()`
- `successMark()`
- `errorMark()`
- `warnMark()`
- `infoMark()`
- `plusMark()`
- `minusMark()`
- `messageMarkWithHint()`
- `successMarkWithHint()`
- `errorMarkWithHint()`
- `warnMarkWithHint()`
- `infoMarkWithHint()`

## `CliMarks`

Available marks:

`bullet`, `dash`, `check`, `cross`, `plus`, `minus`, `arrow`, `arrowUp`, `arrowDown`, `arrowLeft`, `arrowRight`, `star`, `diamond`, `circle`, `square`, `triangle`, `dot`, `info`, `warning`.

## Indentation

Mark methods that support indentation accept `IndentLevel`:

`none`, `level1`, `level2`, `level3`, `level4`, `level5`.

Each level adds two spaces.
