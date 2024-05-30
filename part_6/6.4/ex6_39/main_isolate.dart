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
      var cat = const Cat('Max');
      var b = ['45'];
      var c = 44;
      var d = 'hi!';
      var e = 23.1;
      print('Main cat: ${identityHashCode(cat)}'); // 640354238
      print('Main a: ${identityHashCode(a)}'); // 896670331
      print('Main b: ${identityHashCode(b)}'); // 913878150
      print('Main c: ${identityHashCode(c)}'); // 510444
      print('Main d: ${identityHashCode(d)}'); // 1009204041
      print('Main e: ${identityHashCode(e)}'); // 15509272291868675
    }),
    // Isolate.run(() => isolateFoo()),
    Isolate.spawnUri(Uri.parse('new_group.dart'), [], null),
  ]);
}
