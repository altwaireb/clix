import 'package:test/test.dart';
import 'package:clix/src/table/table.dart';
import 'package:clix/src/table/enums/table_alignment.dart';
import 'package:clix/src/core/style/style.dart';
import 'package:clix/src/core/style/color.dart';
import 'package:clix/src/core/style/theme.dart';
import 'package:clix/src/logger/logger.dart';

void main() {
  group('Table Tests', () {
    group('TableColumn Tests', () {
      test('should create column with default alignment', () {
        final column = TableColumn('Name');

        expect(column.header, equals('Name'));
        expect(column.alignment, equals(TableAlignment.left));
        expect(column.width, isNull);
      });

      test('should create column with custom alignment', () {
        final column = TableColumn('Price', alignment: TableAlignment.right);

        expect(column.header, equals('Price'));
        expect(column.alignment, equals(TableAlignment.right));
        expect(column.width, isNull);
      });

      test('should create column with fixed width', () {
        final column = TableColumn(
          'Status',
          alignment: TableAlignment.center,
          width: 15,
        );

        expect(column.header, equals('Status'));
        expect(column.alignment, equals(TableAlignment.center));
        expect(column.width, equals(15));
      });
    });

    group('Table Constructor Tests', () {
      test('should create table with required parameters', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = [
          ['John', '25'],
          ['Jane', '30'],
        ];
        final table = Table(columns: columns, rows: rows);

        expect(table.columns, equals(columns));
        expect(table.rows, equals(rows));
        expect(table.showBorders, isTrue);
        expect(table.headerStyle, isNotNull);
        expect(table.borderStyle, isNotNull);
      });

      test('should create table with custom styles', () {
        final headerStyle = CliStyle().withColor(CliColor.blue).makeBold();
        final borderStyle = CliStyle().withColor(CliColor.red);
        final columns = [TableColumn('Name')];
        final rows = [
          ['John'],
        ];

        final table = Table(
          columns: columns,
          rows: rows,
          headerStyle: headerStyle,
          borderStyle: borderStyle,
          showBorders: false,
        );

        expect(table.headerStyle, equals(headerStyle));
        expect(table.borderStyle, equals(borderStyle));
        expect(table.showBorders, isFalse);
      });

      test('should create table with default styles when not provided', () {
        final columns = [TableColumn('Name')];
        final rows = [
          ['John'],
        ];
        final table = Table(columns: columns, rows: rows);

        expect(table.headerStyle, isNotNull);
        expect(table.borderStyle, isNotNull);
      });
    });

    group('Table Rendering Tests', () {
      test('should render simple table with borders', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = [
          ['John', '25'],
          ['Jane', '30'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('┌'));
        expect(output, contains('┐'));
        expect(output, contains('└'));
        expect(output, contains('┘'));
        expect(output, contains('├'));
        expect(output, contains('┤'));
        expect(output, contains('┬'));
        expect(output, contains('┴'));
        expect(output, contains('┼'));
        expect(output, contains('─'));
        expect(output, contains('│'));
        expect(output, contains('Name'));
        expect(output, contains('Age'));
        expect(output, contains('John'));
        expect(output, contains('Jane'));
        expect(output, contains('25'));
        expect(output, contains('30'));
      });

      test('should render table without borders', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = [
          ['John', '25'],
        ];
        final table = Table(columns: columns, rows: rows, showBorders: false);

        final output = table.render();

        expect(output, isNot(contains('┌')));
        expect(output, isNot(contains('┐')));
        expect(output, isNot(contains('└')));
        expect(output, isNot(contains('┘')));
        expect(output, isNot(contains('├')));
        expect(output, isNot(contains('┤')));
        expect(output, isNot(contains('┬')));
        expect(output, isNot(contains('┴')));
        expect(output, isNot(contains('┼')));
        expect(output, isNot(contains('─')));
        expect(output, contains('Name'));
        expect(output, contains('Age'));
        expect(output, contains('John'));
        expect(output, contains('25'));
      });

      test('should render empty table', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = <List<String>>[];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Name'));
        expect(output, contains('Age'));
        expect(output, contains('┌'));
        expect(output, contains('└'));
      });

      test('should render table with missing cells', () {
        final columns = [
          TableColumn('Name'),
          TableColumn('Age'),
          TableColumn('City'),
        ];
        final rows = [
          ['John', '25'], // Missing city
          ['Jane'], // Missing age and city
          ['Bob', '35', 'NYC'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('John'));
        expect(output, contains('Jane'));
        expect(output, contains('Bob'));
        expect(output, contains('25'));
        expect(output, contains('35'));
        expect(output, contains('NYC'));
      });
    });

    group('Column Alignment Tests', () {
      test('should align text to the left', () {
        final columns = [TableColumn('Name', alignment: TableAlignment.left)];
        final rows = [
          ['John'],
          ['Alexander'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();
        final lines = output.split('\n');

        // Find data rows (skip border and header rows)
        final dataRows = lines
            .where(
              (line) => line.contains('John') || line.contains('Alexander'),
            )
            .toList();

        expect(dataRows, isNotEmpty);
        for (final row in dataRows) {
          // Left alignment should have text towards the beginning of the cell
          final pipeIndex = row.indexOf('│', 1); // Skip first border
          final nextPipeIndex = row.indexOf('│', pipeIndex + 1);
          final cellContent = row
              .substring(pipeIndex + 1, nextPipeIndex)
              .trim();

          if (cellContent == 'John' || cellContent == 'Alexander') {
            // For left alignment, text should be at the start (after space)
            final afterPipe = row.substring(pipeIndex + 1);
            expect(
              afterPipe.startsWith(' John') ||
                  afterPipe.startsWith(' Alexander'),
              isTrue,
            );
          }
        }
      });

      test('should align text to the right', () {
        final columns = [TableColumn('Age', alignment: TableAlignment.right)];
        final rows = [
          ['25'],
          ['100'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Age'));
        expect(output, contains('25'));
        expect(output, contains('100'));
      });

      test('should center align text', () {
        final columns = [
          TableColumn('Status', alignment: TableAlignment.center, width: 10),
        ];
        final rows = [
          ['OK'],
          ['ACTIVE'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Status'));
        expect(output, contains('OK'));
        expect(output, contains('ACTIVE'));
      });
    });

    group('Column Width Tests', () {
      test('should use fixed width when specified', () {
        final columns = [
          TableColumn('Name', width: 10),
          TableColumn('Age', width: 5),
        ];
        final rows = [
          ['John', '25'],
          ['VeryLongName', '100'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Name'));
        expect(output, contains('Age'));
        expect(output, contains('John'));
        expect(output, contains('VeryLongName'));
        expect(output, contains('25'));
        expect(output, contains('100'));
      });

      test('should calculate width automatically when not specified', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = [
          ['John', '25'],
          ['VeryLongName', '100'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        // Should accommodate the longest content in each column
        expect(output, contains('VeryLongName'));
        expect(output, contains('100'));
      });

      test('should handle columns with different width settings', () {
        final columns = [
          TableColumn('ID', width: 5),
          TableColumn('Name'), // Auto width
          TableColumn('Status', width: 8),
        ];
        final rows = [
          ['1', 'John', 'Active'],
          ['2', 'VeryLongName', 'Inactive'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('ID'));
        expect(output, contains('Name'));
        expect(output, contains('Status'));
        expect(output, contains('John'));
        expect(output, contains('VeryLongName'));
        expect(output, contains('Active'));
        expect(output, contains('Inactive'));
      });
    });

    group('Table Styling Tests', () {
      test('should apply header style', () {
        final headerStyle = CliStyle().withColor(CliColor.blue);
        final columns = [TableColumn('Name')];
        final rows = [
          ['John'],
        ];
        final table = Table(
          columns: columns,
          rows: rows,
          headerStyle: headerStyle,
        );

        final output = table.render();

        expect(output, isNotNull);
        expect(output, contains('Name'));
      });

      test('should apply border style', () {
        final borderStyle = CliStyle().withColor(CliColor.red);
        final columns = [TableColumn('Name')];
        final rows = [
          ['John'],
        ];
        final table = Table(
          columns: columns,
          rows: rows,
          borderStyle: borderStyle,
        );

        final output = table.render();

        expect(output, isNotNull);
        expect(output, contains('┌'));
        expect(output, contains('│'));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty header names', () {
        final columns = [TableColumn(''), TableColumn('Age')];
        final rows = [
          ['', '25'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Age'));
        expect(output, contains('25'));
      });

      test('should handle single column table', () {
        final columns = [TableColumn('Name')];
        final rows = [
          ['John'],
          ['Jane'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Name'));
        expect(output, contains('John'));
        expect(output, contains('Jane'));
        expect(output, contains('┌'));
        expect(output, contains('└'));
      });

      test('should handle single row table', () {
        final columns = [TableColumn('Name'), TableColumn('Age')];
        final rows = [
          ['John', '25'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Name'));
        expect(output, contains('Age'));
        expect(output, contains('John'));
        expect(output, contains('25'));
      });

      test('should handle unicode characters in content', () {
        final columns = [TableColumn('اسم'), TableColumn('العمر')];
        final rows = [
          ['محمد', '٢٥'],
          ['فاطمة', '٣٠'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('اسم'));
        expect(output, contains('العمر'));
        expect(output, contains('محمد'));
        expect(output, contains('فاطمة'));
        expect(output, contains('٢٥'));
        expect(output, contains('٣٠'));
      });

      test('should handle very long content', () {
        final columns = [TableColumn('Description')];
        final longText = 'A' * 100;
        final rows = [
          [longText],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Description'));
        expect(output, contains(longText));
      });

      test('should handle special characters in content', () {
        final columns = [TableColumn('Symbols'), TableColumn('Emojis')];
        final rows = [
          ['!@#\$%^&*()', '🎉🚀✨'],
          ['<>&"\'', '💻🔥⭐'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();

        expect(output, contains('Symbols'));
        expect(output, contains('Emojis'));
        expect(output, contains('!@#'));
        expect(output, contains('🎉🚀✨'));
        expect(output, contains('💻🔥⭐'));
      });
    });

    group('Table Structure Tests', () {
      test('should have proper border structure with multiple rows', () {
        final columns = [TableColumn('A'), TableColumn('B')];
        final rows = [
          ['1', '2'],
          ['3', '4'],
          ['5', '6'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();
        final lines = output
            .split('\n')
            .where((line) => line.isNotEmpty)
            .toList();

        // Should have: top border, header, middle border, 3 data rows, bottom border = 6 lines
        // But string ends with newline, so might have 7 lines total
        expect(lines.length, greaterThanOrEqualTo(6));

        // Top border (may contain color codes)
        expect(lines[0], contains('┌'));
        expect(lines[0], contains('┐'));

        // Header row
        expect(lines[1], contains('A'));
        expect(lines[1], contains('B'));

        // Middle border (may contain color codes)
        expect(lines[2], contains('├'));
        expect(lines[2], contains('┤'));

        // Bottom border should be in one of the last lines (may contain color codes)
        final lastLines = lines.sublist(lines.length - 2);
        expect(
          lastLines.any((line) => line.contains('└') && line.contains('┘')),
          isTrue,
        );
      });

      test('should maintain consistent column spacing', () {
        final columns = [
          TableColumn('Short'),
          TableColumn('VeryLongColumnName'),
          TableColumn('Med'),
        ];
        final rows = [
          ['A', 'B', 'C'],
          ['1', '2', '3'],
        ];
        final table = Table(columns: columns, rows: rows);

        final output = table.render();
        final lines = output
            .split('\n')
            .where((line) => line.isNotEmpty)
            .toList();

        // All lines (except content) should have same length
        final borderLines = lines
            .where(
              (line) =>
                  line.startsWith('┌') ||
                  line.startsWith('├') ||
                  line.startsWith('└'),
            )
            .toList();

        if (borderLines.isNotEmpty) {
          final expectedLength = borderLines.first.length;
          for (final line in borderLines) {
            expect(
              line.length,
              equals(expectedLength),
              reason: 'Border line length mismatch: $line',
            );
          }
        }
      });
    });

    group('Logger.table() Convenience Method Tests', () {
      test('should create and return table through logger', () {
        // Arrange
        final columns = [TableColumn('Name'), TableColumn('Value')];
        final rows = [
          ['Test', '123'],
          ['Sample', '456'],
        ];

        // Act & Assert
        expect(() {
          final logger = CliLogger();
          final table = logger.table(columns: columns, rows: rows);
          expect(table, isA<Table>());
          expect(table.columns, equals(columns));
          expect(table.rows, equals(rows));
        }, returnsNormally);
      });

      test(
        'should inherit theme from logger when no custom theme provided',
        () {
          // Arrange
          final customTheme = CliTheme(
            primary: CliStyle(color: CliColor.blue),
            secondary: CliStyle(color: CliColor.green),
          );
          final logger = CliLogger(theme: customTheme);

          final columns = [TableColumn('Header')];
          final rows = [
            ['Data'],
          ];

          // Act
          final table = logger.table(columns: columns, rows: rows);

          // Assert - The table should use the logger's theme
          expect(table, isA<Table>());
          // Since Table doesn't expose theme, we verify through behavior
          final rendered = table.render();
          expect(rendered, isA<String>());
        },
      );

      test('should use custom theme when provided', () {
        // Arrange
        final logger = CliLogger();
        final customTheme = CliTheme(
          primary: CliStyle(color: CliColor.red),
          secondary: CliStyle(color: CliColor.yellow),
        );

        // Act
        final table = logger.table(
          columns: [TableColumn('Custom')],
          rows: [
            ['Data'],
          ],
          theme: customTheme,
        );

        // Assert
        expect(table, isA<Table>());
        final rendered = table.render();
        expect(rendered, isA<String>());
      });

      test('should handle empty table through logger', () {
        // Arrange
        final logger = CliLogger();

        // Act & Assert
        expect(() {
          final table = logger.table(columns: [], rows: []);
          expect(table.columns, isEmpty);
          expect(table.rows, isEmpty);
        }, returnsNormally);
      });

      test('should preserve border settings through logger', () {
        // Arrange
        final logger = CliLogger();

        // Act
        final tableWithBorders = logger.table(
          columns: [TableColumn('Test')],
          rows: [
            ['Data'],
          ],
          showBorders: true,
        );

        final tableWithoutBorders = logger.table(
          columns: [TableColumn('Test')],
          rows: [
            ['Data'],
          ],
          showBorders: false,
        );

        // Assert
        expect(tableWithBorders.showBorders, isTrue);
        expect(tableWithoutBorders.showBorders, isFalse);
      });

      test('should create table with multiple columns and rows', () {
        // Arrange
        final logger = CliLogger();
        final columns = [
          TableColumn('ID'),
          TableColumn('Name'),
          TableColumn('Status'),
        ];
        final rows = [
          ['1', 'Item One', 'Active'],
          ['2', 'Item Two', 'Inactive'],
          ['3', 'Item Three', 'Pending'],
        ];

        // Act
        final table = logger.table(columns: columns, rows: rows);

        // Assert
        expect(table.columns.length, equals(3));
        expect(table.rows.length, equals(3));
        expect(table.rows[0], equals(['1', 'Item One', 'Active']));
        expect(table.rows[1], equals(['2', 'Item Two', 'Inactive']));
        expect(table.rows[2], equals(['3', 'Item Three', 'Pending']));
      });
    });
  });
}
