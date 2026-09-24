# Logger

`CliLogger` is Clix's main output API for styled terminal messages, marks, icons, points, hints, trees, tables, and progress helpers.

The logger is designed around a few clear output families. In this page, each family has a representative example followed by the available methods. Detailed behavior and parameters are documented in the linked pages.

## Quick Start

```dart
import 'package:clix/clix.dart';

final logger = CliLogger();

logger.success('Build completed');
```

For custom configuration, `CliLogger` accepts `CliIO`, `CliTheme`, `CliFormatter`, `minimumLevel`, and `showTimestamps`.

---

## Messages

Use message methods when the output itself is the primary information.

```dart
logger.success('Build completed');
```

**Message Methods**: `debug()`, `info()`, `warn()`, `error()`, `success()`, `plain()`.

See [Messages](messages.md).

## Colors

Use color methods when you want direct styled output rather than a log-level message.

```dart
logger.primary('Building Clix...');
```

**Color Methods**: `result()`, `primary()`, `secondary()`, `white()`, `red()`, `green()`, `blue()`, `yellow()`, `cyan()`.

See [Colors](colors.md).

## Backgrounds

Use background methods when the message should be rendered with a colored background.

```dart
logger.onError(
  'Build failed',
  padding: Padding.horizontal(1),
);
```

**Background Methods**: `onBackground()`, `onRed()`, `onGreen()`, `onBlue()`, `onYellow()`, `onWhite()`, `onBlack()`, `onCyan()`, `onMagenta()`, `onSuccess()`, `onError()`, `onWarn()`, `onInfo()`, `onPrimary()`, `onDarkRed()`, `onDeepRed()`, `onMaroon()`.

See [Colors](colors.md) for the color and background API.

## Icons

Use icons for pictorial status and contextual output.

```dart
logger.errorIconWithHint(
  'Request failed',
  hint: 'HTTP 500',
);
```

**Icon Methods**: `withIcon()`, `withIconCustom()`, `successIcon()`, `errorIcon()`, `warnIcon()`, `infoIcon()`, `ideaIcon()`, `messageIconWithHint()`, `successIconWithHint()`, `errorIconWithHint()`, `warnIconWithHint()`, `infoIconWithHint()`.

See [Icons](icons.md).

## Marks

Use text-based marks for compact status and list output.

```dart
logger.errorMark(
  'Build failed',
  indent: IndentLevel.level2,
);
```

**Mark Logging Methods**: `withMark()`, `successMark()`, `errorMark()`, `warnMark()`, `infoMark()`, `plusMark()`, `minusMark()`, `messageMarkWithHint()`, `successMarkWithHint()`, `errorMarkWithHint()`, `warnMarkWithHint()`, `infoMarkWithHint()`.

See [Marks](marks.md).

## Points

Use points for list-style output and short status entries.

```dart
logger.pointWarnWithHint(
  'Configuration warning',
  hint: 'Using default configuration',
);
```

**Point Methods**: `point()`, `pointSuccess()`, `pointError()`, `pointWarn()`, `pointInfo()`, `pointPrimary()`, `pointSecondary()`, `pointGray()`, `pointArrow()`, `pointCustom()`, `pointWithHint()`, `pointSuccessWithHint()`, `pointErrorWithHint()`, `pointWarnWithHint()`, `pointInfoWithHint()`, `pointPrimaryWithHint()`, `pointSecondaryWithHint()`, `treePoint()`.

See [Points](points.md).

## Trees

Use tree output for hierarchical information.

```dart
logger.tree('src/');
```

**Tree Methods**: `tree()`, `treeWithIcon()`, `treePoint()`.

See [Points](points.md) for tree and point output.

## Hints

Hints add secondary guidance to an existing message, icon, or mark.

```dart
logger.errorMarkWithHint(
  'Build failed',
  hint: 'Run `dart analyze` for details',
);
```

**Hint Methods**: `messageWithHint()`, `messageIconWithHint()`, `messageMarkWithHint()`, `successWithHint()`, `successIconWithHint()`, `successMarkWithHint()`, `errorWithHint()`, `errorIconWithHint()`, `errorMarkWithHint()`, `warnWithHint()`, `warnIconWithHint()`, `warnMarkWithHint()`, `infoWithHint()`, `infoIconWithHint()`, `infoMarkWithHint()`, `primaryWithHint()`, `secondaryWithHint()`, `whiteWithHint()`.

See [Hints](hints.md).

## Multiple Lines

Use `lines()` when several messages should be written using one log level and shared output options.

```dart
logger.lines(
  ['Installing dependencies...', 'Running tests...', 'Build completed'],
  level: LogLevel.info,
);
```

**Method**: `lines()`.

See [Messages](messages.md).

## Prompt Results

Use the result helpers when displaying completed prompt answers.

```dart
logger.promptResult('Name', 'Clix');
```

**Prompt Result Methods**: `promptResult()`, `multiPromptResult()`.

See [Messages](messages.md).

## New Lines and Raw Output

```dart
logger.newLine(2);
logger.output('Raw output');
```

**Utility Methods**: `newLine()`, `output()`.

See [Messages](messages.md).

## Tables

`CliLogger` provides a table helper that automatically inherits the logger theme.

```dart
final table = logger.table(
  columns: [
    TableColumn('Name'),
    TableColumn('Status', alignment: TableAlignment.center),
    TableColumn('Time', alignment: TableAlignment.right),
  ],
  rows: [
    ['Server', 'Running', '2.3s'],
  ],
);

print(table.render());
```

**Table API**: `table()` and the `Table` / `TableColumn` types.

See [Table](table.md).

## Progress Helpers

The logger can create progress components that inherit its `CliTheme` and `CliIO`.

```dart
final progress = logger.progress(total: 100);
progress.update(50);
progress.complete();
```

**Progress Methods**: `progress()`, `spinner()`, `multiSpinner()`.

See [Progress](../progress/README.md) for the complete progress API.

## Log Levels

`CliLogger` uses `LogLevel` to filter level-based messages.

```dart
final logger = CliLogger(
  minimumLevel: LogLevel.info,
);
```

**Log Levels**: `plain`, `debug`, `info`, `warning`, `error`, `success`.

See [Messages](messages.md).

## Indentation

Logger methods that support indentation use `IndentLevel`.

```dart
logger.errorMark(
  'Details',
  indent: IndentLevel.level2,
);
```

`IndentLevel` provides `none`, `level1`, `level2`, `level3`, `level4`, and `level5`.

See [Marks](marks.md) and [Points](points.md).

## Related Documentation

- [Messages](messages.md)
- [Icons](icons.md)
- [Marks](marks.md)
- [Points](points.md)
- [Hints](hints.md)
- [Colors](colors.md)
- [Table](table.md)
- [Progress](../progress/README.md)
