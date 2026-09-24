import 'package:clix/clix.dart';
import 'package:test/test.dart';

import 'helpers/mock_io.dart';

void main() {
  group('Core Library', () {
    tearDown(Clix.reset);

    test('logger should work', () {
      expect(Clix.logger, isNotNull);
    });

    test('theme should use the global CliContext theme', () {
      final theme = CliTheme(
        primary: CliStyle().withColor(CliColor.cyan),
        secondary: CliStyle().withColor(CliColor.orange),
      );

      Clix.useTheme(theme);

      expect(Clix.theme, same(theme));
      expect(Clix.logger.theme, same(theme));
    });

    test('configure should update the global theme', () {
      final theme = CliTheme(primary: CliStyle().withColor(CliColor.cyan));

      Clix.configure(theme: theme);

      expect(Clix.theme, same(theme));
      expect(Clix.logger.theme, same(theme));
    });

    test('configure should update the global IO', () {
      final io = MockIO();

      Clix.configure(io: io);

      expect(Clix.io, same(io));
      expect(Clix.logger.io, same(io));
    });
  });
}
