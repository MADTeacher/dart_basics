import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'message.dart';
import 'user.dart';

void main(List<String> arguments, SendPort sendPort) async {
  int? startUserId;
  if (arguments.isNotEmpty) {
    startUserId = int.tryParse(arguments[0]);
    return;
  }

  var receivePort = ReceivePort();
  sendPort.send(
    StartMessage(receivePort.sendPort).toJson(),
  );

  if (startUserId is int) {
    var user = await fetchUser(startUserId);
    sendPort.send(
      UserResponseMessage(user).toJson(),
    );
  }

  receivePort.listen((message) async {
    var mes = Message.fromJson(message);
    switch (mes) {
      case StopMessage():
        sendPort.send(
          StopMessage().toJson(),
        );
        receivePort.close();
        Isolate.current.kill();
      case UserRequestMessage(id: var id):
        var user = await fetchUser(id);
        sendPort.send(
          UserResponseMessage(user).toJson(),
        );
      case StartMessage() || UserResponseMessage():
        print('Message is not supported');
    }
  });
}

Future<User?> fetchUser(int id) async {
  User? user;
  var httpClient = HttpClient();
  try {
    var request = await httpClient.getUrl(
      Uri.parse('https://reqres.in/api/users/$id'),
    ); // запрос по адресу, чтобы получить данные о пользователе
    // с конкретным id
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response
          .transform(
            utf8.decoder,
          )
          .join();
      user = User.fromJson(jsonDecode(responseBody));
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  } finally {
    httpClient.close();
  }
  return user;
}
