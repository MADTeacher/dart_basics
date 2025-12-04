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

  // asyncExpand - метод для асинхронного преобразования элементов потока с возможностью расширения
  // Основные отличия от asyncMap:
  // 1. Функция-преобразователь возвращает не Future<T>, а Stream<T> (через async*)
  // 2. Каждый элемент исходного потока может порождать 0, 1 или несколько элементов в результирующем потоке
  // 3. Все порожденные потоки "сплющиваются" (flatten) в один выходной поток
  // 4. Обработка следующего элемента начинается только после завершения всего потока от предыдущего элемента
  final pizzaStream = jsonStream.asyncExpand<Pizza>((data) async* {
    try {
      // Искусственная задержка, имитирующая асинхронную операцию
      // Например, запрос к базе данных или внешнему API
      await Future.delayed(Duration(seconds: 1));
      String name = data['name'] ?? 'Unknown Pizza';
      double price = (data['price'] as num?)?.toDouble() ?? 0.0;
      String? sauce = data['sauce'];
      List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

      // В отличие от asyncMap, где объект возвращается через return,
      // используется ключевое слово yield для добавления элемента в возвращаемый поток
      // asyncExpand собирает все элементы из этих порожденных потоков в единый результирующий поток
      yield Pizza(
        name: name,
        price: price,
        sauce: sauce,
        toppings: toppings,
      );

      // ВАЖНО!!!
      // В этом примере порождается только один элемент в потоке, но мы могли бы
      // использовать multiple yields для создания нескольких элементов из одного входного JSON.
      // Например, если бы хотели создать несколько вариантов пиццы:

      // if (toppings != null && toppings.isNotEmpty) {
      //   // Создаем вариант без топпингов
      //   yield Pizza(
      //     name: "$name (Basic)",
      //     price: price - 2.0,
      //     sauce: sauce,
      //     toppings: [],
      //   );
      // }
    } catch (e) {
      throw 'Error creating Pizza: $e';
    }
  });

  pizzaStream.listen(
    (pizza) => print(pizza),
    onError: (error) => print(error),
  );

  // Метод listen сразу возвращает управление, не блокируя основной поток выполнения.
  print('Подписка на поток создана. Ожидаем получения объектов Pizza...');

  // Если бы здесь был дополнительный код, он выполнился бы до получения результатов из потока!
}
