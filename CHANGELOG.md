## 2.0.0

### Breaking Changes

- **Native CLI Argument Parser**: Replaced `package:args` with Clix's own command-line argument parsing API.
- **Renamed Argument APIs**: Replaced `ArgParser`, `Option`, `ArgResults`, `ArgParserException`, `UsageException`, `AllowAnythingParser`, `CommandRunner`, `Command`, `HelpCommand`, and `Usage` with their Clix-prefixed equivalents.
- **Removed `PointStyle`**: Replaced `PointStyle` with `CliMarks` for point and tree output styles.
- **Updated Option API**: Removed the `allowMultiple` parameter from `addOption()`. Use `addMultiOption()` for options that accept multiple values.
- **Updated `CliIcons`**: Removed text-based marks and symbols from `CliIcons`. Use `CliMarks` for text-based CLI marks.

### New Features

- **CLI Marks**: Added `CliMarks` for text-based CLI marks and symbols.
- **Mark Logging Methods**: Added `successMark()`, `errorMark()`, `warnMark()`, `infoMark()`, `plusMark()`, and `minusMark()`.
- **Mark Hint Methods**: Added `messageMarkWithHint()` and specialized mark methods including `successMarkWithHint()`, `errorMarkWithHint()`, `warnMarkWithHint()`, and `infoMarkWithHint()`.
- **Point Hint Methods**: Added `pointWithHint()` and color-specific variants including `pointSuccessWithHint()`, `pointErrorWithHint()`, `pointWarnWithHint()`, `pointInfoWithHint()`, `pointPrimaryWithHint()`, and `pointSecondaryWithHint()`.
- **Command API**: Added `CliCommandRunner`, `CliCommand`, and `CliHelpCommand` for command and subcommand handling.
- **Usage API**: Added `CliUsage` for command-line usage generation and formatting.
- **Command Suggestions**: Added suggestions for unknown commands based on command-name similarity.
- **Allow Anything Parser**: Added `CliAllowAnythingParser` for parsers that treat all input as non-option arguments.

## 1.2.0

### New Features

- **ValidationRules System**: New fluent API for building validation chains
  ```dart
  validator: ValidationRules().required().min(8).email()
  ```
- **Validator.rules()**: Array-based validation approach for complex scenarios
- **15+ Built-in Rules**: `required()`, `min()`, `max()`, `email()`, `url()`, `pattern()`, `custom()`, etc.
- **Backward Compatibility**: Existing validator functions continue to work

### Enhancements

- **Improved Documentation**: Cleaner examples and better organization
- **Enhanced Type Safety**: Better error handling across validation methods

## 1.1.0

### New Features

- **Messages with Hints System**: 13 new methods for displaying messages with contextual guidance
- **Core Methods**: `messageWithHint()`, `messageIconWithHint()`
- **Specialized Methods**: `successWithHint()`, `errorWithHint()`, `warnWithHint()`, `infoWithHint()` (with icon variants)
- **Color Methods**: `primaryWithHint()`, `secondaryWithHint()`, `whiteWithHint()`
- **Spacing Enum**: 6 levels (none to huge) for flexible spacing control
- **HintSymbol Enum**: 12 symbols (dot, arrow, lightBulb, star, info, etc.)

## 1.0.0

- Initial version.
