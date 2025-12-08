import 'package:clix/clix.dart';

void main() async {
  // 1. Input Prompt
  final name = await Input(prompt: 'What is your name?').interact();

  print('Hello, $name!');

  // 2. Password Prompt (for security purposes)
  await Password(prompt: 'Enter your password:').interact();

  print('Password entered (hidden)');

  // 3. Confirm Prompt
  final confirmed = await Confirm(
    prompt: 'Do you want to continue?',
  ).interact();

  print('Confirmation: ${confirmed ? "Yes" : "No"}');

  // 4. Number Prompt
  final age = await Number(prompt: 'How old are you?').interact();

  print('Age: $age');

  // 5. Select Prompt
  final color = await Select(
    prompt: 'Choose your favorite color:',
    options: ['Red', 'Green', 'Blue', 'Yellow'],
  ).interact();

  print('Selected color: ${["Red", "Green", "Blue", "Yellow"][color]}');

  // 6. Multi Select Prompt
  final hobbies = await MultiSelect(
    prompt: 'Select your hobbies:',
    options: ['Reading', 'Sports', 'Music', 'Gaming'],
  ).interact();

  print(
    'Selected hobbies: ${hobbies.map((i) => ["Reading", "Sports", "Music", "Gaming"][i]).toList()}',
  );

  // 7. Search Prompt
  final languages = [
    'Dart',
    'Python',
    'JavaScript',
    'Java',
    'C++',
    'Rust',
    'Go',
    'Swift',
  ];
  final searchResult = await Search(
    prompt: 'Search for a programming language:',
    options: languages,
  ).interact();

  print('Selected language: ${languages[searchResult]}');

  print('\n💡 Pro tip: Check out live_package_search.dart example to see');
  print('   Search prompt working with real pub.dev API data!');
}
