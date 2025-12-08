import 'package:clix/clix.dart';

void main() async {
  final logger = Clix.logger;

  logger.info('MultiSpinner - for multiple concurrent tasks');
  logger.newLine();

  // Create multi-spinner and add tasks
  final multiSpinner = MultiSpinner();

  // Add tasks
  multiSpinner.add('packages', 'Downloading packages');
  multiSpinner.add('env', 'Setting up environment');
  multiSpinner.add('deps', 'Installing dependencies');
  multiSpinner.add('config', 'Configuring settings');

  // Start tasks
  multiSpinner.startTask('packages');
  multiSpinner.startTask('env');
  multiSpinner.startTask('deps');
  multiSpinner.startTask('config');

  // Simulate completing tasks one by one
  await Future.delayed(Duration(milliseconds: 800));
  multiSpinner.complete('packages', 'Packages downloaded');

  await Future.delayed(Duration(milliseconds: 600));
  multiSpinner.complete('env', 'Environment ready');

  await Future.delayed(Duration(milliseconds: 900));
  multiSpinner.complete('deps', 'Dependencies installed');

  await Future.delayed(Duration(milliseconds: 500));
  multiSpinner.complete('config', 'Configuration complete');

  await Future.delayed(Duration(milliseconds: 200));
  multiSpinner.stop();

  logger.newLine();
  logger.successIcon('All tasks completed successfully!');
}
