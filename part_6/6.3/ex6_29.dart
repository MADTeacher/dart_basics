import 'dart:isolate';

class IsolatesMessage<T> {
    final SendPort sender;
    final T message;

    IsolatesMessage({
        required this.sender,
        required this.message,
    });
}

late SendPort isolateSendPort;
late Isolate isolate;

Future<void> createIsolate() async {
  var receivePort = ReceivePort();
  isolate = await Isolate.spawn(
      echoCallbackFunction,
      receivePort.sendPort,
  );
  isolateSendPort = await receivePort.first;
}

Future<String> sendReceive(String send) async{
  var port = ReceivePort();
  isolateSendPort.send(
      IsolatesMessage<String>(
          sender: port.sendPort,
          message: send,
      )
  );
  return await port.first;
}

void echoCallbackFunction(SendPort sendPort){
  var receivePort = ReceivePort();
  // возвращаем ссылку на порт для отправки данных
  // в главный изолят
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    // обработчик принимаемых сообщений изолятом
    var isolateMessage = message as IsolatesMessage<String>;
    print('Isolate: ${isolateMessage.message}');
    isolateMessage.sender.send(isolateMessage.message);
  });
}

void main()async{
  await createIsolate();
  print('Main: ${await sendReceive('Старт!')}');
  print('Main: ${await sendReceive('1')}');
  print('Main: ${await sendReceive('2')}');
  print('Main: ${await sendReceive('3')}');
  isolate.kill();
}
