import 'package:clix/clix.dart';

void main() async {
  final logger = CliLogger.defaults();

  logger.primary('🔐 Validation System Demo - Clix Feature/Validation');
  logger.newLine();

  // Example 1: Simple validation
  logger.successWithHint(
    'Example 1: Simple Required Validation',
    hint: 'Using basic Validator methods',
    hintSymbol: HintSymbol.lightBulb,
  );

  final nameInput = Input(
    prompt: 'Enter your name',
    validator: (value) => Validator.required(value),
  );

  try {
    final name = await nameInput.interact();
    logger.success('✅ Name entered: $name');
  } catch (e) {
    logger.error('Error: $e');
  }

  logger.newLine();

  // Example 2: Combined validation with Validator.rules
  logger.successWithHint(
    'Example 2: Combined Validation Rules',
    hint: 'Using Validator.rules() for multiple checks',
    hintSymbol: HintSymbol.star,
  );

  final emailInput = Input(
    prompt: 'Enter your email',
    validator: Validator.rules([
      (value) => Validator.required(value),
      (value) => Validator.min(value, 5),
      (value) => Validator.email(value),
    ]),
  );

  try {
    final email = await emailInput.interact();
    logger.success('✅ Email entered: $email');
  } catch (e) {
    logger.error('Error: $e');
  }

  logger.newLine();

  // Example 3: ValidationRules Builder Pattern
  logger.successWithHint(
    'Example 3: ValidationRules Builder Pattern',
    hint: 'Fluent API without .build() - just use directly!',
    hintSymbol: HintSymbol.diamond,
  );

  final usernameInput = Input(
    prompt: 'Create username',
    validator: (value) => ValidationRules(value)
        .required()
        .min(3, message: 'Username too short')
        .max(20, message: 'Username too long')
        .alphaNumeric()
        .notInList([
          'admin',
          'root',
          'test',
        ], message: 'Reserved usernames not allowed'),
  );

  try {
    final username = await usernameInput.interact();
    logger.success('✅ Username created: $username');
  } catch (e) {
    logger.error('Error: $e');
  }

  logger.newLine();

  // Example 4: Complex Password Validation
  logger.successWithHint(
    'Example 4: Complex Password Validation',
    hint: 'Multiple patterns and custom rules',
    hintSymbol: HintSymbol.triangle,
  );

  final passwordInput = Input(
    prompt: 'Create secure password',
    validator: (value) => ValidationRules(value)
        .required()
        .min(8, message: 'Password must be at least 8 characters')
        .pattern(RegExp(r'[A-Z]'), message: 'Must contain uppercase letter')
        .pattern(RegExp(r'[a-z]'), message: 'Must contain lowercase letter')
        .pattern(RegExp(r'[0-9]'), message: 'Must contain number')
        .pattern(
          RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
          message: 'Must contain special character',
        )
        .notContains(' ', message: 'Spaces not allowed')
        .custom((value) {
          if (value.toLowerCase().contains('password')) {
            return 'Cannot contain the word "password"';
          }
          return null;
        })(),
  );

  try {
    final password = await passwordInput.interact();
    logger.success('✅ Secure password created! (length: ${password.length})');
  } catch (e) {
    logger.error('Error: $e');
  }

  logger.newLine();

  // Example 5: URL Validation with Domain Restrictions
  logger.successWithHint(
    'Example 5: URL with Domain Restrictions',
    hint: 'Combining multiple validation types',
    hintSymbol: HintSymbol.chevron,
  );

  final websiteInput = Input(
    prompt: 'Enter company website',
    validator: (value) => ValidationRules(value)
        .required()
        .url()
        .startsWith('https://', message: 'Must use HTTPS')
        .notContains('localhost', message: 'Production URLs only')(),
  );

  try {
    final website = await websiteInput.interact();
    logger.success('✅ Website URL: $website');
  } catch (e) {
    logger.error('Error: $e');
  }

  logger.newLine();

  // Example 6: Validation Utility Methods
  logger.successWithHint(
    'Example 6: Validation Utility Methods',
    hint: 'Exploring ValidationRules utility features',
    hintSymbol: HintSymbol.info,
  );

  final demoValidator = ValidationRules()
      .required()
      .min(5)
      .email()
      .endsWith('.com');

  logger.info('ValidationRules Utility Demo:');
  logger.point('Rule count: ${demoValidator.ruleCount}');
  logger.point('Description: ${demoValidator.describe()}');

  // Test the validator
  final testValues = ['', 'test', 'test@example.org', 'valid@example.com'];

  for (final testValue in testValues) {
    final result = demoValidator(testValue);
    if (result == null) {
      logger.success('✅ "$testValue" is valid');
    } else {
      logger.error('❌ "$testValue": $result');
    }
  }

  logger.newLine();
  logger.successIconWithHint(
    'Validation System Demo Complete!',
    hint: 'All validation features working perfectly',
    hintSymbol: HintSymbol.star,
    spacing: Spacing.large,
  );

  logger.infoWithHint(
    'Available Validation Methods',
    hint: 'Check the documentation for the complete API',
    hintSymbol: HintSymbol.lightBulb,
  );

  logger.newLine();
  logger.info('🔍 Static Validator Methods:');
  logger.point('Validator.required(), .min(), .max(), .email()');
  logger.point('Validator.alpha(), .alphaNumeric(), .numeric()');
  logger.point('Validator.url(), .pattern(), .startsWith(), .endsWith()');
  logger.point('Validator.contains(), .notContains(), .inList(), .notInList()');
  logger.point('Validator.rules() - for combining multiple validators');

  logger.newLine();
  logger.info('🏗️ ValidationRules Builder:');
  logger.point('ValidationRules().required().min(8).email() - fluent API');
  logger.point('Callable directly as validator function');
  logger.point('Utility methods: .ruleCount, .describe(), .clear()');
  logger.point('Custom validation with .custom() method');
}
