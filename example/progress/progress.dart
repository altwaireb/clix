import 'package:clix/clix.dart';

void main() async {
  final logger = Clix.logger;

  logger.info('🎯 Progress Bar Examples - Two Approaches');
  logger.newLine();

  // ========================================
  // Method 1: Via Logger (Simplified)
  // ========================================
  logger.successIcon('Via Logger (Recommended for simple use)');
  final progress1 = logger.progress(total: 20);

  for (int i = 0; i <= 20; i += 2) {
    progress1.update(i);
    await Future.delayed(Duration(milliseconds: 150));
  }
  progress1.complete();

  logger.newLine();

  // ========================================
  // Method 2: Direct Constructor (Advanced)
  // ========================================
  logger.infoIcon('Direct Constructor (For advanced customization)');
  final progress2 = Progress(
    total: 25,
    style: ProgressStyle.detailed,
    width: 30,
  );

  for (int i = 0; i <= 25; i += 2) {
    progress2.update(i);
    await Future.delayed(Duration(milliseconds: 150));
  }
  progress2.complete();

  logger.newLine();

  // ========================================
  // Multiple Styles Demonstration
  // ========================================
  logger.ideaIcon('Different styles available in both methods!');

  // Clean style via logger
  final cleanProgress = logger.progress(total: 15, style: ProgressStyle.clean);
  logger.info('Clean style (visual only):');
  for (int i = 0; i <= 15; i += 3) {
    cleanProgress.update(i);
    await Future.delayed(Duration(milliseconds: 100));
  }
  cleanProgress.complete();

  logger.newLine();

  // Minimal style via constructor
  final minimalProgress = Progress(total: 20, style: ProgressStyle.minimal);
  logger.info('Minimal style (percentage only):');
  for (int i = 0; i <= 20; i += 4) {
    minimalProgress.update(i);
    await Future.delayed(Duration(milliseconds: 120));
  }
  minimalProgress.complete();

  logger.newLine();
  logger.primary('🎉 Both approaches support all styles and options!');

  logger.newLine();
  logger.successIcon('All downloads completed!');
}
