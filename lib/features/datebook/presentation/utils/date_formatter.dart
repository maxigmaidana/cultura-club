const List<String> _weekdays = [
  'Lun',
  'Mar',
  'Mié',
  'Jue',
  'Vie',
  'Sáb',
  'Dom',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Formatea una fecha como "Mar 12/08 - 19:30" sin depender de `intl`.
String formatActivityDate(DateTime dateTime) {
  final local = dateTime.toLocal();
  final weekday = _weekdays[local.weekday - 1];
  final day = _twoDigits(local.day);
  final month = _twoDigits(local.month);
  final hour = _twoDigits(local.hour);
  final minute = _twoDigits(local.minute);
  return '$weekday $day/$month - $hour:$minute';
}
