import 'dart:isolate';
import 'dart:async';

void main() async {
  print('Main isolate started');
  await Future.wait([
    Isolate.run(firstIsolate),
    Future.delayed(Duration(seconds: 1)),
  ]);
}

Future<void> firstIsolate() async {
  print('First isolate started');
  await Future.wait([
    Isolate.run(secondIsolate),
    Future.delayed(Duration(seconds: 1)),
  ]);
}

Future<void> secondIsolate() async {
  print('Second isolate started');
}
