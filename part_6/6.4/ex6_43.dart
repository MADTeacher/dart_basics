import 'dart:convert';
import 'dart:isolate';
import 'dart:io';

class StopMessage {
  const StopMessage();
}

void firstIsolate(SendPort sendPort) async {
  print('First isolate started');
  SendPort? secondSendPort;
  var mainReceivePort = ReceivePort();
  sendPort.send(mainReceivePort.sendPort);

  mainReceivePort.listen((message) async {
    switch (message) {
      case StopMessage():
        secondSendPort?.send(message);
      case _:
        print('First isolate: $message');
        secondSendPort?.send(message);
    }
  });

  var secondReceivePort = ReceivePort();
  await Isolate.spawn(
    secondIsolate,
    secondReceivePort.sendPort,
  );

  secondReceivePort.listen((message) {
    switch (message) {
      case StopMessage():
        print('First isolate killed');
        sendPort.send(message);
        secondReceivePort.close();
        mainReceivePort.close();
        Isolate.current.kill();
      case SendPort():
        secondSendPort = message;
    }
  });
}

void secondIsolate(SendPort sendPort) async {
  print('Second isolate started');
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    switch (message) {
      case StopMessage():
        print('Second isolate killed');
        sendPort.send(message);
        receivePort.close();
        Isolate.current.kill();
      default:
        print('Second isolate: $message');
    }
  });
}

void main(List<String> arguments) async {
  print('Main isolate started');
  var receivePort = ReceivePort();
  await Isolate.spawn(
    firstIsolate,
    receivePort.sendPort,
  );

  SendPort? sendPort;

  stdin.transform(utf8.decoder).listen((data) async {
    var input = data.trim();
    if (input == 'kill') {
      sendPort?.send(StopMessage());
      await Future.delayed(Duration(seconds: 1));
      exit(0);
    } else {
      print('Main isolate: $input');
      sendPort?.send(input);
    }
  });

  receivePort.listen((message) {
    switch (message) {
      case StopMessage():
        print('Main isolate killed');
        receivePort.close();
      case SendPort():
        sendPort = message;
    }
  });
}
