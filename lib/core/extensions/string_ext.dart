extension StringExt on String {
  int get toIntegerFromText {
    final cleanedText = replaceAll(RegExp(r'[^0-9]'), '');
    final parsedValue = int.tryParse(cleanedText) ?? 0;
    return parsedValue;
  }
}

// extension StringExt on String {
//   double get toDoubleFromText {
//     final cleanedText = replaceAll(RegExp(r'[^0-9.]'), ''); // Allow decimal point
//     final parsedValue = double.tryParse(cleanedText) ?? 0.0;
//     return parsedValue;
//   }
// }