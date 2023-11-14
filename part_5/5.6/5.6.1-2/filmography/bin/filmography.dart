import 'dart:io';
import 'dart:convert';

import 'package:filmography/filmography.dart';

void main(List<String> arguments) {
  var myFile = File('bin\\film.json');
  var json = jsonDecode(myFile.readAsStringSync());
  var movie = Movie.fromJson(json);
  print(movie);

  var myFile2 = File('bin\\output.json');
  // myFile2.writeAsStringSync(jsonEncode(movie));
  var encoder = JsonEncoder.withIndent('  ');
  myFile2.writeAsStringSync(encoder.convert(movie));
}
