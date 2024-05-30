import 'dart:collection';

void main() {
  final originalMap = <String, String>{
    'Alice': 'Developer',
    'Bob': 'Designer',
  };

  // Создание неизменяемого представления
  var unmodifiableMap = UnmodifiableMapView(originalMap);

  // Попытка добавить новый элемент приведет к исключению
  try {
    unmodifiableMap['Charlie'] = 'Data Scientist';
  } on UnsupportedError catch (e) {
    print('Ошибка: ${e.message}');
  }

  // Попытка удалить элемент также вызовет исключение
  try {
    unmodifiableMap.remove('Alice');
  } on UnsupportedError catch (e) {
    print('Ошибка: ${e.message}');
  }

  
  print('Профессия Alice: ${unmodifiableMap['Alice']}'); // Профессия Alice: Developer

  // Изменение исходной карты повлияет на неизменяемое представление
  originalMap['Alice'] = 'Senior Developer';
  originalMap['Tommy'] = 'Trainee';
  print(unmodifiableMap); 
}