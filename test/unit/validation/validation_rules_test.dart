import 'package:test/test.dart';
import 'package:clix/clix.dart';

void main() {
  group('ValidationRules Tests', () {
    group('Callable functionality', () {
      test('should work as callable function', () {
        final validator = ValidationRules().required().min(3);

        // Should work as a function
        expect(validator('hello'), isNull);
        expect(validator(''), 'This field is required');
        expect(validator('hi'), 'Must be at least 3 characters');
      });

      test('should return null for empty rule set', () {
        final validator = ValidationRules();
        expect(validator('anything'), isNull);
      });
    });

    group('Builder pattern', () {
      test('should chain validation rules fluently', () {
        final validator = ValidationRules().required().min(8).alphaNumeric();

        expect(validator('hello123'), isNull);
        expect(validator(''), 'This field is required');
        expect(validator('hi'), 'Must be at least 8 characters');
        expect(validator('hello@123'), 'Only letters and numbers are allowed');
      });

      test('should support all validation types', () {
        final validator = ValidationRules().required().min(3).max(10).alpha();

        expect(validator('hello'), isNull);
        expect(validator(''), 'This field is required');
        expect(validator('hi'), 'Must be at least 3 characters');
        expect(validator('verylongtext'), 'Must be no more than 10 characters');
        expect(validator('hello123'), 'Only letters are allowed');
      });
    });

    group('Individual rule methods', () {
      test('required() should add required validation', () {
        final validator = ValidationRules().required();
        expect(validator('hello'), isNull);
        expect(validator(''), 'This field is required');
      });

      test('required() should support custom message', () {
        final validator = ValidationRules().required(
          message: 'Custom required message',
        );
        expect(validator(''), 'Custom required message');
      });

      test('min() should add minimum length validation', () {
        final validator = ValidationRules().min(5);
        expect(validator('hello'), isNull);
        expect(validator('hi'), 'Must be at least 5 characters');
      });

      test('max() should add maximum length validation', () {
        final validator = ValidationRules().max(3);
        expect(validator('hi'), isNull);
        expect(validator('hello'), 'Must be no more than 3 characters');
      });

      test('email() should add email validation', () {
        final validator = ValidationRules().email();
        expect(validator('user@example.com'), isNull);
        expect(
          validator('invalid-email'),
          'Please enter a valid email address',
        );
      });

      test('pattern() should add regex pattern validation', () {
        final validator = ValidationRules().pattern(RegExp(r'^[A-Z]'));
        expect(validator('Hello'), isNull);
        expect(validator('hello'), 'Invalid format');
      });

      test('alpha() should add alphabetic validation', () {
        final validator = ValidationRules().alpha();
        expect(validator('hello'), isNull);
        expect(validator('hello123'), 'Only letters are allowed');
      });

      test('alphaNumeric() should add alphanumeric validation', () {
        final validator = ValidationRules().alphaNumeric();
        expect(validator('hello123'), isNull);
        expect(validator('hello@123'), 'Only letters and numbers are allowed');
      });

      test('numeric() should add numeric validation', () {
        final validator = ValidationRules().numeric();
        expect(validator('12345'), isNull);
        expect(validator('123abc'), 'Only numbers are allowed');
      });

      test('url() should add URL validation', () {
        final validator = ValidationRules().url();
        expect(validator('https://example.com'), isNull);
        expect(validator('not-a-url'), 'Please enter a valid URL');
      });

      test('startsWith() should add prefix validation', () {
        final validator = ValidationRules().startsWith('prefix_');
        expect(validator('prefix_test'), isNull);
        expect(validator('test_prefix'), 'Must start with "prefix_"');
      });

      test('endsWith() should add suffix validation', () {
        final validator = ValidationRules().endsWith('.txt');
        expect(validator('document.txt'), isNull);
        expect(validator('document.pdf'), 'Must end with ".txt"');
      });

      test('contains() should add substring validation', () {
        final validator = ValidationRules().contains('@');
        expect(validator('user@domain.com'), isNull);
        expect(validator('userdomain.com'), 'Must contain "@"');
      });

      test('notContains() should add forbidden substring validation', () {
        final validator = ValidationRules().notContains('admin');
        expect(validator('user123'), isNull);
        expect(validator('admin_user'), 'Must not contain "admin"');
      });

      test('inList() should add allowed values validation', () {
        final validator = ValidationRules().inList(['red', 'green', 'blue']);
        expect(validator('red'), isNull);
        expect(validator('yellow'), 'Must be one of: red, green, blue');
      });

      test('notInList() should add forbidden values validation', () {
        final validator = ValidationRules().notInList(['admin', 'root']);
        expect(validator('user'), isNull);
        expect(validator('admin'), 'Cannot be one of: admin, root');
      });

      test('custom() should add custom validation function', () {
        final validator = ValidationRules().custom((value) {
          if (value.contains('forbidden')) {
            return 'Contains forbidden word';
          }
          return null;
        });

        expect(validator('normal text'), isNull);
        expect(validator('forbidden word'), 'Contains forbidden word');
      });
    });

    group('Complex validation scenarios', () {
      test('should validate password requirements', () {
        final passwordValidator = ValidationRules()
            .required()
            .min(8)
            .pattern(RegExp(r'[A-Z]'), message: 'Must contain uppercase')
            .pattern(RegExp(r'[0-9]'), message: 'Must contain numbers')
            .notContains(' ', message: 'No spaces allowed');

        expect(passwordValidator('Password123'), isNull);
        expect(passwordValidator(''), 'This field is required');
        expect(passwordValidator('pass'), 'Must be at least 8 characters');
        expect(passwordValidator('password123'), 'Must contain uppercase');
        expect(passwordValidator('Password'), 'Must contain numbers');
        expect(passwordValidator('Pass word123'), 'No spaces allowed');
      });

      test('should validate username requirements', () {
        final usernameValidator = ValidationRules()
            .required()
            .min(3)
            .max(20)
            .alphaNumeric()
            .notInList(['admin', 'root', 'test']);

        expect(usernameValidator('john123'), isNull);
        expect(usernameValidator(''), 'This field is required');
        expect(usernameValidator('jo'), 'Must be at least 3 characters');
        expect(
          usernameValidator('verylongusernamethatexceedslimit'),
          'Must be no more than 20 characters',
        );
        expect(
          usernameValidator('john@123'),
          'Only letters and numbers are allowed',
        );
        expect(
          usernameValidator('admin'),
          'Cannot be one of: admin, root, test',
        );
      });

      test('should validate email with domain restrictions', () {
        final emailValidator = ValidationRules().required().email().endsWith(
          '.com',
          message: 'Only .com emails allowed',
        );

        expect(emailValidator('user@example.com'), isNull);
        expect(emailValidator(''), 'This field is required');
        expect(
          emailValidator('invalid-email'),
          'Please enter a valid email address',
        );
        expect(emailValidator('user@example.org'), 'Only .com emails allowed');
      });
    });

    group('Utility methods', () {
      test('ruleCount should return number of rules', () {
        final validator = ValidationRules();
        expect(validator.ruleCount, 0);

        validator.required().min(3).email();
        expect(validator.ruleCount, 3);
      });

      test('clear() should remove all rules', () {
        final validator = ValidationRules().required().min(5);

        expect(validator.ruleCount, 2);
        expect(
          validator(''),
          'This field is required',
        ); // Empty fails required first

        validator.clear();
        expect(validator.ruleCount, 0);
        expect(validator('hi'), isNull);
      });

      test('describe() should provide rule description', () {
        final emptyValidator = ValidationRules();
        expect(emptyValidator.describe(), 'No validation rules');

        final singleRuleValidator = ValidationRules().required();
        expect(
          singleRuleValidator.describe(),
          'Validation rules: 1 rule configured',
        );

        final multiRuleValidator = ValidationRules().required().min(3).email();
        expect(
          multiRuleValidator.describe(),
          'Validation rules: 3 rules configured',
        );
      });
    });

    group('Edge cases', () {
      test('should handle chaining after clear', () {
        final validator = ValidationRules()
            .required()
            .min(5)
            .clear()
            .required()
            .max(3);

        expect(validator.ruleCount, 2);
        expect(validator('hi'), isNull);
        expect(validator('hello'), 'Must be no more than 3 characters');
      });

      test('should work with duplicate rule types', () {
        final validator = ValidationRules()
            .min(3)
            .min(5) // Second min rule
            .min(8); // Third min rule

        // Should validate against all min rules (first failure returned)
        expect(
          validator('hello'),
          'Must be at least 8 characters',
        ); // 5 chars vs 8 min
        expect(
          validator('hi'),
          'Must be at least 3 characters',
        ); // 2 chars vs 3 min
      });

      test('should work with mixed rule types in any order', () {
        final validator = ValidationRules()
            .email()
            .required()
            .min(15) // Make min longer than the valid email to test
            .max(50);

        expect(validator('verylongemail@example.com'), isNull);
        expect(
          validator(''),
          'Please enter a valid email address',
        ); // Email checked first on empty
        expect(validator('short@ex.com'), 'Must be at least 15 characters');
      });
    });

    group('Performance and memory', () {
      test('should handle large number of rules efficiently', () {
        var validator = ValidationRules();

        // Add many rules
        for (int i = 0; i < 100; i++) {
          validator = validator.custom((value) => null); // Always pass
        }

        expect(validator.ruleCount, 100);
        expect(validator('test'), isNull);
      });

      test('should not interfere between different instances', () {
        final validator1 = ValidationRules().required().min(5);
        final validator2 = ValidationRules().required().max(3);

        expect(validator1('hello'), isNull);
        expect(validator1('hi'), 'Must be at least 5 characters');

        expect(validator2('hi'), isNull);
        expect(validator2('hello'), 'Must be no more than 3 characters');
      });
    });
  });
}
