// Copyright (c) 2026, the Clix project authors.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'cli_command_runner.dart';

/// Controls the presentation and styling of [CliCommandRunner] usage output.
///
/// This class is responsible for rendering command usage information from
/// structured [CliCommandUsageData]. It owns presentation concerns such as:
///
/// - Usage and section headings.
/// - Command categories and command names.
/// - Default command indicators.
/// - Text wrapping and column alignment.
/// - Footer and contextual information.
/// - Theme-based styling.
///
/// [CliCommandRunner] is responsible for collecting command information,
/// while this class is responsible for presenting that information.
class CliCommandRunnerLayout {
  CliCommandRunnerLayout({CliTheme? theme}) : theme = theme ?? CliContext.theme;

  /// The theme used to style command runner output.
  final CliTheme theme;

  /// Renders usage information from [data].
  ///
  /// The supplied command data is rendered using the configured [theme].
  ///
  /// Command usage elements use semantic theme styles:
  ///
  /// - Usage and section headings use [CliTheme.primary].
  /// - Categories use [CliTheme.tertiary].
  /// - Command names use [CliTheme.secondary].
  /// - Default command markers use [CliTheme.success].
  /// - Default-command notices use [CliTheme.gray].
  ///
  /// Optional usage sections such as [invocation], [optionsUsage],
  /// [footerHint], and [usageFooter] are included when provided.
  String renderUsage(
    CliCommandUsageData data, {
    bool isSubcommand = false,
    String? invocation,
    String? optionsUsage,
    String? optionsTitle,
    String? footerHint,
    String? usageFooter,
    int? lineLength,
  }) {
    final names = data.categories
        .expand((category) => category.commands)
        .map((command) => command.name);

    final nameWidth = names.isEmpty
        ? 0
        : names.map((name) => name.length).reduce(math.max);
    final columnStart = nameWidth + 5;

    var buffer = StringBuffer();

    if (invocation != null) {
      const usagePrefix = 'Usage:';
      buffer.writeln(
        '${theme.primary(usagePrefix)} '
        '${wrapText(invocation, hangingIndent: usagePrefix.length)}\n',
      );
    }

    if (optionsUsage != null) {
      if (optionsTitle != null) {
        buffer.writeln(theme.primary(optionsTitle));
      }

      buffer.writeln(optionsUsage);

      if (data.categories.isNotEmpty) {
        buffer.writeln();
      }
    }

    if (data.categories.isNotEmpty) {
      buffer.write(
        theme.primary('Available ${isSubcommand ? "sub" : ""}commands:'),
      );

      for (var category in data.categories) {
        if (category.name != '') {
          buffer.writeln();
          buffer.writeln();
          buffer.write(theme.tertiary(category.name));
        }

        for (var command in category.commands) {
          final usageLine = _CommandUsageLine(
            summary: command.summary,
            isDefault: data.defaultCommand == command.name,
          );

          final text = usageLine.isDefault
              ? '(default) ${usageLine.summary}'
              : usageLine.summary;

          final lines = wrapTextAsLines(
            text,
            start: columnStart,
            length: lineLength,
          );

          final firstLine = usageLine.isDefault
              ? '${theme.success('(default)')} '
                    '${lines.first.substring('(default) '.length)}'
              : lines.first;

          buffer.writeln();
          final commandName = theme.secondary(command.name);
          final commandPadding = ' ' * (nameWidth - command.name.length);

          buffer.write('  $commandName$commandPadding   $firstLine');

          for (var line in lines.skip(1)) {
            buffer.writeln();
            buffer.write(' ' * columnStart);
            buffer.write(line);
          }
        }
      }
    }

    if (data.defaultCommand != null) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(
        theme.gray(
          wrapText(
            'Default command (${data.defaultCommand}) will be selected if no command'
            ' is explicitly specified.',
            length: lineLength,
          ),
        ),
      );
    }

    if (footerHint != null) {
      if (data.categories.isNotEmpty || data.defaultCommand != null) {
        buffer.writeln();
        buffer.writeln();
      } else {
        buffer.writeln();
      }

      buffer.write(wrapText(footerHint, length: lineLength));
    }

    if (usageFooter != null) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(wrapText(usageFooter, length: lineLength));
    }

    return buffer.toString();
  }
}
