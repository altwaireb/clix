# 🧪 Clix Tests

This directory contains comprehensive tests for the Clix CLI library.

## 📁 Structure

```
test/
├── helpers/                    # Test utilities and mocks
│   ├── mock_io.dart           # Mock IO implementation
│   └── test_utils.dart        # Testing helper functions
├── unit/                      # Unit tests
│   ├── prompts/               # Tests for each prompt type
│   │   ├── input_prompt_test.dart
│   │   ├── confirm_prompt_test.dart
│   │   ├── select_prompt_test.dart
│   │   ├── multiselect_prompt_test.dart
│   │   ├── number_prompt_test.dart
│   │   ├── decimal_prompt_test.dart
│   │   └── search_prompt_test.dart
│   └── core/                  # Tests for core components
│       ├── style_test.dart
│       ├── theme_test.dart
│       └── io_test.dart
├── integration/               # Integration tests
│   └── full_workflow_test.dart
├── all_tests.dart            # Main test runner
└── dart_test.yaml           # Test configuration
```

## 🚀 Running Tests

### Run All Tests
```bash
dart test
```

### Run Specific Test Suites
```bash
# Unit tests only
dart test -P unit

# Integration tests only  
dart test -P integration

# Prompt tests only
dart test -P prompts

# Core component tests only
dart test -P core
```

### Run Individual Test Files
```bash
# Test a specific prompt
dart test test/unit/prompts/input_prompt_test.dart

# Test with coverage
dart test --coverage=coverage
```

## 📋 Test Categories

### Unit Tests
- **Prompt Tests**: Each prompt type (Input, Confirm, Select, etc.)
- **Core Tests**: Style, Theme, IO components
- **Validation**: Input validation and error handling

### Integration Tests  
- **Full Workflows**: Complete user interactions
- **Error Scenarios**: Edge cases and error handling
- **Performance**: Response time and memory usage

## 🎯 Writing New Tests

### 1. Use Test Helpers
```dart
import '../../helpers/mock_io.dart';
import '../../helpers/test_utils.dart';

// Create mock IO with predefined inputs
final mockIO = TestUtils.createMockIO(inputs: ['test input']);

// Check outputs
TestUtils.expectConfirmation(mockIO, 'Question', 'Answer');
```

### 2. Follow Naming Convention
- Test files: `{component}_test.dart`
- Test groups: `'{Component} Tests'`
- Test cases: `'should {expected behavior}'`

### 3. Structure Tests with AAA Pattern
```dart
test('should return user input', () async {
  // Arrange
  mockIO.addInput('test');
  final prompt = Input('Question');
  
  // Act
  final result = await prompt.run(mockIO, theme);
  
  // Assert
  expect(result, equals('test'));
});
```

## 🔧 Test Configuration

The `dart_test.yaml` file configures:
- Timeouts for different test types
- Test paths and presets
- Platform settings

## 📊 Coverage

Generate coverage reports:
```bash
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## 🐛 Debugging Tests

Run specific tests in debug mode:
```bash
dart test test/unit/prompts/input_prompt_test.dart --pause-after-load
```