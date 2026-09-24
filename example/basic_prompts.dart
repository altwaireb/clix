import 'package:clix/clix.dart';

Future<void> main() async {
  final logger = CliLogger();

  logger.primary('Clix Prompts Demo');
  logger.newLine();

  // 1. Input
  final name = await Input(prompt: 'What is your name?').interact();

  logger.success('Hello, $name!');
  logger.newLine();

  // 2. Password
  await Password(prompt: 'Enter your password:').interact();

  logger.success('Password entered securely.');
  logger.newLine();

  // 3. Confirm
  final confirmed = await Confirm(
    prompt: 'Do you want to continue?',
  ).interact();

  if (!confirmed) {
    logger.warn('Operation cancelled.');
    return;
  }

  logger.success('Continuing...');
  logger.newLine();

  // 4. Number
  final age = await Number(prompt: 'How old are you?').interact();

  logger.point('Age: $age');
  logger.newLine();

  // 5. Select
  final colors = ['Red', 'Green', 'Blue', 'Yellow'];

  final color = await Select(
    prompt: 'Choose your favorite color:',
    options: colors,
  ).interact();

  logger.point('Selected color: ${colors[color]}');
  logger.newLine();

  // 6. Multi Select
  final hobbies = ['Reading', 'Sports', 'Music', 'Gaming'];

  final selectedHobbies = await MultiSelect(
    prompt: 'Select your hobbies:',
    options: hobbies,
  ).interact();

  final selectedHobbyNames = selectedHobbies
      .map((index) => hobbies[index])
      .toList();

  logger.point('Selected hobbies: $selectedHobbyNames');
  logger.newLine();

  // 7. Search
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

  final language = await Search(
    prompt: 'Search for a programming language:',
    options: languages,
  ).interact();

  logger.point('Selected language: ${languages[language]}');
  logger.newLine();

  logger.successMark('Prompt demo completed');
}
