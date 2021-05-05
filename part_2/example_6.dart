void main(List<String> arguments) {
var myMap = <int, String>{
    1: 'Мама',
    2: 'мыла',
    3: 'раму'
  };
  myMap.forEach((key, value) {
    print('$key => $value');
  });
}