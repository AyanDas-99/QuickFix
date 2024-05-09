extension FormatedDateTime on DateTime {
  String formatedString() {
    String a = '';
    int hr = 0;
    if (hour < 12) {
      a = 'AM';
      hr = hour;
    } else {
      a = 'PM';
      hr = hour - 12;
    }
    return '$day / $month / $year  ($hr:$minute $a)';
  }
}
