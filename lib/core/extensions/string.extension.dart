extension StringExtension on String {
  /// Returns the string with the first letter capitalized.
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
