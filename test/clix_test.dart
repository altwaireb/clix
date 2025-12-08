import 'package:clix/clix.dart';
import 'package:test/test.dart';

// Import all test files
import 'unit/prompts/input_prompt_test.dart' as input_tests;
import 'unit/prompts/confirm_prompt_test.dart' as confirm_tests;
import 'unit/prompts/select_prompt_test.dart' as select_tests;
import 'unit/prompts/multiselect_prompt_test.dart' as multiselect_tests;
import 'unit/prompts/number_prompt_test.dart' as number_tests;
import 'unit/prompts/decimal_prompt_test.dart' as decimal_tests;
import 'unit/prompts/search_prompt_test.dart' as search_tests;
import 'unit/logger/cli_logger_test.dart' as logger_tests;
import 'unit/table/table_test.dart' as table_tests;

// import 'unit/core/style_test.dart' as style_tests;
// import 'unit/core/theme_test.dart' as theme_tests;
// import 'unit/core/io_test.dart' as io_tests;

// import 'integration/full_workflow_test.dart' as integration_tests;

void main() {
  group('🎯 Clix Library Tests', () {
    // Basic library test
    group('📦 Core Library', () {
      test('logger should work', () {
        expect(Clix.logger, isNotNull);
      });
    });

    // Comprehensive prompt tests
    group('📝 Prompt Tests', () {
      input_tests.main();
      confirm_tests.main();
      select_tests.main();
      multiselect_tests.main();
      number_tests.main();
      decimal_tests.main();
      search_tests.main();
    });

    // Logger tests
    group('📊 Logger Tests', () {
      logger_tests.main();
    });

    // Table tests
    group('📋 Table Tests', () {
      table_tests.main();
    });

    // group('🎨 Core Component Tests', () {
    //   style_tests.main();
    //   theme_tests.main();
    //   io_tests.main();
    // });

    // group('🔗 Integration Tests', () {
    //   integration_tests.main();
    // });
  });
}
