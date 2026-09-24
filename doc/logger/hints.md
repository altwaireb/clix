# Hints

Hints add secondary guidance to a message. They can be combined with plain messages, icons, or marks.

## Example

```dart
logger.errorMarkWithHint(
  'Build failed',
  hint: 'Run `dart analyze` for details',
);
```

## Hint Methods

- `messageWithHint()`
- `messageIconWithHint()`
- `messageMarkWithHint()`
- `successWithHint()`
- `successIconWithHint()`
- `successMarkWithHint()`
- `errorWithHint()`
- `errorIconWithHint()`
- `errorMarkWithHint()`
- `warnWithHint()`
- `warnIconWithHint()`
- `warnMarkWithHint()`
- `infoWithHint()`
- `infoIconWithHint()`
- `infoMarkWithHint()`
- `primaryWithHint()`
- `secondaryWithHint()`
- `whiteWithHint()`

## Shared Hint Options

The hint APIs can use:

- `hint`
- `indent`
- `hintColor`
- `spacing`
- `hintSymbol`

Methods that combine a hint with an icon or mark additionally accept the corresponding icon/mark options.

## Hint Symbols

`HintSymbol` provides the symbol used before the hint. The default is `HintSymbol.dot`.
