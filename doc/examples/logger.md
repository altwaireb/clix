# Logger

This example shows several different Logger output forms without repeating
every method individually.

```dart
final logger = CliLogger();

logger.success('Build completed');

logger.errorMark(
  'Build failed',
  indent: IndentLevel.level2,
);

logger.pointWarnWithHint(
  'Configuration warning',
  hint: 'Using default configuration',
);

logger.errorIconWithHint(
  'Request failed',
  hint: 'HTTP 500',
);

logger.lines([
  'First line',
  'Second line',
]);
```

For the complete Logger API and the available method groups, see
[Logger](../logger/README.md).
