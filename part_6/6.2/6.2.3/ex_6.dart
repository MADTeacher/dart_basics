import 'dart:async';

typedef Json = Map<String, dynamic>;

class Pizza {
  final String name;
  final double price;
  final String? sauce;
  final List<String>? toppings;

  Pizza({required this.name, required this.price, this.sauce, this.toppings});

  @override
  String toString() {
    var strBuf = StringBuffer();
    strBuf.write('Pizza(name: $name, price: $price, ');
    strBuf.write('sauce: $sauce, toppings: $toppings)');
    return strBuf.toString();
  }
}

// Класс MyTransformer реализует интерфейс StreamTransformer и позволяет
// преобразовывать данные одного потока в данные другого типа
// S — тип входных данных, а T — тип выходных данных
class MyTransformer<S, T> implements StreamTransformer<S, T> {
  T Function(S data) onTransform;
  bool cancelOrError;

  MyTransformer({required this.onTransform, this.cancelOrError = false});

  // Метод bind связывает входной поток с трансформером.
  // Он сохраняет ссылку на входной поток и возвращает выходной поток,
  // который находится под управлением контроллера
  @override
  Stream<T> bind(Stream<S> stream) {
    // Переменная для хранения подписки на входной поток
    StreamSubscription<S>? subscription;

    // Создаем контроллер, который управляет выходным потоком, а также
    // позволяет добавлять данные, обрабатывать ошибки
    // и закрывать поток
    final controller = StreamController<T>(
      // Если поток отменяется, отменяем и подписку на входной поток
      onCancel: () => subscription?.cancel(),
      // Приостанавливаем подписку, если поток ставится на паузу
      onPause: () => subscription?.pause(),
      // Возобновляем подписку, когда поток продолжается
      onResume: () => subscription?.resume(),
    );

    // Подписываемся на входной поток
    subscription = stream.listen(
      // Каждый раз, когда получаем данные, применяем функцию
      // onTransform и добавляем результат в выходной поток
      (data) => controller.add(onTransform(data)),
      // Если возникает ошибка, передаем её в контроллер для дальнейшей обработки
      onError: controller.addError,
      // Когда входной поток завершается, закрываем выходной поток
      onDone: controller.close,
      // Если установлен флаг cancelOrError, при ошибке
      // автоматически отменяется подписка на stream
      cancelOnError: cancelOrError,
    );

    // Возвращаем выходной stream, которым управляет контроллер
    return controller.stream;
  }

  // Метод cast позволяет привести типы, если это необходимо
  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
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

  // Применяем наш трансформер MyTransformer к потоку jsonStream.
  // Он преобразует каждый JSON-объект в объект типа Pizza.
  final pizzaStream = jsonStream.transform(
    MyTransformer(
      onTransform: (data) {
        String name = data['name'] ?? 'Unknown Pizza';
        double price = (data['price'] as num?)?.toDouble() ?? 99.9;
        String? sauce = data['sauce'] ?? 'Barbecue';
        List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

        // Возвращаем экземпляр класса Pizza
        return Pizza(
          name: name,
          price: price,
          sauce: sauce,
          toppings: toppings,
        );
      },
    ),
  );

  pizzaStream.listen((pizza) => print(pizza), onError: (error) => print(error));
}
