import 'package:intl/intl.dart';

final vnd = new NumberFormat(
  "#,##0.###",
  "de_DE",
); // Dùng locale de_DE: nghìn=. thập phân=,

final vndCurrency = NumberFormat.currency(
  locale: "de_DE",
  symbol: "đ",
  decimalDigits: 0, // Mặc định không hiển thị thập phân
); // Tối đa 3 chữ số thập phân

// Helper function để format tiền với thập phân linh hoạt
String formatCurrency(num? value, {int maxDecimals = 3}) {
  if (value == null) return "";

  value = value.round();
  final formatter = NumberFormat("#,##0", "de_DE");
  return formatter.format(value);
}

String vndFormatCurrency(num? value, {int maxDecimals = 3}) {
  if (value == null) return "";
  value = value.round();
  final formatter = NumberFormat("#,##0", "de_DE");
  return formatter.format(value);
}

int? stringToInt(String? value) {
  if (value == null) return null;
  return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
}

double? stringToDouble(String? value) {
  if (value == null) return null;
  return double.tryParse(value);
}

// format date
// from: 2023-07-10T03:44:11.000000Z
// to: 10/07/2023 10:44
String? formatDate(String? value) {
  if (value == null) return null;
  return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(value).toLocal());
}

String? formatDateOnly(String? value) {
  if (value == null) return null;
  return DateFormat('dd/MM/yyyy').format(DateTime.parse(value).toLocal());
}

String? formatDateMonthTextOnly(String? value) {
  if (value == null) return null;
  return DateFormat(
    'dd-MMM-yyyy',
    'vi_VN',
  ).format(DateTime.parse(value).toLocal());
}

String? formatTimeOnly(String? value) {
  if (value == null) return null;

  try {
    // Nếu là datetime đầy đủ (ISO / chứa ngày) -> parse bình thường
    if (value.contains('T') || value.contains('-') || value.contains(' ')) {
      return DateFormat('HH:mm').format(DateTime.parse(value).toLocal());
    }

    // Nếu là time-only: HH:mm or HH:mm:ss
    final timePattern = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$');
    final match = timePattern.firstMatch(value.trim());
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      // ignore seconds (match.group(3))
      final dt = DateTime(2000, 1, 1, hour, minute);
      return DateFormat('HH:mm').format(dt);
    }

    // Fallback: cố thử parse DateTime, nếu fail thì trả về nguyên bản
    return DateFormat('HH:mm').format(DateTime.parse(value).toLocal());
  } catch (e) {
    // Nếu parse thất bại, trả về chuỗi gốc (hoặc null tuỳ bạn muốn)
    return value;
  }
}

num? vndToNumber(String? value) {
  if (value == null) return null;
  String normalized = value.replaceAll('.', '').replaceAll(',', '.');
  double? parsed = double.tryParse(normalized);
  if (parsed == null) return 0;

  if (parsed == parsed.toInt()) {
    return parsed.toInt();
  }
  return parsed;
}

RegExp phoneRegExp = new RegExp(r'^(84|0[3|5|7|8|9])+([0-9]{8})\b');
int concatenateIds(int variantId, int orderId) {
  return int.parse('$variantId$orderId');
}

num roundMoney(num value) {
  return (value * 1000).round() / 1000;
}

String roundQuantity(num value, {int decimalPlaces = 3}) {
  return value
      .toStringAsFixed(decimalPlaces)
      .replaceAll(RegExp(r"0*$"), "")
      .replaceAll(RegExp(r"\.$"), "");
}

String prefixHttps(String url) {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'https://' + url;
  }
  return url;
}

String removeHttpPrefix(String url) {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return url;
  }
  return url.substring(url.indexOf('://') + 3);
}

bool isValidDomain(String domain) {
  // Regular expression to match valid domain patterns
  RegExp regex = RegExp(r'^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

  // Check if the domain matches the regular expression
  return regex.hasMatch(domain);
}

String _snakeToCamel(String s) {
  final parts = s.split('_');
  if (parts.isEmpty) return s;
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
          .join();
}

Map<String, dynamic> snakeToCamelMap(Map<String, dynamic>? input) {
  if (input == null) return {};
  final Map<String, dynamic> result = {};
  input.forEach((key, value) {
    final newKey = _snakeToCamel(key);
    if (value is Map) {
      result[newKey] = snakeToCamelMap(Map<String, dynamic>.from(value));
    } else if (value is List) {
      result[newKey] = value
          .map(
            (e) => e is Map ? snakeToCamelMap(Map<String, dynamic>.from(e)) : e,
          )
          .toList();
    } else {
      result[newKey] = value;
    }
  });
  return result;
}

List<dynamic> snakeToCamelList(List<dynamic>? input) {
  if (input == null) return [];
  return input.map((e) {
    if (e is Map) {
      return snakeToCamelMap(Map<String, dynamic>.from(e));
    } else if (e is List) {
      return snakeToCamelList(e);
    } else {
      return e;
    }
  }).toList();
}

String weekdayShortVi(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'T2';
    case DateTime.tuesday:
      return 'T3';
    case DateTime.wednesday:
      return 'T4';
    case DateTime.thursday:
      return 'T5';
    case DateTime.friday:
      return 'T6';
    case DateTime.saturday:
      return 'T7';
    case DateTime.sunday:
    default:
      return 'CN';
  }
}
