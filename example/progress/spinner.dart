import 'package:clix/clix.dart';

void main() async {
  final logger = Clix.logger;

  logger.info('🎯 Spinner Examples - Two Approaches');
  logger.newLine();

  // ========================================
  // Method 1: Via Logger (Simplified)
  // ========================================
  logger.successIcon('Via Logger (Recommended for simple use)');
  final spinner1 = logger.spinner('Establishing connection');

  await Future.delayed(Duration(seconds: 1));
  spinner1.update('Authenticating user');
  await Future.delayed(Duration(seconds: 1));
  spinner1.complete('Connected successfully!');

  logger.newLine();

  // ========================================
  // Method 2: Direct Constructor (Advanced)
  // ========================================
  logger.infoIcon('Direct Constructor (For advanced customization)');
  final spinner2 = Spinner(
    'Downloading dependencies',
    type: SpinnerType.circle,
  );

  await Future.delayed(Duration(seconds: 1));
  spinner2.update('Installing packages');
  await Future.delayed(Duration(seconds: 1));
  spinner2.complete('Installation complete!');

  logger.newLine();

  // ========================================
  // Comparison Note
  // ========================================
  logger.ideaIcon('Both methods create identical Spinner objects!');
  logger.point('logger.spinner() - Simple and clean');
  logger.point('Spinner() - More customization options');
}
