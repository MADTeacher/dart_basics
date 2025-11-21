import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:common/match_history.dart';

class MatchLoader {
  late String _localPath;

  MatchLoader([String storeDir = 'data']) {
    _localPath = p.join(Directory.current.path, storeDir);
    if (!Directory(_localPath).existsSync()) {
      Directory(_localPath).createSync();
    }
  }

  Future<MatchHistory?> loadMatch(String fileName) async {
    var path = p.join(_localPath, fileName);
    if (await File(path).exists()) {
      var json = await File(path).readAsString();
      return MatchHistory.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future<List<String>> listMatches() async {
    var dir = Directory(_localPath);
    if (await dir.exists()) {
      return dir
          .listSync()
          .whereType<File>()
          .map(
            (e) => p.basename(e.path),
          )
          .toList();
    }
    return [];
  }
}
