export 'src/table.dart';
export 'src/user.dart';

import 'dart:io';

import 'src/table.dart';
import 'src/user.dart';

enum DBType {
  suai,
  unecon,
}

class Database {
  final String pathToSuaiDB;
  final String pathToUneconDB;
  late Table<User> _suaiUsers;
  late Table<User> _uneconUsers;

  Database({
    this.pathToSuaiDB = 'suai.txt',
    this.pathToUneconDB = 'unecon.txt',
  }) {
    if (!File(pathToSuaiDB).existsSync()) {
      File(pathToSuaiDB).createSync(recursive: true);
      _suaiUsers = Table<User>('suai');
    } else {
      _suaiUsers = _openTable(File(pathToSuaiDB), 'suai');
    }

    if (!File(pathToUneconDB).existsSync()) {
      File(pathToUneconDB).createSync(recursive: true);
      _uneconUsers = Table<User>('unecon');
    } else {
      _uneconUsers = _openTable(File(pathToUneconDB), 'unecon');
    }
  }

  Table<User> _openTable(File file, String tableName) {
    var table = Table<User>(tableName);
    for (var line in file.readAsLinesSync()) {
      var data = line.split(',');
      table.insert(User(
        id: int.parse(data[0]),
        nickname: data[1],
        yearOfBirth: int.parse(data[2]),
        email: data[3],
        phone: data[4],
        acsessLevel: data[5],
        passwordHash: data[6],
      ));
    }

    return table;
  }

  void save(DBType type) {
    File file;
    Table<User> users;

    switch (type) {
      case DBType.suai:
        file = File(pathToSuaiDB);
        users = _suaiUsers;
      case DBType.unecon:
        file = File(pathToUneconDB);
        users = _uneconUsers;
    }

    var sink = file.openWrite();
    users.forEach((user) {
      StringBuffer buffer = StringBuffer();
      buffer.write('${user.id},${user.nickname},');
      buffer.write('${user.yearOfBirth},${user.email},');
      buffer.write('${user.phone},${user.acsessLevel},');
      buffer.write('${user.passwordHash}\n');
      sink.write(buffer.toString());
    });
    sink.close();
  }

  bool insert(User user, DBType type) {
    File file;
    bool isOk = false;
    switch (type) {
      case DBType.suai:
        file = File(pathToSuaiDB);
        isOk = _suaiUsers.insert(user);
      case DBType.unecon:
        file = File(pathToUneconDB);
        isOk = _uneconUsers.insert(user);
    }

    if (!isOk) {
      return false;
    }

    StringBuffer buffer = StringBuffer();
    buffer.write('${user.id},${user.nickname},');
    buffer.write('${user.yearOfBirth},${user.email},');
    buffer.write('${user.phone},${user.acsessLevel},');
    buffer.write('${user.passwordHash}\n');

    file.writeAsStringSync(
      buffer.toString(),
      mode: FileMode.append,
    );
    return true;
  }

  Table<User> selection({
    required DBType type,
    required String attribute,
    required String value,
  }) {
    return switch (type) {
      DBType.suai => _suaiUsers.selection(attribute, value),
      DBType.unecon => _uneconUsers.selection(attribute, value),
    };
  }

  Table<User> intersect(String attribute, String value) {
    var temp = _suaiUsers.intersect(
      attribute,
      value,
      _uneconUsers,
    );
    return temp;
  }

  Table<User> union() {
    var temp = _suaiUsers.union(
      _uneconUsers,
    );
    return temp;
  }

  void remove({
    required String id,
    required DBType type,
  }) {
    switch (type) {
      case DBType.suai:
        _suaiUsers.remove(id);
        print(_suaiUsers);
      case DBType.unecon:
        _uneconUsers.remove(id);
        print(_uneconUsers);
    }
  }

  void showDB(DBType type) {
    switch (type) {
      case DBType.suai:
        print(_suaiUsers);
      case DBType.unecon:
        print(_uneconUsers);
    }
  }
}
