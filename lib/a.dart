import 'dart:convert';

void main() {
  dynamic something = json.decode('1');
  // program fails here, int not a String
  var string = something as String;
  var trimmed = trimString(string);
  print(trimmed);
}

String trimString(String s) {
  return s.trim();
}
