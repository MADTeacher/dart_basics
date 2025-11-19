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
    strBuf.write('Pizza(name: $name, price: $price,');
    strBuf.write('sauce: $sauce, toppings: $toppings)');
    return strBuf.toString();
  }
}

class MyTransformer<S, T> implements StreamTransformer<S, T> {
  // Контроллер для управления выходным потоком
  late StreamController<T> _controller;
  // Ссылка на входной поток, данные из которого будем преобразовывать
  late Stream<S> _stream;
  // Подписка на входной поток
  StreamSubscription<S>? _subscription;

  bool cancelOrError = false;
  T Function(S data) onTransform;

  // Основной конструктор. Аргумент sync позволяет задать
  // синхронный режим работы контроллера
  MyTransformer({
    required this.onTransform,
    bool sync = false,
    this.cancelOrError = false,
  }) {
    // Создаем контроллер для выходного потока и указываем ему функции
    // обратного вызова для событий onListen и onCancel,
    // а также передаем методы для паузы и возобновления работы
    // (если подписка уже существует)
    _controller = StreamController<T>(
      onListen: _onListen,
      onCancel: _onCancel,
      onPause: _subscription?.pause,
      onResume: _subscription?.resume,
      sync: sync,
    );
  }

  // Конструктор для создания broadcast-трансформера,
  // который позволяет иметь несколько слушателей выходного потока
  MyTransformer.broadcast({
    required this.onTransform,
    bool sync = false,
    this.cancelOrError = false,
  }) {
    _controller = StreamController<T>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
      sync: sync,
    );
  }

  // Метод _onListen вызывается при появлении слушателя у выходного
  // потока. Отвечает за прослушивание входного потока и обработку
  // его данных
  void _onListen() {
    _subscription = _stream.listen(
      onData, // Передаем данные из потока в функцию onData
      onError: _controller.addError, // Передаем ошибки в контроллер
      // При завершении входного потока закрываем выходной поток
      onDone: _controller.close,
      // Если установлен флаг cancelOrError, при ошибке
      // автоматически отменяется подписка на stream
      cancelOnError: cancelOrError,
    );
  }

  // Метод _onCancel вызывается в том случае, когда все слушатели
  // выходного потока отменяют подписку на него
  void _onCancel() {
    _subscription?.cancel(); // отменяем подписку на входной поток
    _subscription = null;
  }

  // Метод onData вызывается для каждого элемента входного потока.
  // Он применяет к ним функцию преобразования onTransform и
  // отправляет результат в выходной поток.
  void onData(S data) {
    try {
      _controller.sink.add(onTransform(data));
    } catch (e) {
      _controller.addError(e);
    }
  }

  // Метод bind связывает входной поток с трансформером.
  // Он сохраняет ссылку на входной поток и возвращает выходной поток,
  // который находится под управлением контроллера
  @override
  Stream<T> bind(Stream<S> stream) {
    _stream = stream;
    return _controller.stream;
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

  final pizzaStream = jsonStream.transform(
    MyTransformer<Json, Pizza>.broadcast(
      onTransform: (data) {
        String name = data['name'] ?? 'Unknown Pizza';
        double price = (data['price'] as num?)?.toDouble() ?? 99.9;
        String? sauce = data['sauce'] ?? 'Barbecue';
        List<String>? toppings = (data['toppings'] as List?)?.cast<String>();

        return Pizza(
          name: name,
          price: price,
          sauce: sauce,
          toppings: toppings,
        );
      },
    ),
  );

  // Первый слушатель - выводит всю информацию о пицце
  pizzaStream.listen(
    (pizza) => print('Слушатель 1: $pizza'),
    onError: (error) => print('Слушатель 1 ошибка: $error'),
  );

  // Второй слушатель - выводит только название и цену пиццы
  pizzaStream.listen(
    (pizza) => print('Слушатель 2: Пицца ${pizza.name}, цена: ${pizza.price}'),
    onError: (error) => print('Слушатель 2 ошибка: $error'),
  );

  // Третий слушатель - выводит информацию о топпингах
  pizzaStream.listen(
    (pizza) => print(
      'Слушатель 3: ${pizza.name} с топпингами: ${pizza.toppings ?? "без топпингов"}',
    ),
    onError: (error) => print('Слушатель 3 ошибка: $error'),
  );
}
