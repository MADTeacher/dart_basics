import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';

Future<void> menu(
    (
      RawDatagramSocket rawDgramSocket,
      String ip,
      int serverPort,
    ) connection) async {
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
    var (socket, ip, port) = connection;
    if (input is String) {
      switch (input) {
        case '1':
          socket.send(
            utf8.encode(jsonEncode(GetAllUsersRequest())),
            InternetAddress(ip),
            port,
          );
        case '2':
          var user = addUser();
          socket.send(
            utf8.encode(jsonEncode(AddUserRequest(user))),
            InternetAddress(ip),
            port,
          );
        case '3':
          var user = addUser();
          socket.send(
            utf8.encode(jsonEncode(UpdateUserRequest(user))),
            InternetAddress(ip),
            port,
          );
        case '4':
          var id = getId();
          socket.send(
            utf8.encode(jsonEncode(DeleteUserRequest(id))),
            InternetAddress(ip),
            port,
          );
        case '5':
          var id = getId();
          print(jsonEncode(GetUserRequest(id)));
          socket.send(
            utf8.encode(jsonEncode(GetUserRequest(id))),
            InternetAddress(ip),
            port,
          );
        case '6':
          // закрываем соединение и освобождаем ресурсы
          socket.close();
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
  var rawDgramSocket = await RawDatagramSocket.bind(
    '127.0.0.1',
    8084,
  );
  rawDgramSocket.listen((event) {
    if (event == RawSocketEvent.read) {
      var rawData = rawDgramSocket.receive();
      var json = jsonDecode(utf8.decode(rawData!.data));
      var clientRequest = ResponseMessage.fromJson(json);
      switch (clientRequest) {
        case GetAllUsersResponse() || GetUserResponse():
          print(utf8.decode(rawData.data));
        case OperationResponse(success: bool success):
          if (success) {
            print('Success');
          } else {
            print('Failed');
          }
      }
    }
  });
  menu((rawDgramSocket, '127.0.0.1', 8083));
}
