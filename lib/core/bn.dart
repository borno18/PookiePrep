/// Converts Latin digits in [value] to Bengali digits (০১২৩৪৫৬৭৮৯).
String toBn(Object value) {
  const en = '0123456789';
  const bn = '০১২৩৪৫৬৭৮৯';
  var s = value.toString();
  for (var i = 0; i < en.length; i++) {
    s = s.replaceAll(en[i], bn[i]);
  }
  return s;
}

/// Formats a double score cleanly with optional Bengali digits (e.g. 15.25 -> "১৫.২৫" or "১৫").
String formatScore(double score, {bool useBnDigits = true}) {
  final isInt = (score % 1) == 0;
  final str = isInt ? score.toInt().toString() : score.toStringAsFixed(2);
  return useBnDigits ? toBn(str) : str;
}

/// Formats seconds into mm:ss format with optional Bengali digits (e.g. 125s -> "০২:০৫").
String formatTime(int totalSeconds, {bool useBnDigits = true}) {
  if (totalSeconds < 0) totalSeconds = 0;
  final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
  final secs = (totalSeconds % 60).toString().padLeft(2, '0');
  final result = '$mins:$secs';
  return useBnDigits ? toBn(result) : result;
}

/// Bengali option prefixes: ক, খ, গ, ঘ
const List<String> bnOptionLetters = ['ক', 'খ', 'গ', 'ঘ', 'ঙ'];
