# Task Status

`TaskStatus` represents the lifecycle state of a `MultiSpinner` task.

## `pending`

The task has been added but has not started.

```dart
TaskStatus.pending
```

This is the initial state created by:

```dart
spinner.add('build', 'Building');
```

## `running`

The task is currently being executed.

```dart
TaskStatus.running
```

Set by:

```dart
spinner.startTask('build');
```

The running task displays an animated spinner frame.

## `completed`

The task finished successfully.

```dart
TaskStatus.completed
```

Set by:

```dart
spinner.complete('build');
```

The displayed indicator is `✓`.

## `failed`

The task finished with an error.

```dart
TaskStatus.failed
```

Set by:

```dart
spinner.fail('build');
```

The displayed indicator is `✗`.

## Lifecycle

The intended task lifecycle is:

```text
pending → running → completed
                  ↘ failed
```

A task can also be completed directly through `completeAll()`, which completes remaining pending and running tasks.
