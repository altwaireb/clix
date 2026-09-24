class PromptCancelledException implements Exception {
  const PromptCancelledException();

  @override
  String toString() => 'Prompt cancelled.';
}
