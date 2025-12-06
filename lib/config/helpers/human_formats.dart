import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int fractionDigits = 0]) {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: fractionDigits,
      symbol: '',
      locale: 'en_US',
    ).format(number);
    return formatterNumber;
  }
}
