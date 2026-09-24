# Points and Trees

Points provide compact list-style output. Tree methods provide hierarchical output.

## Point Example

```dart
logger.pointWarnWithHint(
  'Configuration warning',
  hint: 'Using default configuration',
);
```

## Point Methods

- `point()`
- `pointSuccess()`
- `pointError()`
- `pointWarn()`
- `pointInfo()`
- `pointPrimary()`
- `pointSecondary()`
- `pointGray()`
- `pointArrow()`
- `pointCustom()`
- `pointWithHint()`
- `pointSuccessWithHint()`
- `pointErrorWithHint()`
- `pointWarnWithHint()`
- `pointInfoWithHint()`
- `pointPrimaryWithHint()`
- `pointSecondaryWithHint()`
- `treePoint()`

## Tree Example

```dart
logger.tree('src/');
```

## Tree Methods

- `tree()`
- `treeWithIcon()`
- `treePoint()`

`tree()` and `treeWithIcon()` use `TreeSymbol` to construct hierarchical output. `TreeSymbol` supports `root` and levels 1 through 5, including `Last` variants.

## Custom Points

`pointCustom()` allows a custom `CliMarks` mark and separate mark/message colors.

## Indentation

Point methods use `IndentLevel` for nested list output.
