import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';
import 'package:udp_server/udp_server.dart';

Future<GetAllUsersResponse> getAllUsers(
  UserDB db,
) async {
  return GetAllUsersResponse(await db.getAll());
}

Future<OperationResponse> addUser(
  UserDB db,
  User user,
) async {
  try {
    await db.add(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> updateUser(
  UserDB db,
  User user,
) async {
  try {
    await db.update(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> deleteUser(
  UserDB db,
  int id,
) async {
  try {
    await db.delete(id);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<GetUserResponse> getUser(
  UserDB db,
  int id,
) async {
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

  RawDatagramSocket? udpServer;
  print('Запуск main');
  await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 8083)
      .then((serverSocket) {
    udpServer = serverSocket;
    serverSocket.listen((event) async {
      if (event == RawSocketEvent.read) {
        var datagram = serverSocket.receive();
        var rawData = utf8.decode(datagram!.data);
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
        serverSocket.send(
          utf8.encode(encoder.convert(message)),
          serverSocket.address,
          8084,
        );
      }
    });
  });

  stdin.transform(utf8.decoder).listen((data) {
    if (data == 'exit') {
      udpServer?.close();
    }
    exit(0);
  });
  print('Завершение main');
}
