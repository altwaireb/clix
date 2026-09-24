# Command with Options

Commands can define flags and options using `CliParser`.

```dart
import 'dart:async';

import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'myapp',
    'Command options example.',
  );

  runner.addCommand(BuildCommand());

  await runner.run(args);
}

class BuildCommand extends CliCommand<void> {
  BuildCommand() {
    argParser
      ..addFlag(
        'release',
        abbr: 'r',
        help: 'Build in release mode.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output directory.',
        defaultsTo: 'build',
      );
  }

  @override
  String get name => 'build';

  @override
  String get description => 'Build the project.';

  @override
  FutureOr<void> run() {
    final release = argResults['release'] as bool;
    final output = argResults['output'] as String;

    print('Release: $release');
    print('Output: $output');
  }
}
```

Example:

```text
dart run bin/myapp.dart build --release --output dist
```

See [Options](../commands/options.md) and [Flags](../commands/flags.md).
