// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'cli_parser.dart';
import 'cli_arg_results.dart';
import 'cli_option.dart';
import 'cli_parser_base.dart';

/// An CliParser that treats *all input* as non-option arguments.
class CliAllowAnythingParser implements CliParser {
  @override
  Map<String, CliOption> get options => const {};
  @override
  Map<String, CliParser> get commands => const {};
  @override
  bool get allowTrailingOptions => false;
  @override
  bool get allowsAnything => true;
  @override
  int? get usageLineLength => null;

  @override
  CliParser addCommand(String name, [CliParser? parser]) {
    throw UnsupportedError(
      "CliParser.allowAnything().addCommands() isn't supported.",
    );
  }

  @override
  void addFlag(
    String name, {
    String? abbr,
    String? help,
    bool? defaultsTo = false,
    bool negatable = true,
    void Function(bool)? callback,
    bool hide = false,
    bool hideNegatedUsage = false,
    List<String> aliases = const [],
  }) {
    throw UnsupportedError(
      "CliParser.allowAnything().addFlag() isn't supported.",
    );
  }

  @override
  void addOption(
    String name, {
    String? abbr,
    String? help,
    String? valueHelp,
    Iterable<String>? allowed,
    Map<String, String>? allowedHelp,
    String? defaultsTo,
    void Function(String?)? callback,
    bool mandatory = false,
    bool hide = false,
    List<String> aliases = const [],
  }) {
    throw UnsupportedError(
      "CliParser.allowAnything().addOption() isn't supported.",
    );
  }

  @override
  void addMultiOption(
    String name, {
    String? abbr,
    String? help,
    String? valueHelp,
    Iterable<String>? allowed,
    Map<String, String>? allowedHelp,
    Iterable<String>? defaultsTo,
    void Function(List<String>)? callback,
    bool splitCommas = true,
    bool hide = false,
    List<String> aliases = const [],
  }) {
    throw UnsupportedError(
      "CliParser.allowAnything().addMultiOption() isn't supported.",
    );
  }

  @override
  void addSeparator(String text) {
    throw UnsupportedError(
      "CliParser.allowAnything().addSeparator() isn't supported.",
    );
  }

  @override
  CliArgResults parse(Iterable<String> args) =>
      CliParserBase(null, this, Queue.of(args)).parse();

  @override
  String get usage => '';

  @override
  dynamic defaultFor(String option) {
    throw ArgumentError('No option named $option');
  }

  @override
  CliOption? findByAbbreviation(String abbr) => null;

  @override
  CliOption? findByNameOrAlias(String name) => null;

  @override
  String? get defaultCommand => null;

  @override
  set defaultCommand(String? value) => throw UnsupportedError(
    "CliParser.allowAnything().defaultCommand= isn't supported.",
  );
}
