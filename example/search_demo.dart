import 'package:clix/clix.dart';

Future<void> main() async {
  final logger = CliLogger();

  logger.infoMark('Search Prompt Demo');
  logger.newLine();

  final packages = <String>[
    'clix',
    'args',
    'http',
    'path',
    'yaml',
    'json_annotation',
    'json_serializable',
    'build_runner',
    'source_gen',
    'flutter',
    'flutter_test',
    'shared_preferences',
    'get',
    'dio',
    'riverpod',
    'provider',
    'go_router',
    'auto_route',
    'freezed',
    'equatable',
  ];

  final selectedIndex = await Search(
    prompt: 'Search package',
    options: packages,
    maxResults: 8,
  ).interact();

  logger.newLine();

  logger.success('Selected: ${packages[selectedIndex]}');
}
