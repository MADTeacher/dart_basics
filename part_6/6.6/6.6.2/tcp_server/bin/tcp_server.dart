import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';
import 'package:tcp_server/tcp_server.dart';

Future<GetAllUsersResponse> getAllUsers(
  UserDB db,
) async {
  return GetAllUsersResponse(await db.getAll());
}

Future<OperationResponse> addUser(UserDB db, User user) async {
  try {
    await db.add(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> updateUser(UserDB db, User user) async {
  try {
    await db.update(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> deleteUser(UserDB db, int id) async {
  try {
    await db.delete(id);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<GetUserResponse> getUser(UserDB db, int id) async {
  try {
    return GetUserResponse(await db.getById(id));
  } catch (e) {
    return GetUserResponse(null);
  }
}

void main(List<String> arguments) async {
  final encoder = JsonEncoder.withIndent('  ');
  var userDB = UserDB('bin\\users.json');
  await userDB.init();

  ServerSocket? tcpServer;
  print('Запуск main');
  ServerSocket.bind('127.0.0.1', 8084).then((serverSocket) {
    tcpServer = serverSocket;
    serverSocket.listen((socket) {
      // обрабатываем соединение очередного клиента
      // с сервером
      socket
          .cast<List<int>>()
          .transform(
            utf8.decoder,
          )
          .listen((rawData) async {
        var json = jsonDecode(rawData);
        var clientRequest = RequestMessage.fromJson(json);
        ResponseMessage message = switch (clientRequest) {
          GetAllUsersRequest() => await getAllUsers(userDB),
          AddUserRequest() => await addUser(
              userDB,
              clientRequest.user,
            ),
          UpdateUserRequest() => await updateUser(
              userDB,
              clientRequest.user,
            ),
          DeleteUserRequest() => await deleteUser(
              userDB,
              clientRequest.id,
            ),
          GetUserRequest() => await getUser(
              userDB,
              clientRequest.id,
            ),
        };
        socket.write(encoder.convert(message));
      });
    });
  });

  // обрабатываем асинхронный ввод с клавиатуры
  stdin.transform(utf8.decoder).listen((data) {
    if (data == 'exit') {
      tcpServer?.close();
      exit(0);
    }
  });
  print('Завершение main');
}
