# Table

`CliLogger.table()` creates a `Table` configured with the logger's theme.

## Example

```dart
final table = Table(
  columns: [
    TableColumn('Name'),
    TableColumn('Version'),
    TableColumn('Status'),
  ],
  rows: [
    ['Clix', '2.0.0', 'Stable'],
    ['Dart', '3.8.2', 'Stable'],
  ],
);

logger.plain(table.render());
```

## `CliLogger.table()`

```dart
Table table({
  required List<TableColumn> columns,
  required List<List<String>> rows,
  bool showBorders = true,
  CliTheme? theme,
})
```

The logger passes its theme by default. Set `theme` explicitly when a different theme is required.

## `TableColumn`

```dart
TableColumn(
  'Name',
  alignment: TableAlignment.left,
  width: 20,
)
```

Available properties:

- `header`
- `alignment`
- `width`

## `TableAlignment`

- `left`
- `center`
- `right`

## `Table`

The `Table` constructor accepts:

- `columns`
- `rows`
- `headerStyle`
- `borderStyle`
- `theme`
- `showBorders`

Use `render()` to produce the final table string.

When a column width is not supplied, the table calculates it from the header and row contents. Missing cells are rendered as empty strings.
