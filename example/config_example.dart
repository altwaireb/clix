import 'package:clix/clix.dart';

/// Simple CliConfig example - Configuration management made easy
void main() async {
  final logger = CliLogger();
  final config = CliConfig(logger: logger);

  logger.withIcon('Configuration Example', icon: CliIcons.rocket);
  logger.newLine();

  // Define configuration keys
  config.define('app_name', required: true, description: 'Application name');
  config.define('version', defaultValue: '1.0.0', description: 'App version');
  config.define('debug', defaultValue: false, description: 'Debug mode');

  // Load some sample data
  config.loadFromMap({'app_name': 'My CLI App', 'debug': true});

  // Alternative loading methods for different data sources:
  // config.loadFromJson('example/config_example.json');
  // config.loadFromSimpleYaml('example/config_example.yaml');

  logger.newLine();
  logger.successIcon('Configuration loaded!');

  // Display current settings
  logger.info('Current settings:');
  logger.point('App: ${config.get('app_name')}');
  logger.point('Version: ${config.get('version')}');
  logger.point('Debug: ${config.get('debug')}');

  logger.newLine();

  // Validate configuration
  if (config.validate()) {
    logger.successIcon('Configuration is valid!');
  } else {
    logger.errorIcon('Configuration validation failed!');
  }
}
