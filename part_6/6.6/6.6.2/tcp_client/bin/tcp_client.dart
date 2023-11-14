import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';

Future<void> menu(Socket socket) async {
  while (true) {
    print('*' * 20);
    print('1. GetAllUsers');
    print('2. AddUser');
    print('3. UpdateUser');
    print('4. DeleteUser');
    print('5. GetUser');
    print('6. Exit');
    print('*' * 20);
    var input = stdin.readLineSync();
    if (input is String) {
      switch (input) {
        case '1':
          socket.write(jsonEncode(GetAllUsersRequest()));
        case '2':
          var user = addUser();
          socket.write(jsonEncode(AddUserRequest(user)));
        case '3':
          var user = addUser();
          socket.write(jsonEncode(UpdateUserRequest(user)));
        case '4':
          var id = getId();
          socket.write(jsonEncode(DeleteUserRequest(id)));
        case '5':
          var id = getId();
          socket.write(jsonEncode(GetUserRequest(id)));
        case '6':
          // закрываем соединение и освобождаем ресурсы
          socket.destroy();
          return;
        default:
          print('Некорректный ввод');
      }
    }
    await Future.delayed(const Duration(seconds: 2));
  }
}

int getId() {
  print('Введите введите id');
  var id = int.parse(stdin.readLineSync()!);
  return id;
}

User addUser() {
  print('Введите введите id');
  var id = int.parse(stdin.readLineSync()!);
  print('Введите введите имя');
  var name = stdin.readLineSync()!;
  print('Введите введите возраст');
  var age = int.parse(stdin.readLineSync()!);
  print('Введите введите образование');
  var education = stdin.readLineSync()!;
  return User(
    id: id,
    name: name,
    age: age,
    education: education,
  );
}

void main(List<String> arguments) async {
  // соединяемся с сервером
  var socket = await Socket.connect('127.0.0.1', 8084);
  socket.cast<List<int>>().transform(utf8.decoder).listen((rawData) {
    var json = jsonDecode(rawData);
    var clientRequest = ResponseMessage.fromJson(json);
    switch (clientRequest) {
      case GetAllUsersResponse() || GetUserResponse():
        print(rawData);
      case OperationResponse(success: bool success):
        if (success) {
          print('Success');
        } else {
          print('Failed');
        }
    }
  });
  menu(socket);
}
