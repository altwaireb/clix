# Icons

Clix separates pictorial icons from text-based marks. Pictorial icons are represented by `CliIcons`.

## Example

```dart
logger.errorIconWithHint(
  'Request failed',
  hint: 'HTTP 500',
);
```

## Icon Methods

- `withIcon()`
- `withIconCustom()`
- `successIcon()`
- `errorIcon()`
- `warnIcon()`
- `infoIcon()`
- `ideaIcon()`
- `messageIconWithHint()`
- `successIconWithHint()`
- `errorIconWithHint()`
- `warnIconWithHint()`
- `infoIconWithHint()`

## `CliIcons`

Available icons:

`success`, `error`, `warning`, `info`, `idea`, `file`, `folder`, `rocket`, `build`, `test`, `deploy`, `search`, `lock`, `key`, `user`, `database`, `link`, `trash`.

For text-based symbols such as `✓`, `✗`, and `ⓘ`, use [Marks](marks.md) and `CliMarks` instead.
