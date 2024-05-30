import 'dart:convert';

void main(List<String> arguments) async {
  var val = 'Hello';
  var newVal = 'Hello';
  print('${val.hashCode}');
  print('${newVal.hashCode}');
  print('${identical(val, newVal)}'); // true

  var list = [1, 2, 3];
  var newList = [1, 2, 3];
  print('${list.hashCode}');
  print('${newList.hashCode}');
  print('${identical(list, newList)}'); // false

  var value = jsonDecode('{"a": 1, "b": 1}');
  print(identical(value['a'], value['b'])); // true
  print(identityHashCode(value['a'])); 
  print(identityHashCode(value['b'])); 
}
