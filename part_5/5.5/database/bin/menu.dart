import 'dart:io';

import 'package:database/database.dart';

class Menu {
  final Database database;

  Menu(this.database);

  void loop() {
    while (true) {
      printMenu();
      var input = stdin.readLineSync()!;
      print('x' * 25);
      switch (input) {
        case '1':
          addUser();
        case '2':
          removeUser();
        case '3':
          changeUser();
        case '4':
          showUsers();
        case '5':
          intersect();
        case '6':
          union();
        case '7':
          saveAndExit();
          return;
        case '8':
          return;
      }
    }
  }

  void printMenu() {
    print('1. Add User');
    print('2. Remove User');
    print('3. Change User');
    print('4. Show Users');
    print('5. Intersect Table');
    print('6. Union Table');
    print('7. Save and Exit');
    print('8. Exit');
  }

  void addUser() {
    try {
      stdout.write('Enter id: ');
      var id = int.parse(stdin.readLineSync()!);
      stdout.write('Enter nickname: ');
      var nickname = stdin.readLineSync()!;
      stdout.write('Enter year of birth: ');
      var yearOfBirth = int.parse(stdin.readLineSync()!);
      stdout.write('Enter email: ');
      var email = stdin.readLineSync()!;
      stdout.write('Enter phone: ');
      var phone = stdin.readLineSync()!;
      stdout.write('Enter password hash: ');
      var passwordHash = stdin.readLineSync()!;
      stdout.write(
        'Acsess level (A - Admin, T - Teacher, S - Student): ',
      );
      var acsessLevel = stdin.readLineSync()!;
      var user = User(
        id: id,
        nickname: nickname,
        yearOfBirth: yearOfBirth,
        email: email,
        phone: phone,
        acsessLevel: acsessLevel,
        passwordHash: passwordHash,
      );
      stdout.write('Add user to DB (S - SUAI, U - Unecon): ');
      var type = stdin.readLineSync()!;
      switch (type.toUpperCase()) {
        case 'S':
          database.insert(user, DBType.suai);
          database.showDB(DBType.suai);
        case 'U':
          database.insert(user, DBType.unecon);
          database.showDB(DBType.unecon);
        default:
          print('(︶︿︶)_╭∩╮');
          return;
      }
    } catch (e) {
      print('WTF!!!! $e');
    }
  }

  void removeUser() {
    stdout.write('Add user to DB (S - SUAI, U - Unecon): ');
    var type = stdin.readLineSync()!;
    late DBType typeDB;
    switch (type.toUpperCase()) {
      case 'S':
        typeDB = DBType.suai;
        database.showDB(DBType.suai);
      case 'U':
        typeDB = DBType.unecon;
        database.showDB(DBType.unecon);
      default:
        print('(︶︿︶)_╭∩╮');
        return;
    }
    stdout.write('Enter id: ');
    var id = stdin.readLineSync()!;
    database.remove(id: id, type: typeDB);
    database.showDB(typeDB);
  }

  void changeUser() {
    stdout.write('Select DB (S - SUAI, U - Unecon): ');
    var type = stdin.readLineSync()!;
    late DBType typeDB;
    switch (type.toUpperCase()) {
      case 'S':
        typeDB = DBType.suai;
        database.showDB(DBType.suai);
      case 'U':
        typeDB = DBType.unecon;
        database.showDB(DBType.unecon);
      default:
        print('(︶︿︶)_╭∩╮');
        return;
    }
    stdout.write('Enter id: ');
    var id = stdin.readLineSync()!;
    stdout.write('Enter nickname: ');
    var user = database
        .selection(
          type: typeDB,
          attribute: 'id',
          value: id,
        )
        .first!;

    stdout.write('Enter field: ');
    var field = stdin.readLineSync()!;
    stdout.write('Enter new value: ');
    var newValue = stdin.readLineSync()!;
    user.change(field, newValue);

    database.showDB(typeDB);
  }

  void showUsers() {
    stdout.write('Select DB (S - SUAI, U - Unecon): ');
    var type = stdin.readLineSync()!;
    switch (type.toUpperCase()) {
      case 'S':
        database.showDB(DBType.suai);
      case 'U':
        database.showDB(DBType.unecon);
      default:
        print('(︶︿︶)_╭∩╮');
        return;
    }
  }

  void intersect() {
    stdout.write('Enter field: ');
    var field = stdin.readLineSync()!;
    stdout.write('Enter intersect value: ');
    var value = stdin.readLineSync()!;
    print(database.intersect(field, value));
  }

  void union() {
    print(database.union());
  }

  void saveAndExit() {
    database.save(DBType.suai);
    database.save(DBType.unecon);
  }
}
