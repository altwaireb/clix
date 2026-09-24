# Simple Command

A minimal command application using `CliCommandRunner` and `CliCommand`.

```dart
import 'dart:async';

import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'myapp',
    'A simple Clix application.',
  );

  runner.addCommand(HelloCommand());

  await runner.run(args);
}

class HelloCommand extends CliCommand<void> {
  @override
  String get name => 'hello';

  @override
  String get description => 'Print a greeting.';

  @override
  FutureOr<void> run() {
    print('Hello from Clix!');
  }
}
```

Run:

```text
dart run bin/myapp.dart hello
```

See [Commands](../commands/README.md) for the complete command API.
