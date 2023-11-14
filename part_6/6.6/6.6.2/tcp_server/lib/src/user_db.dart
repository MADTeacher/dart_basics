import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:protocol/protocol.dart';

class DBException implements Exception {
  final String? msg;
  const DBException([this.msg]);

  @override
  String toString() => msg ?? 'DBException';
}

class UserDB {
  var _users = <User>[];
  late File _file;
  final String patToDB;

  UserDB(this.patToDB);

  Future<void> init() async {
    _file = File(patToDB);
    if (await _file.exists()) {
      try {
        var data = jsonDecode(
          await _file.readAsString(),
        ) as List<dynamic>;
        _users = data
            .map(
              (e) => User.fromJson(e),
            )
            .toList();
      } catch (e) {
        throw DBException('Ошибка десериализации: $e');
      }
    } else {
      throw DBException('Отсутствует файл с данными');
    }
  }

  Future<void> save() async {
    final encoder = JsonEncoder.withIndent('  ');
    try {
      var data = _users.map((e) => e.toJson()).toList();
      await _file.writeAsString(encoder.convert(data));
    } catch (e) {
      throw DBException('Ошибка сериализации: $e');
    }
  }

  Future<void> add(User user) async {
    var index = _users.indexWhere(
      (element) => element.id == user.id,
    );
    if (index == -1) {
      _users.add(user);
      await save();
    } else {
      throw DBException(
        'Пользователь с таким id уже существует',
      );
    }
  }

  Future<void> delete(int id) async {
    _users.removeWhere((element) => element.id == id);
    await save();
  }

  Future<void> update(User user) async {
    var index = _users.indexWhere(
      (element) => element.id == user.id,
    );
    if (index != -1) {
      _users[index] = user;
      await save();
    } else {
      throw DBException(
        'Пользователь с таким id не существует',
      );
    }
  }

  Future<List<User>> getAll() async {
    return _users;
  }

  Future<User?> getById(int id) async {
    return _users.firstWhere(
      (element) => element.id == id,
    );
  }
}
