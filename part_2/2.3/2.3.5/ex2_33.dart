
void main() {
  var myMap = <int, String>{
    1: 'Мама',
    2: 'мыла',
    3: 'раму'
  };

  myMap.forEach((key, value) {
    print('$key => $value');
  });

  for (var it in myMap.entries) {
    // it - MapEntry<int, String>, хранит ключ и значение 
    // текущего элемента итерации
    print('${it.key} => ${it.value}');
  }
}
