import 'bn.dart';

const List<String> _bnMonths = [
  'জানুয়ারি',
  'ফেব্রুয়ারি',
  'মার্চ',
  'এপ্রিল',
  'মে',
  'জুন',
  'জুলাই',
  'আগস্ট',
  'সেপ্টেম্বর',
  'অক্টোবর',
  'নভেম্বর',
  'ডিসেম্বর',
];

/// Formats a DateTime or ISO string into Bengali format, e.g. "১৩ অক্টোবর ২০২৬".
String formatBnDate(DateTime date, {bool useBnDigits = true}) {
  final day = useBnDigits ? toBn(date.day) : '${date.day}';
  final month = _bnMonths[date.month - 1];
  final year = useBnDigits ? toBn(date.year) : '${date.year}';
  return '$day $month $year';
}

/// Parses ISO date string (YYYY-MM-DD) and formats it into Bengali.
String formatIsoDate(String? isoDate, {bool useBnDigits = true}) {
  if (isoDate == null || isoDate.isEmpty) return '';
  try {
    final parsed = DateTime.parse(isoDate);
    return formatBnDate(parsed, useBnDigits: useBnDigits);
  } catch (_) {
    return isoDate;
  }
}
