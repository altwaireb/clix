import 'package:clix/clix.dart';

Future<void> main() async {
  await MultiSelect(
    prompt: 'Select your hobbies:',
    options: ['Reading', 'Sports', 'Music', 'Gaming'],
    minimumOptions: 1,
    maximumOptions: 2,
  ).interact();
}
