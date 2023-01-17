

import 'package:intl/intl.dart';

mixin Utilities {

  int? getYearFromDate(String? date) =>
      date != null ? DateTime.tryParse(date)?.year : null;

  String getYearStringFromDate(String? date) =>
      '${getYearFromDate(date) ?? ''}';

}