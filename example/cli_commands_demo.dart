import 'package:clix/clix.dart';

Future<void> main(List<String> args) async {
  final runner = CliCommandRunner<void>(
    'clix_commands_demo',
    'Demonstrate Clix commands, arguments, options, flags, help, and suggestions.',
  );

  runner.argParser.addFlag(
    'verbose',
    abbr: 'v',
    help: 'Enable verbose output.',
  );

  runner.addCommand(BuildCommand());
  runner.addCommand(CleanCommand());
  runner.addCommand(DeployCommand());

  try {
    await runner.run(args);
  } on CliUsageException catch (e) {
    final logger = CliLogger();
    logger.errorIcon(e.message);
    logger.newLine();
    logger.plain(e.usage);
  }
}

class BuildCommand extends CliCommand<void> {
  @override
  String get name => 'build';

  @override
  String get description =>
      'Build a project with an optional format and output path.';

  @override
  List<String> get aliases => const ['b'];

  BuildCommand() {
    argParser
      ..addOption(
        'format',
        abbr: 'f',
        help: 'Output format.',
        allowed: ['debug', 'release'],
        defaultsTo: 'release',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output directory.',
        defaultsTo: 'build',
      )
      ..addFlag('clean', help: 'Clean before building.');
  }

  @override
  Future<void> run() async {
    final logger = CliLogger();
    final results = argResults!;
    final global = globalResults!;

    final project = results.rest.isEmpty ? 'my_app' : results.rest.first;
    final format = results.option('format');
    final output = results.option('output');
    final clean = results.flag('clean');
    final verbose = global.flag('verbose');

    logger.primary('Building $project');
    logger.point('Format: $format', indent: IndentLevel.level1);
    logger.point('Output: $output', indent: IndentLevel.level1);
    logger.point('Clean: $clean', indent: IndentLevel.level1);
    logger.point('Verbose: $verbose', indent: IndentLevel.level1);

    if (clean) {
      logger.point('Cleaning previous build', indent: IndentLevel.level1);
    }

    logger.successMark('Build completed');
  }
}

class CleanCommand extends CliCommand<void> {
  @override
  String get name => 'clean';

  @override
  String get description => 'Remove generated build files.';

  @override
  List<String> get aliases => const ['c'];

  @override
  bool get takesArguments => false;

  @override
  Future<void> run() async {
    final logger = CliLogger();

    logger.successMark('Build files cleaned');
  }
}

class DeployCommand extends CliCommand<void> {
  @override
  String get name => 'deploy';

  @override
  String get description => 'Deploy a project to an environment.';

  @override
  List<String> get aliases => const ['d'];

  DeployCommand() {
    addSubcommand(DeployEnvironmentCommand('staging'));
    addSubcommand(DeployEnvironmentCommand('production'));
  }

  @override
  Future<void> run() async {
    printUsage();
  }
}

class DeployEnvironmentCommand extends CliCommand<void> {
  DeployEnvironmentCommand(this._environment) {
    argParser.addFlag(
      'dry-run',
      help: 'Show what would be deployed without deploying.',
    );
  }

  final String _environment;

  @override
  String get name => _environment;

  @override
  String get description => 'Deploy a project to $_environment.';

  @override
  List<String> get aliases =>
      _environment == 'staging' ? const ['s'] : const ['p'];

  @override
  Future<void> run() async {
    final logger = CliLogger();
    final results = argResults!;
    final global = globalResults!;

    final project = results.rest.isEmpty ? 'my_app' : results.rest.first;
    final dryRun = results.flag('dry-run');
    final verbose = global.flag('verbose');

    logger.primary('Deploying $project');
    logger.point('Environment: $_environment', indent: IndentLevel.level1);
    logger.point('Dry run: $dryRun', indent: IndentLevel.level1);
    logger.point('Verbose: $verbose', indent: IndentLevel.level1);

    logger.successMark(
      dryRun ? 'Deployment preview ready' : 'Deployment completed',
    );
  }
}
