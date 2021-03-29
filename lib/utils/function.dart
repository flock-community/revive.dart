extension X on Function {
  /// Very hacky way to get the name of a method, which doesn't work for web.
  /// Please let me know if you know a better way without reflection.
  String get name {
    if (toString().contains('from Function')) {
      return toString() //
          .split('from Function')[1]
          .replaceAll('\'', '')
          .replaceAll(':', '')
          .replaceAll('.', '')
          .replaceAll('static', '')
          .trim();
    } else {
      return toString();
    }
  }
}
