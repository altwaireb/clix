import 'package:test/test.dart';
import 'package:clix/clix.dart';

void main() {
  group('Validator Tests', () {
    group('required()', () {
      test('should return null for non-empty strings', () {
        expect(Validator.required('hello'), isNull);
        expect(Validator.required('a'), isNull);
        expect(Validator.required('Hello World'), isNull);
      });

      test('should return error for empty strings', () {
        expect(Validator.required(''), 'This field is required');
        expect(Validator.required('   '), 'This field is required');
        expect(Validator.required('\t\n'), 'This field is required');
      });

      test('should use custom message when provided', () {
        const customMessage = 'Name is required';
        expect(Validator.required('', message: customMessage), customMessage);
        expect(
          Validator.required('   ', message: customMessage),
          customMessage,
        );
      });
    });

    group('min()', () {
      test('should return null for strings meeting minimum length', () {
        expect(Validator.min('hello', 5), isNull);
        expect(Validator.min('hello', 3), isNull);
        expect(Validator.min('a', 1), isNull);
      });

      test('should return error for strings below minimum length', () {
        expect(Validator.min('hi', 3), 'Must be at least 3 characters');
        expect(Validator.min('', 1), 'Must be at least 1 characters');
        expect(Validator.min('hello', 10), 'Must be at least 10 characters');
      });

      test('should use custom message when provided', () {
        const customMessage = 'Name too short';
        expect(Validator.min('hi', 3, message: customMessage), customMessage);
      });
    });

    group('max()', () {
      test('should return null for strings within maximum length', () {
        expect(Validator.max('hello', 5), isNull);
        expect(Validator.max('hi', 10), isNull);
        expect(Validator.max('', 5), isNull);
      });

      test('should return error for strings exceeding maximum length', () {
        expect(Validator.max('hello', 3), 'Must be no more than 3 characters');
        expect(
          Validator.max('hello world', 5),
          'Must be no more than 5 characters',
        );
      });

      test('should use custom message when provided', () {
        const customMessage = 'Description too long';
        expect(
          Validator.max('very long text', 5, message: customMessage),
          customMessage,
        );
      });
    });

    group('email()', () {
      test('should return null for valid email addresses', () {
        expect(Validator.email('user@example.com'), isNull);
        expect(Validator.email('test.email@domain.co.uk'), isNull);
        expect(Validator.email('user123@test-domain.org'), isNull);
        expect(Validator.email('simple@example.co'), isNull);
      });

      test('should return error for invalid email addresses', () {
        const errorMessage = 'Please enter a valid email address';
        expect(Validator.email('invalid-email'), errorMessage);
        expect(Validator.email('user@'), errorMessage);
        expect(Validator.email('@domain.com'), errorMessage);
        expect(Validator.email('user.domain.com'), errorMessage);
        expect(Validator.email('user @domain.com'), errorMessage);
      });

      test('should use custom message when provided', () {
        const customMessage = 'Invalid email format';
        expect(
          Validator.email('invalid', message: customMessage),
          customMessage,
        );
      });
    });

    group('pattern()', () {
      test('should return null for strings matching pattern', () {
        final alphaPattern = RegExp(r'^[a-zA-Z]+$');
        expect(Validator.pattern('hello', alphaPattern), isNull);
        expect(Validator.pattern('ABC', alphaPattern), isNull);
      });

      test('should return error for strings not matching pattern', () {
        final alphaPattern = RegExp(r'^[a-zA-Z]+$');
        expect(Validator.pattern('hello123', alphaPattern), 'Invalid format');
        expect(Validator.pattern('123', alphaPattern), 'Invalid format');
      });

      test('should use custom message when provided', () {
        final pattern = RegExp(r'^[0-9]+$');
        const customMessage = 'Numbers only';
        expect(
          Validator.pattern('abc', pattern, message: customMessage),
          customMessage,
        );
      });
    });

    group('alpha()', () {
      test('should return null for alphabetic strings', () {
        expect(Validator.alpha('hello'), isNull);
        expect(Validator.alpha('ABC'), isNull);
        expect(Validator.alpha('HelloWorld'), isNull);
      });

      test('should return error for non-alphabetic strings', () {
        const errorMessage = 'Only letters are allowed';
        expect(Validator.alpha('hello123'), errorMessage);
        expect(Validator.alpha('hello@world'), errorMessage);
        expect(Validator.alpha('hello world'), errorMessage);
        expect(Validator.alpha('123'), errorMessage);
      });
    });

    group('alphaNumeric()', () {
      test('should return null for alphanumeric strings', () {
        expect(Validator.alphaNumeric('hello123'), isNull);
        expect(Validator.alphaNumeric('ABC'), isNull);
        expect(Validator.alphaNumeric('123'), isNull);
        expect(Validator.alphaNumeric('hello'), isNull);
      });

      test('should return error for non-alphanumeric strings', () {
        const errorMessage = 'Only letters and numbers are allowed';
        expect(Validator.alphaNumeric('hello@world'), errorMessage);
        expect(Validator.alphaNumeric('hello world'), errorMessage);
        expect(Validator.alphaNumeric('hello-123'), errorMessage);
      });
    });

    group('numeric()', () {
      test('should return null for numeric strings', () {
        expect(Validator.numeric('123'), isNull);
        expect(Validator.numeric('0'), isNull);
        expect(Validator.numeric('999999'), isNull);
      });

      test('should return error for non-numeric strings', () {
        const errorMessage = 'Only numbers are allowed';
        expect(Validator.numeric('123abc'), errorMessage);
        expect(Validator.numeric('12.34'), errorMessage);
        expect(Validator.numeric('hello'), errorMessage);
        expect(Validator.numeric(''), errorMessage);
      });
    });

    group('url()', () {
      test('should return null for valid URLs', () {
        expect(Validator.url('https://example.com'), isNull);
        expect(Validator.url('http://test.org'), isNull);
        expect(Validator.url('https://sub.domain.com/path'), isNull);
      });

      test('should return error for invalid URLs', () {
        const errorMessage = 'Please enter a valid URL';
        expect(Validator.url('not-a-url'), errorMessage);
        expect(Validator.url('ftp://example.com'), errorMessage);
        expect(Validator.url('https://'), errorMessage);
        expect(Validator.url('example.com'), errorMessage);
      });
    });

    group('startsWith()', () {
      test('should return null for strings starting with prefix', () {
        expect(Validator.startsWith('hello world', 'hello'), isNull);
        expect(Validator.startsWith('test', 'test'), isNull);
        expect(Validator.startsWith('prefix_data', 'prefix'), isNull);
      });

      test('should return error for strings not starting with prefix', () {
        expect(
          Validator.startsWith('world hello', 'hello'),
          'Must start with "hello"',
        );
        expect(
          Validator.startsWith('test', 'prefix'),
          'Must start with "prefix"',
        );
      });
    });

    group('endsWith()', () {
      test('should return null for strings ending with suffix', () {
        expect(Validator.endsWith('hello world', 'world'), isNull);
        expect(Validator.endsWith('test.jpg', '.jpg'), isNull);
      });

      test('should return error for strings not ending with suffix', () {
        expect(
          Validator.endsWith('hello world', 'hello'),
          'Must end with "hello"',
        );
        expect(Validator.endsWith('test.png', '.jpg'), 'Must end with ".jpg"');
      });
    });

    group('contains()', () {
      test('should return null for strings containing substring', () {
        expect(Validator.contains('hello world', 'world'), isNull);
        expect(Validator.contains('test@email.com', '@'), isNull);
      });

      test('should return error for strings not containing substring', () {
        expect(
          Validator.contains('hello there', 'world'),
          'Must contain "world"',
        );
        expect(Validator.contains('test', 'admin'), 'Must contain "admin"');
      });
    });

    group('notContains()', () {
      test('should return null for strings not containing substring', () {
        expect(Validator.notContains('hello there', 'world'), isNull);
        expect(Validator.notContains('username', 'admin'), isNull);
      });

      test(
        'should return error for strings containing forbidden substring',
        () {
          expect(
            Validator.notContains('hello world', 'world'),
            'Must not contain "world"',
          );
          expect(
            Validator.notContains('admin_user', 'admin'),
            'Must not contain "admin"',
          );
        },
      );
    });

    group('inList()', () {
      test('should return null for values in allowed list', () {
        expect(Validator.inList('red', ['red', 'green', 'blue']), isNull);
        expect(Validator.inList('admin', ['admin', 'user', 'guest']), isNull);
      });

      test('should return error for values not in allowed list', () {
        expect(
          Validator.inList('yellow', ['red', 'green', 'blue']),
          'Must be one of: red, green, blue',
        );
        expect(
          Validator.inList('owner', ['admin', 'user']),
          'Must be one of: admin, user',
        );
      });
    });

    group('notInList()', () {
      test('should return null for values not in forbidden list', () {
        expect(Validator.notInList('user', ['admin', 'root']), isNull);
        expect(Validator.notInList('yellow', ['red', 'green']), isNull);
      });

      test('should return error for values in forbidden list', () {
        expect(
          Validator.notInList('admin', ['admin', 'root']),
          'Cannot be one of: admin, root',
        );
        expect(
          Validator.notInList('test', ['test', 'temp']),
          'Cannot be one of: test, temp',
        );
      });
    });

    group('rules()', () {
      test('should return null when all validators pass', () {
        final combinedValidator = Validator.rules([
          (value) => Validator.required(value),
          (value) => Validator.min(value, 3),
          (value) => Validator.alpha(value),
        ]);

        expect(combinedValidator('hello'), isNull);
        expect(combinedValidator('abc'), isNull);
      });

      test('should return first error encountered', () {
        final combinedValidator = Validator.rules([
          (value) => Validator.required(value),
          (value) => Validator.min(value, 3),
          (value) => Validator.alpha(value),
        ]);

        expect(combinedValidator(''), 'This field is required');
        expect(combinedValidator('hi'), 'Must be at least 3 characters');
        expect(combinedValidator('abc123'), 'Only letters are allowed');
      });

      test('should work with empty validator list', () {
        final emptyValidator = Validator.rules([]);
        expect(emptyValidator('anything'), isNull);
      });
    });
  });
}
