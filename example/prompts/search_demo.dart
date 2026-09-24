import 'package:clix/clix.dart';

Future<void> main() async {
  await Search(
    prompt: 'Search for a programming language:',
    options: [
      'Dart',
      'Python',
      'JavaScript',
      'Java',
      'C++',
      'Rust',
      'Go',
      'Swift',
    ],
  ).interact();
}
