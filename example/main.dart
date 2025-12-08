import 'package:clix/clix.dart';

Future<void> main() async {
  final logger = CliLogger();

  logger.withIcon('Welcome to Clix!', icon: CliIcons.rocket);
  logger.newLine();

  logger.success('Easy colored logging');
  logger.warnIcon('Built-in warning styles');
  logger.info('Clean professional output', showPrefix: true);
  logger.newLine();

  final customColor = CliColor.hex('#FF6B6B');
  logger.plain(customColor('Custom hex colors'));
  logger.newLine();

  logger.info('Progress indicators:');
  final spinner = logger.spinner('Processing...'); // Uses logger's theme
  await Future.delayed(Duration(milliseconds: 1000));
  spinner.complete('Complete!');
  logger.newLine();

  final name = await Input(prompt: 'Your name').interact();
  logger.success('Hello, $name!');
  logger.newLine();

  logger.info('List formatting:');
  logger.point('Bullet points');
  logger.point('Nested items', indent: IndentLevel.level1);
  logger.newLine();

  logger.info('Tree structures:');
  logger.tree('Project structure');
  logger.tree('src/', symbol: TreeSymbol.level1);
  logger.treeWithIcon(
    'main.dart',
    icon: CliIcons.success,
    symbol: TreeSymbol.level2,
  );
  logger.treeWithIcon(
    'utils.dart',
    icon: CliIcons.file,
    symbol: TreeSymbol.level2,
  );
  logger.newLine();

  logger.info('Data tables:');

  // Convenience method with automatic theme inheritance
  final statusTable = logger.table(
    columns: [
      TableColumn('Name'),
      TableColumn('Version', alignment: TableAlignment.center),
      TableColumn('Status', alignment: TableAlignment.right),
    ],
    rows: [
      ['Dart', '3.0+', 'Ready'],
      ['Flutter', '3.16+', 'Ready'],
      ['Clix', '1.0.0', 'Active'],
    ],
  );
  logger.plain(statusTable.render());
  logger.newLine();

  // Direct Table constructor for custom styling
  logger.info('Custom styled table:');
  final customTable = Table(
    columns: [
      TableColumn('Task'),
      TableColumn('Duration', alignment: TableAlignment.right),
    ],
    rows: [
      ['Setup', '0.5s'],
      ['Build', '2.1s'],
      ['Test', '1.8s'],
    ],
    headerStyle: CliStyle().withColor(CliColor.green).makeBold(),
    borderStyle: CliStyle().withColor(CliColor.blue),
  );
  logger.plain(customTable.render());

  logger.primary('Ready to build CLI apps with Clix!');
}
