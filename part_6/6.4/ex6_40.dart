import 'dart:async';
import 'dart:isolate';

class Cat {
  final String name;
  const Cat(this.name);
}

void main(List<String> arguments) async {
  var cat1 = const Cat('Max');
  print('Main cat1: ${identityHashCode(cat1)}');

  var cat2 = Cat('Max');
  print('Main cat2: ${identityHashCode(cat2)}');

  await Future.wait([
    Isolate.run(() => isolateFoo(cat1, 1)),
    Isolate.run(() => isolateFoo(cat2, 2)),
  ]);
  await Future.delayed(Duration(seconds: 3));
}

void isolateFoo(Cat cat, int number) async {
  print('Isolate cat$number: ${identityHashCode(cat)}');
  await Future.delayed(Duration(seconds: 1));
}
