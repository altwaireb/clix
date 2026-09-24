import 'package:clix/clix.dart';

Future<void> main() async {
  await Select(
    prompt: 'Choose your favorite color:',
    options: ['Red', 'Green', 'Blue', 'Yellow'],
  ).interact();

  print('');

  await Select(
    prompt: 'Choose your favorite language:',
    options: ['Dart', 'Python', 'JavaScript', 'Rust'],
  ).interact();
}
