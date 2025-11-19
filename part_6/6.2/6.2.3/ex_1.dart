import 'dart:async';

typedef Json = Map<String, dynamic>;

class Pizza {
  final String name;
  final double price;
  final String? sauce;
  final List<String>? toppings;

  Pizza({
    required this.name,
    required this.price,
    this.sauce,
    this.toppings,
  });

  @override
  String toString() {
    var strBuf = StringBuffer();
    strBuf.write('Pizza(name: $name, price: $price,');
    strBuf.write('sauce: $sauce, toppings: $toppings)');
    return strBuf.toString();
  }
}

// Асинхронная функция для обработки потока (Stream) данных о пиццах
// Future<void> означает, что функция не возвращает значения, но выполняется асинхронно
Future<void> processPizzaStream(Stream<Json> pizzaDataStream) async {
  // Создаем итератор для потока, что позволяет перебирать элементы как только они доступны
  // StreamIterator - это удобный способ обработки элементов потока последовательно
  var iterator = StreamIterator(pizzaDataStream);

  // Цикл while с await позволяет асинхронно обрабатывать каждый
  // элемент потока, а метод moveNext() ожидает следующий элемент
  // и возвращает true, если он доступен
  while (await iterator.moveNext()) {
    // Получаем текущий элемент из итератора (объект JSON с данными о пицце)
    final data = iterator.current;
    try {
      // Извлекаем данные из JSON с использованием оператора ??
      //для установки значений по умолчанию,
      // если соответствующее поле отсутствует или равно null
      String name = data['name'] ?? 'Unknown Pizza';
      // Конвертируем числовое значение в double с проверкой на null
      double price = (data['price'] as num?)?.toDouble() ?? 0.0;
      String? sauce = data['sauce'] ?? 'Barbecue';
      // Приведение списка к типу List<String> с использованием метода cast()
      List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

      // Создаем объект Pizza из извлеченных данных
      final pizza = Pizza(
        name: name,
        price: price,
        sauce: sauce,
        toppings: toppings,
      );
      print(pizza); // Выводим информацию о созданной пицце
    } catch (e) {
      // Обрабатываем возможные ошибки при создании объекта Pizza
      print('Error creating Pizza: $e');
    }
  }
}

void main() {
  // Создаем поток данных из списка JSON-объектов с помощью фабричного метода Stream.fromIterable
  // Это создает синхронный поток, который будет выдавать каждый элемент итерируемого объекта поочередно
  final jsonStream = Stream<Json>.fromIterable([
    {
      'name': 'Margherita',
      'price': 8.99,
      'sauce': 'Tomato',
      'toppings': ['Cheese']
    },
    {
      'name': 'Pepperoni',
      'price': 10.99,
      'toppings': ['Pepperoni', 'Cheese']
    },
    {
      'price': 9.99,
      'sauce': 'Barbecue'
    }, // Объект с отсутствующими полями - демонстрация обработки неполных данных
    {}, // Пустой объект - демонстрация обработки полностью отсутствующих данных
  ]);

  // Передаем созданный поток JSON-данных в функцию обработки
  // Обратите внимание, что функция processPizzaStream возвращает Future,
  // но мы не используем await, так как это метод main и весь процесс завершится
  // после обработки всех элементов потока
  processPizzaStream(jsonStream);
}
