import 'dart:isolate';

class Cat {
  final String name;
  const Cat(this.name);
}

class StartMessage {
  final int count;
  final SendPort sender;
  StartMessage(this.sender, this.count);
}

class StopMessage {
  const StopMessage();
}

void isolateCat(StartMessage message) async {
  var receivePort = ReceivePort();
  var sendPort = message.sender;
  var count = message.count;
  sendPort.send(
    StartMessage(receivePort.sendPort, 0),
  );

  receivePort.listen((message) async {
    if (message is StopMessage) {
      sendPort.send(const StopMessage());
      receivePort.close();
      Isolate.current.kill();
    } else if (message is Cat) {
      count--;
      if (count <= 0) {
        sendPort.send(message);
        sendPort.send(const StopMessage());
        receivePort.close();
        Isolate.current.kill();
      }
      sendPort.send(message);
    }
  });
}

void main(List<String> arguments) async {
  if ((arguments.isEmpty) && (arguments.length != 2)) {
    print('Something wrong with arguments');
    return;
  }

  final stopWatch = Stopwatch();
  final limit = int.parse(arguments[0]);
  final mode = int.parse(arguments[1]);
  var catName = ['Alex', 'Max', 'Kate', 'Jack'];
  var cats = List.generate(
    limit,
    (index) => Cat(catName[index % catName.length]),
  );

  var catConstName = [
    const Cat('Alex'),
    const Cat('Max'),
    const Cat('Kate'),
    const Cat('Jack'),
  ];
  var constCats = List.generate(
    limit,
    (index) => catConstName[index % catName.length],
  );

  var count = cats.length;
  var receivePort = ReceivePort();
  await Isolate.spawn(
    isolateCat,
    StartMessage(receivePort.sendPort, count),
  );

  stopWatch.start();
  SendPort? sendPort;

  receivePort.listen((message) {
    switch (message) {
      case StartMessage(sender: var port):
        sendPort = port;
        if (arguments.isNotEmpty) {
          for (var cat in mode == 1 ? cats : constCats) {
            sendPort?.send(cat);
          }
        } else {
          sendPort?.send(const StopMessage());
        }
      case Cat(name: _):
        count--;
      case StopMessage():
        receivePort.close();
        print('${stopWatch.elapsed} count: $count');
    }
  });
}
