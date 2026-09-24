# Progress

Clix provides progress indicators for terminal applications.

The Progress section contains three components:

- `Progress` — determinate progress bar when the total work is known.
- `Spinner` — animated indicator for indeterminate work.
- `MultiSpinner` — manages multiple tasks and displays their states together.

## Choosing a Progress Component

| Component | Use when |
|---|---|
| `Progress` | You know the total amount of work |
| `Spinner` | You do not know how long the operation will take |
| `MultiSpinner` | You have multiple tasks whose states should be displayed together |

## Progress

```dart
final progress = Progress(
  total: 100,
);

for (var i = 0; i <= 100; i++) {
  progress.update(i);
}

progress.complete();
```

See [Progress Bar](progress.md).

## Spinner

```dart
final spinner = Spinner('Loading...');

// Do work...

spinner.complete();
```

See [Spinner](spinner.md).

## MultiSpinner

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

See [MultiSpinner](multi-spinner.md).

## Enums

### ProgressStyle

Controls the visual representation of `Progress`:

- `basic`
- `detailed`
- `minimal`
- `clean`

See [Progress Styles](styles.md).

### SpinnerType

Controls the animation frames used by `Spinner` and `MultiSpinner`:

- `dots`
- `line`
- `pipe`
- `clock`
- `arrow`
- `triangle`
- `square`
- `circle`

See [Spinner Types](spinner-types.md).

### TaskStatus

`MultiSpinner` uses these task states:

- `pending`
- `running`
- `completed`
- `failed`

See [Task Status](task-status.md).
