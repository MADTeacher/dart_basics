import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class JSONFile {
  final String path;

  JSONFile(this.path) {
    final dir = Directory(p.dirname(path));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  Map<String, Object>? read() {
    final file = File(path);
    try {
      if (file.existsSync()) {
        final data = file.readAsStringSync();
        if (data.isNotEmpty) {
          final json = jsonDecode(data);
          if (json is Map) {
            return json.cast<String, Object>();
          }
        }
      }
    } on FormatException {
      return null;
    }
    return {};
  }

  void write(Map<String, Object> json) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final encoder = const JsonEncoder.withIndent('  ');
    return file.writeAsStringSync(
      encoder.convert(json),
    );
  }
}
