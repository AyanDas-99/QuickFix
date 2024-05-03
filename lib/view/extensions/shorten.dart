extension Shorten on String {
  String shorten(int end) {
    if (length < end) return this;
    return '${substring(0, end)}..';
  }
}
