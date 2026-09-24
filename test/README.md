# Clix Tests

This directory contains the test suite for the Clix CLI library.

## Structure

```text
test/

├── args/                       # Argument parser and command tests
│   └── ...
│
├── helpers/                    # Shared test helpers
│   ├── mock_io.dart
│   └── test_utils.dart
│
├── manual/                     # Manual and platform-specific tests
│   └── ...
│
├── unit/                       # Unit tests
│   ├── core/                   # Core components
│   │   ├── icons/
│   │   ├── io/
│   │   ├── keyboard/
│   │   └── terminal/
│   │
│   ├── logger/                 # Logger tests
│   │   └── cli_logger_test.dart
│   │
│   ├── progress/               # Progress and spinner tests
│   │   ├── multi_spinner_test.dart
│   │   ├── progress_test.dart
│   │   └── spinner_test.dart
│   │
│   └── prompts/                # Prompt tests
│       ├── confirm_prompt_test.dart
│       ├── decimal_prompt_test.dart
│       ├── input_prompt_test.dart
│       ├── multi_select_prompt_test.dart
│       ├── number_prompt_test.dart
│       ├── search_prompt_test.dart
│       └── select_prompt_test.dart
│
├── clix_test.dart              # Main test runner
└── README.md                   # Test documentation
```

## Running Tests

### Run All Tests

```bash
dart test
```

### Run Specific Test Directories

```bash
dart test test/args
```

```bash
dart test test/unit/core
```

```bash
dart test test/unit/logger
```

```bash
dart test test/unit/progress
```

```bash
dart test test/unit/prompts
```

### Run a Specific Test File

```bash
dart test test/unit/prompts/input_prompt_test.dart
```

```bash
dart test test/unit/core/keyboard
```

```bash
dart test test/unit/core/terminal
```

## Test Categories

### Argument Tests

Tests for the Clix argument parsing system, including:

- Argument parsing
- Options and flags
- Commands and subcommands
- Command aliases
- Usage and help
- Argument validation
- Parser errors

### Core Tests

Tests for the core Clix components, including:

- Icons and marks
- Input and output
- Keyboard input
- Terminal control
- Terminal state
- Cross-platform keyboard behavior

### Logger Tests

Tests for the Clix logger, including:

- Log levels
- Messages
- Formatting
- Colors
- Hints
- Icons
- Marks
- Indentation
- Logger output

### Progress Tests

Tests for progress-related components, including:

- Progress indicators
- Spinners
- Multiple spinners
- Spinner styles
- Task status
- Progress updates

### Prompt Tests

Tests for interactive prompts, including:

- Input
- Confirm
- Select
- Multi-select
- Number
- Decimal
- Search
- Password

Prompt tests cover input handling, validation, keyboard interaction, terminal output, and confirmation behavior where applicable.

### Manual Tests

Manual tests are used for scenarios that require direct interaction with the terminal or platform-specific behavior.

These tests are useful for verifying behavior that cannot be fully represented by automated unit tests.

## Test Helpers

Shared testing utilities are located in:

```text
test/helpers/
```

### MockIO

`MockIO` provides an in-memory implementation of `CliIO` for testing input and output without requiring a real terminal.

Example:

```dart
final mockIO = MockIO();
mockIO.addInput('test input');
```

### TestUtils

`TestUtils` provides common assertions and helpers used across the test suite.

Example:

```dart
final mockIO = TestUtils.createMockIO(
  inputs: ['test input'],
);
```

## Naming Convention

Test files follow the same naming convention as the source files they test.

```text
lib/src/prompt/input_prompt.dart
test/unit/prompts/input_prompt_test.dart
```

```text
lib/src/prompt/multi_select_prompt.dart
test/unit/prompts/multi_select_prompt_test.dart
```

Test files use the following naming convention:

```text
{component}_test.dart
```

Test groups should describe the component being tested:

```dart
group('Input Tests', () {
  // ...
});
```

Test cases should describe the expected behavior:

```dart
test('should return user input', () {
  // ...
});
```

## Test Structure

Tests should generally follow the Arrange, Act, Assert pattern.

```dart
test('should return user input', () async {
  // Arrange
  final mockIO = TestUtils.createMockIO(
    inputs: ['test'],
  );

  final prompt = Input(
    'Question',
  );

  // Act
  final result = await prompt.run(
    mockIO,
    theme,
  );

  // Assert
  expect(result, equals('test'));
});
```

## Running Tests During Development

A typical development workflow is:

```bash
dart format lib test
dart analyze
dart test
```

For a focused change, run the relevant test suite first:

```bash
dart test test/unit/prompts
```

Then run the complete test suite:

```bash
dart test
```

## Coverage

Generate a coverage report with:

```bash
dart test --coverage=coverage
```

Additional coverage tooling can be used to generate an LCOV report when required.

## Debugging Tests

Run a specific test file when investigating a failure:

```bash
dart test test/unit/prompts/input_prompt_test.dart
```

For platform-specific behavior, use the relevant manual tests under:

```text
test/manual/
```

## Test Requirements

Before submitting changes, make sure that:

1. Tests pass with `dart test`.
2. Static analysis passes with `dart analyze`.
3. Code is formatted with `dart format`.
4. New functionality has appropriate tests.
5. Existing tests are updated when behavior or APIs change.
6. Test file names match the corresponding source file names.
