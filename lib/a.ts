
import 'dart:convert';

void main() {
  dynamic something = json.decode('1');
  // In type safe language, program will fail here.
  // int is not a String
  var string = something as String;
  var trimmed = trimString(string);
  print(trimmed);
}

String trimString(String s) {
  // in Typescript the program will fail here
  // number has not a method trim
  return s.trim();
}
