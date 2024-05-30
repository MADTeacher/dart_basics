import 'dart:async';
import 'dart:isolate';

class Cat {
  final String name;
  const Cat(this.name);
}

void main(List<String> arguments) async {
  await Future.wait([
    Future.delayed(Duration(seconds: 2), () {
      var a = const ['22'];
      var b = 44;
      var cat = const Cat('Max');
      var c = ['45'];
      print('Main cat: ${identityHashCode(cat)}');
      print('Main a: ${identityHashCode(a)}');
      print('Main b: ${identityHashCode(b)}');
      print('Main c: ${identityHashCode(c)}');
    }),
    Isolate.run(() => isolateFoo()),
  ]);
}

void isolateFoo() async {
  var cat = const Cat('Max');
  final a = const ['22'];
  var b = 44;
  var c = ['45'];
  print('Isolate cat: ${identityHashCode(cat)}');
  print('Isolate a: ${identityHashCode(a)}');
  print('Isolate b: ${identityHashCode(b)}');
  print('Isolate c: ${identityHashCode(c)}');

  b += 3;
  print('Isolate b: ${identityHashCode(b)}');
  await Future.delayed(Duration(seconds: 2));
}
