import 'package:clix/clix.dart';

Future<void> main() async {
  // Create logger - you can use either:
  // final logger = CliLogger.defaults(); // Quick setup with default settings
  // final logger = CliLogger();          // Basic constructor with customizable options
  // final logger = CliLogger(showTimestamps: true, minimumLevel: LogLevel.info); // Custom settings
  final logger = CliLogger();

  // === BASIC LOGGING METHODS ===
  logger.withIcon('Clix Logger Complete Demo', icon: CliIcons.rocket);
  logger.newLine();

  logger.info('Basic logging methods:');
  logger.success('Operation completed successfully');
  logger.error('Something went wrong');
  logger.warn('Warning message');
  logger.debug('Debug information');

  logger.newLine();

  // === ICON METHODS ===
  logger.info('Icon methods:');
  logger.successIcon('Success with icon');
  logger.errorIcon('Error with icon');
  logger.warnIcon('Warning with icon');
  logger.infoIcon('Info with icon');

  logger.newLine();

  // === WITHICON METHODS ===
  logger.info('Custom icons:');
  logger.withIcon('Building project', icon: CliIcons.build);
  logger.withIcon('Running tests', icon: CliIcons.test);
  logger.withIcon('Deploying app', icon: CliIcons.deploy);
  logger.withIconCustom('Database connected', icon: '🗄️');

  logger.newLine();

  // === COLORS ===
  logger.info('Colored messages:');
  logger.primary('Primary color message');
  logger.secondary('Secondary color message');
  logger.red('Red message');
  logger.green('Green message');
  logger.yellow('Yellow message');
  logger.blue('Blue message');

  logger.newLine();

  // === BULLET POINTS & LISTS ===
  logger.info('List formatting:');
  logger.point('Main item');
  logger.point('Sub item', indent: IndentLevel.level1);
  logger.point('Sub-sub item', indent: IndentLevel.level2);
  logger.point('Check item', style: PointStyle.check, color: CliColor.green);
  logger.point('Arrow item', style: PointStyle.arrow, color: CliColor.yellow);

  logger.newLine();

  // === THEMES & STYLING ===
  logger.info('Theme styling:');
  final theme = CliTheme.defaultTheme();
  logger.info(theme.primary('Primary themed text'));
  logger.info(theme.secondary('Secondary themed text'));
  logger.info(theme.success('Success themed text'));
  logger.info(theme.warn('Warning themed text'));
  logger.info(theme.error('Error themed text'));

  logger.newLine();

  // === CUSTOM THEMES WITH HEX COLORS ===
  logger.info('Custom theme with hex colors:');
  final customTheme = CliTheme(
    primary: CliStyle().withColor(CliColor.hex('#FF6B6B')), // Coral Red
    secondary: CliStyle().withColor(CliColor.hex('#4ECDC4')), // Teal
    success: CliStyle().withColor(CliColor.hex('#45B7D1')), // Sky Blue
    warn: CliStyle().withColor(CliColor.hex('#FFA726')), // Orange
    error: CliStyle().withColor(CliColor.hex('#E74C3C')), // Red
  );

  final customLogger = CliLogger(theme: customTheme);
  customLogger.primary('Custom primary color (#FF6B6B)');
  customLogger.secondary('Custom secondary color (#4ECDC4)');
  customLogger.success('Custom success color (#45B7D1)');
  customLogger.warn('Custom warning color (#FFA726)');
  customLogger.error('Custom error color (#E74C3C)');

  logger.newLine();

  // === DIRECT HEX COLOR USAGE ===
  logger.info('Direct hex color usage:');
  final purpleColor = CliColor.hex('#9B59B6');
  final goldColor = CliColor.hex('#F39C12');
  final mintColor = CliColor.hex('#16A085');

  logger.plain(purpleColor('Purple text using hex #9B59B6'));
  logger.plain(goldColor('Gold text using hex #F39C12'));
  logger.plain(mintColor('Mint text using hex #16A085'));

  logger.newLine();

  // === ADVANCED FEATURES ===
  logger.info('Advanced features:');
  logger.onSuccess('Success background message');
  logger.onError('Error background message');

  logger.newLine();

  // === SPINNER DEMO ===
  logger.info('Animation demo:');
  final spinner = Spinner('Processing...', logger: logger);
  await Future.delayed(Duration(seconds: 2));
  spinner.complete('Processing completed!');

  logger.newLine();

  // === PROMPTS DEMO ===
  logger.info('Interactive prompts demo:');

  // Simple input
  final name = await Input(prompt: 'What is your name?').interact();
  logger.success('Hello, $name!');

  // Simple selection
  final choice = await Select(
    prompt: 'Choose your favorite language:',
    options: ['Dart', 'JavaScript', 'Python', 'Go'],
  ).interact();

  final languages = ['Dart', 'JavaScript', 'Python', 'Go'];
  logger.info('You chose: ${languages[choice]}');

  // Simple confirmation
  final confirmed = await Confirm(prompt: 'Continue with demo?').interact();
  if (confirmed) {
    logger.successIcon('Demo will continue');
  } else {
    logger.warnIcon('Demo cancelled');
  }

  logger.newLine();

  // === CLI ARGUMENTS DEMO ===
  logger.info('CLI arguments example:');
  final parser = CliParser()
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output')
    ..addOption('output', abbr: 'o', help: 'Output file');

  try {
    // Example with empty args for demo
    parser.parse([]);
    logger.info('Arguments parsed successfully');
    logger.point(
      'Use --verbose or -v for verbose mode',
      indent: IndentLevel.level1,
    );
    logger.point(
      'Use --output=file.txt or -o file.txt for output',
      indent: IndentLevel.level1,
    );
  } on CliArgException catch (e) {
    logger.errorIcon('Argument error: ${e.message}');
  }

  logger.newLine();

  // === COMPLETION ===
  logger.withIcon('Demo completed successfully!', icon: CliIcons.check);
  logger.info('This demo shows all major Clix features in one place.');
  logger.newLine();
  logger.successIcon('Ready to build amazing CLI apps! 🚀');
}
