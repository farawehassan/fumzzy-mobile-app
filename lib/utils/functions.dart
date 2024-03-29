import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Functions{

  /// Convert a double [value] to a currency
  static String money(double value, String currency) {
    final nf = NumberFormat('#\,##0', 'en_US');
    return '${currencyMap[currency]}${nf.format(value)}';
  }

  /// Convert a double [value] to a currency
  static String money0(double value, String currency) {
    final nf = NumberFormat('#\,##0', 'en_US');
    return '${currencyMap[currency]}${nf.format(value)}';
  }

  static void showErrorMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFFF64932),
      textColor: Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }

  static void showSuccessMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFF00AF27),
      textColor: Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }

  /// Converting [dateTime] to return a formatted time
  /// of weekday, day, month and year
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM, y').format(dateTime).toString();
  }

  /// Converting [dateTime] to return a formatted time
  /// of weekday, day, month and year
  static String getFormattedShortDate(DateTime dateTime) {
    return DateFormat('EEE, d MMM, y').format(dateTime).toString();
  }

  /// Converting [dateTime] to return a formatted time
  /// hour with am or pm
  static String getFormattedTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime).toString();
  }

  /// Converting [dateTime] to return a formatted time
  /// of day, month, hour with am or pm
  static String getFormattedDateTime(DateTime dateTime) { // 23, May\n12:130pm
    return DateFormat('d, MMM\nh:mm a').format(dateTime).toString();
  }

  /// Converting [dateTime] to return a formatted time
  /// of day, month, hour with am or pm
  static String getFormattedDateTimeN(DateTime dateTime) { // 23, May\n12:130pm
    return DateFormat('d, MMM h:mm a').format(dateTime).toString();
  }

  /// Converting [dateTime] to return a formatted time
  /// of day, month, hour with am or pm
  static String getFormattedDateTimeY(DateTime dateTime) { // 23, May\n12:130pm
    return DateFormat('d, MMM y h:mm a').format(dateTime).toString();
  }

}

const Map currencyMap = {
  null: '',
  '': '',
  'USD': '\$',
  'CAD': '\$',
  'EUR': '€',
  'AED': 'د.إ.‏',
  'AFN': '؋',
  'ALL': 'Lek',
  'AMD': 'դր.',
  'ARS': '\$',
  'AUD': '\$',
  'AZN': 'ман.',
  'BAM': 'KM',
  'BDT': '৳',
  'BGN': 'лв.',
  'BHD': 'د.ب.‏',
  'BIF': 'FBu',
  'BND': '\$',
  'BOB': 'Bs',
  'BRL': 'R\$',
  'BWP': 'P',
  'BYR': 'BYR',
  'BZD': '\$',
  'CDF': 'FrCD',
  'CHF': 'CHF',
  'CLP': '\$',
  'CNY': 'CN¥',
  'COP': '\$',
  'CRC': '₡',
  'CVE': 'CV\$',
  'CZK': 'Kč',
  'DJF': 'Fdj',
  'DKK': 'kr',
  'DOP': 'RD\$',
  'DZD': 'د.ج.‏',
  'EEK': 'kr',
  'EGP': 'ج.م.‏',
  'ERN': 'Nfk',
  'ETB': 'Br',
  'GBP': '£',
  'GEL': 'GEL',
  'GHS': 'GH₵',
  'GNF': 'FG',
  'GTQ': 'Q',
  'HKD': '\$',
  'HNL': 'L',
  'HRK': 'kn',
  'HUF': 'Ft',
  'IDR': 'Rp',
  'ILS': '₪',
  'INR': '₹',
  'IQD': 'د.ع.‏',
  'IRR': '﷼',
  'ISK': 'kr',
  'JMD': '\$',
  'JOD': 'د.أ.‏',
  'JPY': '￥',
  'KES': 'Ksh',
  'KHR': '៛',
  'KMF': 'FC',
  'KRW': '₩',
  'KWD': 'د.ك.‏',
  'KZT': 'тңг.',
  'LBP': 'ل.ل.‏',
  'LKR': 'SL Re',
  'LTL': 'Lt',
  'LVL': 'Ls',
  'LYD': 'د.ل.‏',
  'MAD': 'د.م.‏',
  'MDL': 'MDL',
  'MGA': 'MGA',
  'MKD': 'MKD',
  'MMK': 'K',
  'MOP': 'MOP\$',
  'MUR': 'MURs',
  'MXN': '\$',
  'MYR': 'RM',
  'MZN': 'MTn',
  'NAD': 'N\$',
  'NGN': 'N',
  'N': '₦',
  'NIO': 'C\$',
  'NOK': 'kr',
  'NPR': 'नेरू',
  'NZD': '\$',
  'OMR': 'ر.ع.‏',
  'PAB': 'B/.',
  'PEN': 'S/.',
  'PHP': '₱',
  'PKR': '₨',
  'PLN': 'zł',
  'PYG': '₲',
  'QAR': 'ر.ق.‏',
  'RON': 'RON',
  'RSD': 'дин.',
  'RUB': 'руб.',
  'RWF': 'FR',
  'SAR': 'ر.س.‏',
  'SDG': 'SDG',
  'SEK': 'kr',
  'SGD': '\$',
  'SOS': 'Ssh',
  'SYP': 'ل.س.‏',
  'THB': '฿',
  'TND': 'د.ت.‏',
  'TOP': 'T\$',
  'TRY': 'TL',
  'TTD': '\$',
  'TWD': 'NT\$',
  'TZS': 'TSh',
  'UAH': '₴',
  'UGX': 'USh',
  'UYU': '\$',
  'UZS': 'UZS',
  'VEF': 'Bs.F.',
  'VND': '₫',
  'XAF': 'FCFA',
  'XOF': 'CFA',
  'YER': 'ر.ي.‏',
  'ZAR': 'R',
  'ZMK': 'ZK',
};