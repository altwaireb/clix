import 'package:clix/clix.dart';

void main(List<String> args) {
  final logger = CliLogger();

  logger.withIcon('CLI Arguments Parser Demo', icon: CliIcons.gear);
  logger.newLine();

  // Create a parser with options
  final parser = CliParser()
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output')
    ..addFlag('debug', abbr: 'd', help: 'Enable debug mode')
    ..addOption('output', abbr: 'o', help: 'Output file path')
    ..addOption(
      'format',
      abbr: 'f',
      help: 'Output format',
      allowed: ['json', 'yaml', 'text'],
    )
    ..addMultiOption('include', abbr: 'i', help: 'Include patterns');

  try {
    // Parse arguments
    final results = parser.parse(args);

    logger.info('Parsed Arguments:');

    // Check flags
    if (results.wasParsed('verbose')) {
      logger.success('Verbose mode: ${results['verbose']}');
    }

    if (results.wasParsed('debug')) {
      logger.success('Debug mode: ${results['debug']}');
    }

    // Check options
    if (results.wasParsed('output')) {
      logger.info('Output file: ${results['output']}');
    }

    if (results.wasParsed('format')) {
      logger.info('Format: ${results['format']}');
    }

    // Check multi-options
    final includes = results.multiOption('include');
    if (includes != null && includes.isNotEmpty) {
      logger.info('Include patterns:');
      for (final pattern in includes) {
        logger.point(pattern, indent: IndentLevel.level1);
      }
    }

    // Show remaining arguments
    if (results.rest.isNotEmpty) {
      logger.info('Remaining arguments:');
      for (final arg in results.rest) {
        logger.point(arg, indent: IndentLevel.level1);
      }
    }

    logger.newLine();
    logger.successIcon('Arguments parsed successfully!');
  } on CliArgException catch (e) {
    logger.errorIcon('Argument parsing failed:');
    logger.error(e.message);
    logger.newLine();

    // Show help using the helper
    logger.newLine();
    logger.info('Usage: cli_demo [options] [arguments]');
    logger.info(parser.parser.usage);
  } catch (e) {
    logger.errorIcon('Unexpected error: $e');
  }
}
