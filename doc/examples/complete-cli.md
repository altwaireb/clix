# Complete CLI

This example combines Commands, Prompts, Validation, Logger, and Progress
into one workflow.

```dart
import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'project',
    'Project management CLI.',
  );

  runner.addCommand(CreateCommand());

  await runner.run(args);
}

class CreateCommand extends CliCommand<void> {
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new project.';

  @override
  Future<void> run() async {
    final logger = CliLogger();

    final name = await Input(
      prompt: 'Project name',
      validator: ValidationRules()
          .required()
          .min(3),
    ).interact();

    final confirmed = await Confirm(
      prompt: 'Create project?',
      defaultValue: true,
    ).interact();

    if (!confirmed) {
      logger.warn('Operation cancelled');
      return;
    }

    logger.info('Creating $name...');

    final progress = Progress(
      total: 3,
    );

    progress.update(1);
    progress.update(2);
    progress.complete();

    logger.success('Project created');
  }
}
```

Run:

```text
dart run bin/project.dart create
```

This example is intentionally small. The dedicated documentation contains
the detailed API reference for each component.

## Related Documentation

- [Commands](../commands/README.md)
- [Prompts](../prompts/README.md)
- [Validation](../prompts/validation/README.md)
- [Logger](../logger/README.md)
- [Progress](../progress/README.md)
- [Styling](../styling/README.md)
