## 1.2.0

### ✨ New Features

- **ValidationRules System**: New fluent API for building validation chains
  ```dart
  validator: ValidationRules().required().min(8).email()
  ```
- **Validator.rules()**: Array-based validation approach for complex scenarios
- **15+ Built-in Rules**: `required()`, `min()`, `max()`, `email()`, `url()`, `pattern()`, `custom()`, etc.
- **Backward Compatibility**: Existing validator functions continue to work

### 🎨 Enhancements

- **Improved Documentation**: Cleaner examples and better organization
- **Enhanced Type Safety**: Better error handling across validation methods

## 1.1.0

### ✨ New Features

- **Messages with Hints System**: 13 new methods for displaying messages with contextual guidance
- **Core Methods**: `messageWithHint()`, `messageIconWithHint()` 
- **Specialized Methods**: `successWithHint()`, `errorWithHint()`, `warnWithHint()`, `infoWithHint()` (with icon variants)
- **Color Methods**: `primaryWithHint()`, `secondaryWithHint()`, `whiteWithHint()`
- **Spacing Enum**: 6 levels (none to huge) for flexible spacing control
- **HintSymbol Enum**: 12 symbols (dot, arrow, lightBulb, star, info, etc.)

## 1.0.0

- Initial version.
