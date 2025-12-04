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
      'toppings': ['Cheese'],
    },
    {
      'name': 'Pepperoni',
      'price': 10.99,
      'toppings': ['Pepperoni', 'Cheese'],
    },
    {'price': 9.99, 'sauce': 'Barbecue'},
    {},
  ]);

  final pizzaStream = jsonStream.transform(
    // StreamTransformer.fromHandlers – фабричный именованный 
    // конструктор, позволяющий создать экземпляр трансформера 
    // путем определения обработчиков для различных типов событий
    StreamTransformer.fromHandlers(
      // handleData - обработчик каждого элемента данных в исходном потоке
      // Параметры:
      // - data: элемент данных из исходного потока
      // - sink: интерфейс для отправки новых элементов в результирующий поток
      handleData: (data, sink) {
        try {
          String name = data['name'] ?? 'Unknown Pizza';
          double price = (data['price'] as num?)?.toDouble() ?? 0.0;
          String? sauce = data['sauce'];
          List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

          // Метод sink.add отправляет элемент в результирующий поток
          // В отличие от map/asyncMap, здесь мы явно контролируем,
          // когда и какие элементы добавляются в выходной поток
          sink.add(Pizza(
            name: name,
            price: price,
            sauce: sauce,
            toppings: toppings,
          ));

          // ВАЖНО!!! 
          // С помощью sink в выходной поток, для одного входного
          // элемента, можно добавить несколько объектов 
          // например:
          /* if (price > 10.0) {
                 sink.add(Pizza(name: "$name (Premium)", price: price + 2.0)); 
                 sink.add(Pizza(name: "$name (Deluxe)", price: price + 3.0));
             } */


          // Также можно и не добавлять никаких элементов (фильтрация):
          // if (price <= 0) return; // Пропускаем невалидные данные
        } catch (e) {
          sink.addError('Error creating Pizza: $e');
        }
      },
      // handleError позволяет перехватывать и обрабатывать ошибки
      // из входного потока и передавать их в результирующий поток
      handleError: (error, stackTrace, sink) {
        sink.addError(error);
      },
    ),
  );

  pizzaStream.listen(
    (pizza) => print(pizza),
    onError: (error) => print(error),
  );

  print('Ожидаем объекты Pizza...');
}
