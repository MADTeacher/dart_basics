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

void main() {
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
    {'price': 9.99, 'sauce': 'Barbecue'},
    {},
  ]);

  // Метод map трансформирует каждый элемент потока, применяя к нему функцию-преобразователь
  // Map<Pizza> указывает тип данных, в который будет преобразован каждый элемент исходного потока
  //
  // Это ключевое отличие от примера ex6_stream_transform_0.dart, где использовался StreamIterator.
  // Метод map работает более декларативно и функционально, позволяя трансформировать
  // элементы потока без явного управления итерацией.
  final pizzaStream = jsonStream.map<Pizza>((data) {
    try {
      String name = data['name'] ?? 'Unknown Pizza';
      double price = (data['price'] as num?)?.toDouble() ?? 0.0;
      String? sauce = data['sauce'] ?? 'Barbecue';
      List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

      // Возвращаем новый объект Pizza - это значение будет следующим элементом
      // в трансформированном потоке pizzaStream
      return Pizza(
        name: name,
        price: price,
        sauce: sauce,
        toppings: toppings,
      );
    } catch (e) {
      throw 'Error creating Pizza: $e';
    }
  });

  // Метод listen подписывается на поток и обрабатывает каждый элемент по мере его поступления
  // Первый параметр - обработчик для успешно полученных элементов потока
  // onError - обработчик для ошибок, возникающих в потоке
  //
  // Обратите внимание, что в отличие от использования StreamIterator в предыдущем примере,
  // здесь мы не управляем состоянием потока вручную - Stream API делает это за нас
  pizzaStream.listen(
    (pizza) => print(pizza), // Вывод информации о каждой пицце
    onError: (error) => print(error), // Обработка ошибок
  );
}
