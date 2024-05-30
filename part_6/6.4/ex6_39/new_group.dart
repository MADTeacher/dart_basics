import 'main_isolate.dart';

void main() {
  var a = const ['22'];
  var cat = const Cat('Max');
  var b = ['45'];
  var c = 44;
  var d = 'hi!';
  var e = 23.1;
  print('IG cat: ${identityHashCode(cat)}'); // 478627355
  print('IG a : ${identityHashCode(a)}'); // 174622686
  print('IG b : ${identityHashCode(b)}'); // 167233800
  print('IG c : ${identityHashCode(c)}'); // 510444
  print('IG d: ${identityHashCode(d)}'); // 1009204041
  print('IG e: ${identityHashCode(e)}'); // 15509272291868675
}
