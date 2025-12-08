# Clix

<div align="center">
  <img src="https://raw.githubusercontent.com/altwaireb/clix/main/assets/logo.svg" alt="Clix Logo" height="80">
</div>

<div align="center">

> A comprehensive CLI development toolkit for Dart - Build beautiful, interactive command-line applications with ease.

[![Pub Version](https://img.shields.io/pub/v/clix)](https://pub.dev/packages/clix)
[![Dart CI](https://github.com/altwaireb/clix/workflows/Dart%20CI/badge.svg)](https://github.com/altwaireb/clix/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub Points](https://img.shields.io/pub/points/clix)](https://pub.dev/packages/clix/score)

</div>

## Features

- **🎯 Unified Solution** - All CLI tools in one package, no multiple dependencies needed
- **💪 Type Safe** - Full Dart null safety with comprehensive type support  
- **🧪 Testing Ready** - Built-in mock I/O for easy testing, unlike manual setup alternatives
- **🛡️ Production Ready** - Clix is fully tested with more than 460 automated tests, ensuring stability, predictable behavior, and production-ready performance
- **✅ Rich Validation** - Flexible validator system for all input types
- **⚡ Modern API** - Clean `.interact()` syntax throughout, not verbose method calls
- **🔢 Smart Numbers** ⭐ - Dedicated `Number` and `Decimal` prompts with range validation
- **🔍 Advanced Search** ⭐ - Interactive search through large datasets with auto-completion  
- **🎨 Advanced Styling** - Colors, themes, and sophisticated text formatting
- **📝 Smart Logging** - Multi-level logging with timestamps and visual indicators
- **⚙️ Config Management** - JSON/YAML with automatic validation, not manual file handling
- **🎬 Progress Indicators** - Spinners and progress bars with full customization
- **📊 Data Display** - Beautiful tables and structured output formatting

## Quick Start

```bash
dart pub add clix
```

Or add to your `pubspec.yaml`:

```yaml
dependencies:
  clix: ^1.1.0
```

```dart
import 'package:clix/clix.dart';

void main() async {
  // Interactive prompts
  final name = await Input('Enter your name').interact();
  final confirmed = await Confirm('Continue?').interact();
  
  // Logging with style
  final logger = CliLogger.defaults();
  logger.success('Welcome $name!');
  
  // Progress indication
  final spinner = Spinner('Processing...');
  spinner.start();
  await Future.delayed(Duration(seconds: 2));
  spinner.complete('Done!');
}
```

## Interactive Prompts

> ⭐ **Unique Features**: `Number`, `Decimal`, and `Search` prompts are exclusive to Clix - not found in other CLI packages!

<!-- ![Basic Prompts Demo](https://raw.githubusercontent.com/altwaireb/clix/main/assets/gifs/basic-prompts.gif) -->

### Confirm

```dart
// Basic confirmation
final proceed = await Confirm('Continue with installation?').interact();

// With default value
final useDefaults = await Confirm(
  'Use default settings?',
  defaultValue: true, // Press Enter = Yes
).interact();
```

### Decimal ⭐

```dart
// Floating-point input with precision control
final price = await Decimal(
  'Enter price',
  min: 0.0,
  max: 999.99,
  defaultValue: 10.0,
).interact();
```

### Input

```dart
// Basic input
final name = await Input('Enter your name').interact();

// With validation
final email = await Input(
  'Email address',
  validator: (value) {
    if (!value.contains('@')) return 'Invalid email format';
    return null;
  },
).interact();

// With default value
final username = await Input(
  'Username',
  defaultValue: 'guest',
).interact();
```

![Basic Prompts Demo](https://raw.githubusercontent.com/altwaireb/clix/main/assets/gifs/prompts_demo.gif)

### MultiSelect

```dart
// Multiple selection
final features = await MultiSelect(
  'Select features:',
  ['Auth', 'Database', 'API', 'Testing'],
  defaults: [0, 3], // Pre-select first and fourth
).interact();
```

### Number ⭐

```dart
// Integer input with built-in range validation
final age = await Number(
  'Enter your age',
  min: 0,
  max: 120,
  defaultValue: 25,
).interact();
```

### Password

```dart
// Basic password
final password = await Password('Enter password').interact();

// With confirmation and validation
final newPassword = await Password(
  'Create password',
  validator: (pwd) => pwd.length < 8 ? 'At least 8 characters' : null,
  confirmation: true,
).interact();
```

### Search ⭐

![Search Prompt Demo](https://raw.githubusercontent.com/altwaireb/clix/main/assets/gifs/search_demo.gif)

```dart
// Search in static list with auto-selection
final country = await Search(
  'Search country',
  options: ['USA', 'UK', 'Germany', 'France', 'Japan'],
).interact();

// Search with dynamic function (API calls, databases, etc.)
final result = await Search(
  'Search users',
  options: (query) async {
    return await searchUsers(query); // Returns List<String>
  },
  minQueryLength: 2,
  maxResults: 5,
).interact();
```

### Select

```dart
// Single selection
final framework = await Select('Choose framework:', [
  'Flutter', 'React Native', 'Ionic', 'Xamarin'
]).interact();

// With default selection
final env = await Select(
  'Environment:',
  ['Development', 'Staging', 'Production'],
  defaultIndex: 0,
).interact();
```

## Styling and Colors

### Basic Colors

```dart
print(CliColor.red('Error message'));
print(CliColor.green('Success'));
print(CliColor.blue('Information'));
print(CliColor.yellow('Warning'));

// Custom colors
print(CliColor.rgb(255, 100, 50)('Custom orange'));
print(CliColor.hex('#FF6B35')('Hex color'));
```

### Advanced Styling

```dart
final style = CliStyle()
    .withColor(CliColor.cyan)
    .makeBold()
    .makeUnderline();

print(style.format('Styled text'));

// Using themes
final theme = CliTheme.defaultTheme();
print(theme.success('Operation completed'));
print(theme.error('Something went wrong'));
```

## Logging

![Logger Features Demo](https://raw.githubusercontent.com/altwaireb/clix/main/assets/gifs/logger_demo.gif)

```dart
// Quick setup and usage
final logger = CliLogger.defaults();
logger.info('App started');
logger.successIcon('Task completed successfully');
logger.onSuccess('Operation finished', padding: Padding.medium);

// Messages with helpful hints
logger.successWithHint('Build completed', hint: 'Run tests with: dart test');
logger.errorWithHint('Connection failed', hint: 'Check network settings');
logger.primaryWithHint('Welcome!', hint: 'Type help for commands', 
  spacing: Spacing.large, hintSymbol: HintSymbol.lightBulb);
```

### Setup

- `CliLogger.defaults()` - Simple logger with default settings
- `CliLogger.create(showTimestamps: true, minimumLevel: LogLevel.info)` - Custom configuration

### Core Methods

- `debug()` - Debug information (filtered in production)
- `info()` - General information and status updates  
- `warn()` - Warnings and potential issues
- `error()` - Critical errors and failures
- `success()` - Positive outcomes and completions
- `plain()` - Unstyled raw output

### Color Methods

- `red()` - Red text
- `green()` - Green text
- `blue()` - Blue text
- `yellow()` - Yellow text
- `cyan()` - Cyan text
- `white()` - White text
- `primary()` - Primary theme color
- `secondary()` - Secondary theme color

### Messages with Hints ⭐

Display messages with additional guidance and context using customizable spacing and symbols:

```dart
// Basic usage with default gray hints
logger.successWithHint('Build completed', hint: 'Run tests next');
logger.errorWithHint('Connection failed', hint: 'Check network settings');

// With custom spacing and symbols
logger.primaryWithHint(
  'Welcome to App',
  hint: 'Type help for commands',
  spacing: Spacing.large,
  hintSymbol: HintSymbol.lightBulb,
);
```

#### Core Hint Methods

- `messageWithHint()` - Custom message with hint
- `messageIconWithHint()` - Custom message with icon and hint

#### Level-Based Hint Methods

- `successWithHint()` - Success message with guidance
- `successIconWithHint()` - Success with ✅ icon and hint
- `errorWithHint()` - Error message with troubleshooting
- `errorIconWithHint()` - Error with ❌ icon and hint
- `warnWithHint()` - Warning with recommendations  
- `warnIconWithHint()` - Warning with ⚠️ icon and hint
- `infoWithHint()` - Information with context
- `infoIconWithHint()` - Info with ℹ️ icon and hint

#### Color-Specific Hint Methods

- `primaryWithHint()` - Primary color message with hint
- `secondaryWithHint()` - Secondary color message with hint
- `whiteWithHint()` - White color message with hint

#### Hint Symbols

- `HintSymbol.dot` (•) - Clean and minimal
- `HintSymbol.arrow` (→) - Next action indicator
- `HintSymbol.lightBulb` (💡) - Tips and suggestions
- `HintSymbol.star` (★) - Important highlights
- `HintSymbol.info` (ℹ) - Informational hints
- Plus 7 more symbols: `dash`, `pipe`, `chevron`, `diamond`, `triangle`, `doubleArrow`, `none`

#### Spacing Levels

- `Spacing.none` - No spacing (0)
- `Spacing.small` - 2 spaces between message and hint
- `Spacing.medium` - 4 spaces (default)
- `Spacing.large` - 6 spaces
- `Spacing.extraLarge` - 8 spaces
- `Spacing.huge` - 10 spaces

### Background Colors

- `onRed()` - Red background
- `onGreen()` - Green background
- `onBlue()` - Blue background
- `onYellow()` - Yellow background
- `onWhite()` - White background
- `onBlack()` - Black background
- `onSuccess()` - Success background
- `onError()` - Error background
- `onWarning()` - Warning background
- `onInfo()` - Info background

### Icon Methods

- `successIcon()` - Success message with ✅ icon
- `errorIcon()` - Error message with ❌ icon
- `warnIcon()` - Warning message with ⚠️ icon
- `infoIcon()` - Info message with ℹ️ icon
- `ideaIcon()` - Tip message with 💡 icon
- `withIcon(message, icon: CliIcons.star)` - Custom predefined icon
- `withIconCustom(message, icon: '🚀')` - Custom emoji icon

### Structure and Formatting

- `tree()` - Tree structure with symbols
- `point()` - Bullet points and lists
- `lines()` - Multiple lines with same level
- `newLine()` - Empty line spacing
- `promptResult()` - Display prompt results
- All methods support `indent: IndentLevel.level1` parameter

### Progress Integration

- `logger.progress(total: 100)` - Create progress bar
- `logger.spinner('Loading...')` - Create spinner
- `logger.multiSpinner()` - Create multi-spinner
- `logger.table()` - Create formatted table

## Configuration Management

### JSON Configuration

```dart
final config = CliConfig.fromJson('config.json');
await config.load();

final apiUrl = config.getValue<String>('api.url');
final timeout = config.getValue<int>('api.timeout', defaultValue: 30);
final features = config.getValue<List>('features', defaultValue: []);

// Validation
final errors = config.validate();
if (errors.isNotEmpty) {
  logger.error('Config errors: ${errors.join(', ')}');
}
```

### YAML Configuration

```dart
final config = CliConfig.fromYaml('database.yaml');
await config.load();

final host = config.getValue<String>('database.host');
final port = config.getValue<int>('database.port');
```

## Progress Indicators

![Progress Demo](https://raw.githubusercontent.com/altwaireb/clix/main/assets/gifs/spinner_demo.gif)

### Spinners

```dart
final spinner = Spinner('Loading data...');
spinner.start();

// Update message
spinner.update('Processing...');
await Future.delayed(Duration(seconds: 2));

// Complete
spinner.complete('Data loaded successfully');
// or spinner.fail('Failed to load data');
```

### Spinner Types

```dart
Spinner('Working...', type: SpinnerType.dots);   // ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏
Spinner('Working...', type: SpinnerType.line);   // |/-\
Spinner('Working...', type: SpinnerType.pipe);   // ┤┘┴└├┌┬┐
Spinner('Working...', type: SpinnerType.star);   // ✶✸✹✺✹✷
```

## Testing

```dart
import 'package:test/test.dart';
import 'package:clix/clix.dart';

test('prompt interaction', () async {
  final mockIO = MockIO();
  final theme = CliTheme.defaultTheme();
  
  // Setup mock responses
  mockIO.setInput(['John Doe', 'y']);
  
  // Test prompts
  final name = await Input('Name').interact(mockIO, theme);
  final confirmed = await Confirm('Continue?').interact(mockIO, theme);
  
  expect(name, equals('John Doe'));
  expect(confirmed, isTrue);
  
  // Verify output
  final output = mockIO.getOutput();
  expect(output, contains('Name:'));
});
```

## Complete Example

```dart
import 'package:clix/clix.dart';

void main() async {
  final logger = CliLogger.defaults();
  
  logger.primary('Project Setup Wizard');
  logger.newLine();
  
  try {
    // Gather information
    final projectName = await Input(
      'Project name',
      validator: (name) {
        if (name.isEmpty) return 'Name required';
        if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name)) {
          return 'Invalid format';
        }
        return null;
      },
    ).interact();
    
    final framework = await Select('Framework:', [
      'Flutter', 'Dart Console', 'Web App'
    ]).interact();
    
    final features = await MultiSelect(
      'Features:',
      ['Auth', 'Database', 'API', 'Testing'],
      defaults: [3], // Pre-select Testing
    ).interact();
    
    // Confirm and create
    final shouldCreate = await Confirm(
      'Create project with these settings?'
    ).interact();
    
    if (shouldCreate) {
      final spinner = Spinner('Creating project...');
      spinner.start();
      
      await Future.delayed(Duration(seconds: 2));
      spinner.update('Installing dependencies...');
      await Future.delayed(Duration(seconds: 1));
      
      spinner.complete('Project created! 🎉');
      
      logger.newLine();
      logger.successWithHint('Project: $projectName', 
        hint: 'Navigate with: cd $projectName');
      logger.infoWithHint('Framework: $framework', 
        hint: 'Run with: dart run');
      logger.primaryWithHint('Features: ${features.join(', ')}', 
        hint: 'Configure in pubspec.yaml', 
        spacing: Spacing.large);
    } else {
      logger.warnWithHint('Setup cancelled', 
        hint: 'Run again anytime to restart setup');
    }
    
  } catch (e) {
    logger.error('Setup failed: $e');
  }
}
```

## Examples

Run example applications:

```bash
# Basic prompts
dart example/prompts/all_prompts_example.dart

# Icon logging
dart example/prompts/icon_methods_example.dart

# Configuration
dart example/config/basic_usage.dart

# Password handling
dart example/prompts/password_example.dart
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Links

- [API Documentation](https://pub.dev/documentation/clix)
- [Issues & Bugs](https://github.com/altwaireb/clix/issues)
- [Pub Package](https://pub.dev/packages/clix)