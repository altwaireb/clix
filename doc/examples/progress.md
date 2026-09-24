# Progress

Use `Progress` when the total amount of work is known.

```dart
final progress = Progress(
  total: 100,
);

for (var i = 0; i <= 100; i++) {
  progress.update(i);
}

progress.complete();
```

Use `Spinner` when the duration is unknown:

```dart
final spinner = Spinner('Building...');

// Perform work...

spinner.complete();
```

Use `MultiSpinner` when several tasks need to be displayed together:

```dart
final spinner = MultiSpinner();

spinner.add('build', 'Building');
spinner.add('test', 'Running tests');

spinner.startTask('build');
// ...

spinner.complete('build');

spinner.startTask('test');
// ...

spinner.complete('test');
```

See [Progress](../progress/README.md) for the complete API.
