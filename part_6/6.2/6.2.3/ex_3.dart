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

  // asyncMap - метод для асинхронного преобразования элементов потока
  // Основные отличия от обычного map:
  // 1. Функция-преобразователь может быть асинхронной (возвращать Future)
  // 2. Stream ожидает завершения Future перед обработкой следующего элемента
  // 3. Порядок элементов в результирующем потоке сохраняется, несмотря на асинхронность
  // 4. Все элементы обрабатываются последовательно, а не параллельно
  final pizzaStream = jsonStream.asyncMap<Pizza>((data) async {
    try {
      // Искусственная задержка, имитирующая асинхронную операцию
      // Например, запрос к базе данных или внешнему API
      await Future.delayed(Duration(seconds: 1));
      String name = data['name'] ?? 'Unknown Pizza';
      double price = (data['price'] as num?)?.toDouble() ?? 0.0;
      String? sauce = data['sauce'] ?? 'Barbecue';
      List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

      // Возвращаем новый объект Pizza. asyncMap ожидает завершения этого
      // Future и помещает его результат в выходной поток pizzaStream
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

  // Подписываемся на поток преобразованных объектов Pizza
  // В отличие от предыдущих примеров, из-за асинхронной природы asyncMap,
  // каждый объект Pizza будет выводиться с задержкой в 1 секунду
  pizzaStream.listen(
    (pizza) => print(pizza),
    onError: (error) => print(error),
  );

  // Метод listen сразу возвращает управление, не блокируя основной поток выполнения.
  print('Ожидаем получения объектов Pizza...');

  // Если бы здесь был дополнительный код, он выполнился бы до получения
  // результатов из потока!
}
