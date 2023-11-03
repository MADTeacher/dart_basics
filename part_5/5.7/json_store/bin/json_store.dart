import 'package:json_store/json_store.dart';

void main(List<String> arguments) {
  final store = JSONStore('bin/store.json');

  store.setValue('map', <String, int>{'a': 1, 'b': 2});
  store.setValue('strList', <String>['a', 'b', 'c']);
  store.setValue('intList', <int>[1, 2, 3]);

  var strList = store.getList('strList')?.cast<String>().toList();
  var intList = store.getList('intList')?.cast<int>().toList();
  var myMap = Map<String, int>.from(
    store.getMap('map')?.cast<String, int>() ?? {},
  );

  print(strList.runtimeType); // List<String>
  print(intList.runtimeType); // List<int>
  print(myMap.runtimeType); // _Map<String, int>

  print(strList); // [a, b, c]
  print(intList); // [1, 2, 3]
  print(myMap); // {a: 1, b: 2}
}

// void main(List<String> arguments) {
//   final store = JSONStore('bin/store.json');
//   store.setValue('strList', <String>['a', 'b', 'c']);
//   store.setValue('int', 55);
//   store.setValue('bool', true);
//   store.setValue('double', 3.14);
//   store.setValue('map', <String, int>{'a': 1, 'b': 2});
//   store.setValue('str', '(づ˶•༝•˶)づ♡');

//   print(store.values);
//   // [[a, b, c], 55, true, 3.14, {a: 1, b: 2}, (づ˶•༝•˶)づ♡]
//   print(store.keys); 
//   // [strList, int, bool, double, map, str]

//   print(store.contains('strList')); // true
//   print(store.getValue('strList')); // [a, b, c]
//   print(store.getValue('int')); // 55
//   print(store.getValue('bool')); // true
//   print(store.getValue('double')); // 3.14
//   print(store.getValue('map')); // {a: 1, b: 2}
//   print(store.getValue('str')); // (づ˶•༝•˶)づ♡
// 
//   store.setValue('strList', '-_-');
//   store.setValue('double', 99);
//   print(store.getValue('strList')); // -_-
//   print(store.getValue('double')); // 99
// 
//   store.resetValue('map');
//   store.resetValue('str');
//   print(store.getValue('map')); // null
//   print(store.getValue('str')); // null
// }