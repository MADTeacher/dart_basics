import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:common/match_history.dart';

class MatchSaver {
  late String _localPath;
  JsonEncoder encoder = JsonEncoder.withIndent('  ');

  MatchSaver([String storeDir = 'data']) {
    _localPath = p.join(Directory.current.path, storeDir);
    if (!Directory(_localPath).existsSync()) {
      Directory(_localPath).createSync();
    }
  }

  Future<void> saveMatch(MatchHistory match) async {
    var json = encoder.convert(match);
    var time = DateTime.now().toIso8601String().split('.')[0];
    time = time.replaceAll(':', '-');
    await File(
      p.join(_localPath, '${match.winner} $time.json'),
    ).writeAsString(json);
  }
}
