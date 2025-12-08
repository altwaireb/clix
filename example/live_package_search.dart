/// Live Package Search Demo - demonstrates real-time API integration
///
/// This example shows how to use Clix Search prompt with live API calls.
/// As you type, it searches pub.dev in real-time and updates results instantly.
///
/// Features demonstrated:
/// - Live search function integration
/// - Real-time API calls to pub.dev
/// - Error handling for network requests
/// - Professional search UX
/// - Dynamic result filtering
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clix/clix.dart';

/// Example of static options for comparison
void demonstrateStaticSearch() async {
  // Simple static search - traditional approach
  final result = await Search(
    prompt: 'Choose a popular Dart package',
    options: ['http', 'path', 'collection', 'meta', 'crypto'],
  ).interact();
  print('Selected index: $result');
}

/// Live package search function
Future<List<String>> searchPubDev(String query) async {
  if (query.trim().isEmpty) {
    return [];
  }

  try {
    final uri = Uri.parse(
      'https://pub.dev/api/search?q=${Uri.encodeComponent(query)}&size=15',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['packages'] as List)
          .map((pkg) => pkg['package'] as String)
          .toList();
    }
  } catch (e) {
    // Return empty list if search fails
  }

  return [];
}

/// Get detailed package information from pub.dev
Future<Map<String, String>> getPackageDetails(String packageName) async {
  try {
    final uri = Uri.parse('https://pub.dev/api/packages/$packageName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Get basic package info
      final name = data['name'] ?? packageName;
      final latest = data['latest'] ?? {};
      final pubspec = latest['pubspec'] ?? {};
      final version = latest['version'] ?? 'unknown';
      final description = pubspec['description'] ?? 'No description available';

      // Format description
      final formattedDescription = description.replaceAll('\n', ' ').trim();
      final truncatedDescription = formattedDescription.length > 45
          ? '${formattedDescription.substring(0, 42)}...'
          : formattedDescription;

      return {
        'name': name,
        'version': version,
        'description': truncatedDescription,
        'url': 'https://pub.dev/packages/$name',
        'likes': 'N/A', // This requires metrics API
        'popularity': 'N/A', // This requires metrics API
      };
    }
  } catch (e) {
    // Return basic info if API call fails
  }

  return {
    'name': packageName,
    'version': 'unknown',
    'description': 'Details not available',
    'url': 'https://pub.dev/packages/$packageName',
    'likes': 'N/A',
    'popularity': 'N/A',
  };
}

/// Live demonstration of Search prompt with real-time pub.dev API
void main() async {
  final logger = CliLogger();

  logger.withIcon('🔍 Live Package Search Demo', icon: CliIcons.rocket);
  logger.newLine();

  logger.info('This example searches pub.dev in real-time as you type!');
  logger.infoIcon('Try typing: "http", "json", "state", "firebase", etc.');
  logger.warnIcon('Type at least 2 characters to start searching');
  logger.newLine();

  try {
    // Store search results to get the selected package name
    List<String> lastSearchResults = [];

    // Use Search prompt with live search function
    // 🚀 This demonstrates Clix's powerful flexibility:
    // - options can be a static List<String> for simple cases
    // - options can be a Function(String) => Future<List<String>> for dynamic/live search
    // - This enables real-time API integration with zero performance issues!
    final selectedIndex = await Search(
      prompt: 'Search pub.dev packages (live search)',
      options: (String query) async {
        final results = await searchPubDev(query);
        lastSearchResults = results; // Store for later use
        return results;
      },
      minQueryLength: 2,
    ).interact();

    if (selectedIndex == -1 || selectedIndex >= lastSearchResults.length) {
      logger.warnIcon('No package selected');
      return;
    }

    // Get the selected package name
    final selectedPackage = lastSearchResults[selectedIndex];

    // Show loading while fetching details
    final detailSpinner = logger.spinner('Fetching package details...');

    // Get detailed package information
    final packageDetails = await getPackageDetails(selectedPackage);
    detailSpinner.complete('Package details loaded!');

    // Show success information
    logger.newLine();
    logger.successIcon('🎉 Package selected: ${packageDetails['name']}');
    logger.newLine();

    // Create detailed package info table
    final infoTable = logger.table(
      columns: [
        TableColumn('Property', width: 20),
        TableColumn('Details', width: 50),
      ],
      rows: [
        ['Package Name', packageDetails['name']!],
        ['Latest Version', 'v${packageDetails['version']}'],
        ['Description', packageDetails['description']!],
        ['Community Likes', packageDetails['likes']!],
        ['Popularity Score', packageDetails['popularity']!],
        ['pub.dev URL', packageDetails['url']!],
        ['Install Command', 'dart pub add ${packageDetails['name']}'],
        ['Flutter Command', 'flutter pub add ${packageDetails['name']}'],
      ],
    );

    print(infoTable.render());

    logger.newLine();
    logger.ideaIcon('This demonstrates live search with real package data!');
    logger.infoIcon(
      'Search results update as you type - no pre-loading needed',
    );
    logger.successIcon('Copy the install command above to add this package! ✨');
  } catch (e) {
    logger.errorIcon('Error: $e');
  }
}
