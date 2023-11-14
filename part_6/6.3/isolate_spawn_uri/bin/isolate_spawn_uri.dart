import 'dart:io';
import 'dart:isolate';

import 'message.dart';

void main() async {
  var receivePort = ReceivePort();
  await Isolate.spawnUri(
    Uri.parse('uri_isolate.dart'),
    [],
    receivePort.sendPort,
  );

  SendPort? sendPort;
  // слушаем порт изолята
  receivePort.listen((message) {
    var mes = Message.fromJson(message);
    switch (mes) {
      case StartMessage(sender: var port):
        sendPort = port;
      case StopMessage():
        print('Isolate stopped');
        receivePort.close();
      case UserResponseMessage(user: var user):
        print(user);
      case UserRequestMessage():
        print('Message is not supported');
    }
  });

  await Future.delayed(Duration(seconds: 1));

  while (true) {
    if (sendPort == null) {
      print('Isolate not started');
      break;
    }

    print('Enter user id');
    var input = stdin.readLineSync()!;
    var id = int.tryParse(input);
    if (id is int) {
      sendPort?.send(
        UserRequestMessage(id).toJson(),
      );
    } else if (input == 'exit') {
      sendPort?.send(
        StopMessage().toJson(),
      );
      break;
    } else {
      print('Invalid user id');
    }
    await Future.delayed(Duration(seconds: 1));
  }
}
