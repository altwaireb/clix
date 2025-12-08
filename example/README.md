# Clix Examples

This directory contains comprehensive examples demonstrating the capabilities of the Clix library.

## 📚 Available Examples

### 1. `main.dart` - Main Showcase
The primary example showing all major features of Clix in action:
- Colored logging with icons
- Progress bars and spinners  
- Tables and tree formatting
- Custom themes and styling

### 2. `basic_prompts.dart` - Interactive Prompts
Demonstrates all 8 types of user input prompts:
- Input prompt (text input)
- Password prompt (hidden input)
- Confirm prompt (yes/no questions)
- Number prompt (numeric input)
- Select prompt (choose from list)
- Multi-select prompt (choose multiple)
- Search prompt (searchable list)

### 3. `live_package_search.dart` - Live API Search 🔥
**Advanced example** showing Search prompt with real-time pub.dev API:
- Live package search as you type
- Real-time results from pub.dev
- Interactive package selection
- Professional search experience
- Error handling and network requests

## 🚀 Running Examples

**Note:** The examples have their own `pubspec.yaml` with additional dependencies like `http` for API integration examples.

```bash
# From the project root directory:

# Main showcase
dart run example/main.dart

# Interactive prompts demo
dart run example/basic_prompts.dart

# Live package search (recommended!)
dart run example/live_package_search.dart
```

**Alternative:** You can also run from the example directory:
```bash
cd example
dart run main.dart
dart run basic_prompts.dart
dart run live_package_search.dart
```

## 💡 Learning Path

1. **Start with `main.dart`** - Overview of all features
2. **Try `basic_prompts.dart`** - Learn interactive inputs
3. **Explore `live_package_search.dart`** - See live API integration

## 🌟 Key Features Demonstrated

- **Dual Access Pattern**: Both convenience methods (`logger.progress()`) and direct constructors (`Progress()`)
- **Theme Inheritance**: Consistent styling across all components
- **Live API Integration**: Real-time search with external APIs
- **Error Handling**: Robust error management
- **Rich Formatting**: Tables, trees, and custom layouts
- **Interactive Elements**: Live searchable, filterable lists

## 🎯 Perfect for Learning

These examples are designed to help you understand:
- When to use each prompt type
- How to integrate with external APIs in real-time
- Best practices for CLI applications
- Theme customization and styling
- Real-world application patterns

## 🚀 Live Search Highlight

The `live_package_search.dart` example is particularly impressive:
- **Real-time search**: Results update as you type
- **Professional UX**: Smooth, responsive interface  
- **API integration**: Connects to live pub.dev data
- **Error resilient**: Handles network issues gracefully

Happy coding with Clix! 🚀