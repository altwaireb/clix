# MultiSpinner

`MultiSpinner` manages multiple tasks and renders their states together.

It is useful when an operation consists of several independent or sequential tasks.

## Basic Usage

```dart
final spinner = MultiSpinner();

spinner.add('build', 'Building');
spinner.add('test', 'Running tests');

spinner.startTask('build');
// Perform build...

spinner.complete('build');

spinner.startTask('test');
// Perform tests...

spinner.complete('test');
```

A task is initially `pending`.

When `startTask()` is called, it becomes `running`.

When `complete()` or `fail()` is called, it reaches a final state.

## Constructor

```dart
MultiSpinner({
  CliLogger? logger,
  CliTheme? theme,
  Duration interval = const Duration(milliseconds: 100),
  SpinnerType type = SpinnerType.dots,
})
```

### `logger`

Optional `CliLogger` used for the final message passed to `completeAll()`.

### `theme`

Optional `CliTheme`.

The default is `CliTheme.defaultTheme()`.

The running-task spinner frame uses the theme's primary color.

### `interval`

Time between animation frames.

Default:

```dart
const Duration(milliseconds: 100)
```

### `type`

Animation type used for running tasks.

Default:

```dart
SpinnerType.dots
```

## `add()`

Add a task:

```dart
spinner.add('build', 'Building project');
```

Arguments:

- `id` — unique identifier used by later task operations.
- `message` — displayed task message.

Adding the first task automatically starts the spinner.

## `startTask()`

Start a task:

```dart
spinner.startTask('build');
```

The task becomes:

```text
TaskStatus.running
```

Its start time is recorded.

Calling `startTask()` with an unknown ID does nothing.

## `complete()`

Mark a task as completed:

```dart
spinner.complete('build');
```

Optionally replace its message:

```dart
spinner.complete(
  'build',
  'Build completed',
);
```

The task becomes `TaskStatus.completed` and its end time is recorded.

If every task is finished, the spinner stops automatically.

## `fail()`

Mark a task as failed:

```dart
spinner.fail('test');
```

Optionally replace its message:

```dart
spinner.fail(
  'test',
  'Tests failed',
);
```

The task becomes `TaskStatus.failed`.

If every task is finished, the spinner stops automatically.

## `completeAll()`

Complete all remaining `pending` and `running` tasks:

```dart
spinner.completeAll();
```

You can also provide a final message:

```dart
spinner.completeAll('All tasks completed');
```

### Icon

By default, a final message with an icon uses:

```dart
CliIcons.rocket
```

```dart
spinner.completeAll(
  'Deployment completed',
);
```

### Disable the Icon

Pass `withIcon: false`:

```dart
spinner.completeAll(
  'Deployment completed',
  false,
);
```

### Custom Icon

Provide a `CliIcons` value:

```dart
spinner.completeAll(
  'Deployment completed',
  true,
  CliIcons.rocket,
);
```

If a `CliLogger` was provided, the final message is written through it. Otherwise `MultiSpinner` writes the final output directly.

## `updateMessage()`

Change a task's message:

```dart
spinner.updateMessage(
  'build',
  'Compiling sources...',
);
```

Calling it with an unknown ID does nothing.

## `start()`

Starts the animation if it is not active.

```dart
spinner.start();
```

The terminal cursor is hidden while active.

## `stop()`

Stops the animation and restores the terminal cursor:

```dart
spinner.stop();
```

## Task Elapsed Time

A running task tracks its start time.

Completed or failed tasks keep their end time, so their elapsed time remains stable.

The displayed format is:

```text
(1.2s)
```

## Task Lifecycle

```text
pending
   │
   ▼
running
  /   \
 ▼     ▼
completed   failed
```

## Example

```dart
final spinner = MultiSpinner(
  type: SpinnerType.dots,
);

spinner.add('download', 'Downloading');
spinner.add('extract', 'Extracting');
spinner.add('install', 'Installing');

spinner.startTask('download');
// ...

spinner.complete('download');

spinner.startTask('extract');
// ...

spinner.complete('extract');

spinner.startTask('install');
// ...

spinner.complete('install');
```
