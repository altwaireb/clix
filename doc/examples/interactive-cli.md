# Interactive CLI

Prompts can be combined with a command to create an interactive workflow.

```dart
import 'dart:async';

import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'setup',
    'Interactive project setup.',
  );

  runner.addCommand(InitCommand());

  await runner.run(args);
}

class InitCommand extends CliCommand<void> {
  @override
  String get name => 'init';

  @override
  String get description => 'Create a project interactively.';

  @override
  Future<void> run() async {
    final name = await Input(
      prompt: 'Project name',
    ).interact();

    final framework = await Select(
      prompt: 'Framework',
      options: ['Flutter', 'Dart', 'Laravel'],
    ).interact();

    final confirmed = await Confirm(
      prompt: 'Create project?',
      defaultValue: true,
    ).interact();

    if (!confirmed) {
      return;
    }

    print('Creating $name with framework index $framework');
  }
}
```

See [Prompts](../prompts/README.md) for the available interactive prompts.
