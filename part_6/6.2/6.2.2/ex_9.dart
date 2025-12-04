import 'dart:async';
import 'dart:math';

final _random = Random();

enum OrderType { cappuccino, latte, espresso }

class Order {
  static int _orderId = 1;
  late final int orderId;
  final OrderType orderType;

  Order(this.orderType) {
    orderId = _orderId++;
  }

  @override
  String toString() {
    return 'order ($orderId): ${orderType.name}';
  }
}

abstract class BaseBarista {
  final _update = StreamController<int>.broadcast();

  StreamSubscription<int> subscribe(void Function(int) update);
  void takeOrder(Order order);
  Order getOrder(int orderId);
}

class Barista extends BaseBarista {
  final _orders = <Order>[];
  final _finishOrder = <Order>[];

  @override
  void takeOrder(Order order) {
    print('Barista accepted $order');
    _orders.add(order);
  }

  @override
  Order getOrder(int orderId) {
    Order? clientOrder;
    for (var order in _finishOrder) {
      if (order.orderId == orderId) {
        clientOrder = order;
        break;
      }
    }
    if (clientOrder is Order) {
      _finishOrder.remove(clientOrder);
      return clientOrder;
    } else {
      throw ArgumentError('Oo');
    }
  }

  void processingOrder() {
    if (_orders.isNotEmpty) {
      var order = _orders[_random.nextInt(_orders.length)];
      _orders.remove(order);
      _finishOrder.add(order);
      print('Barista has completed $order');
      _update.sink.add(order.orderId);
    } else {
      print('Barista rubs the coffee machine');
    }
  }

  @override
  StreamSubscription<int> subscribe(void Function(int p1) update) {
    return _update.stream.listen(update);
  }
}

class Client {
  final String name;
  final BaseBarista _barista;
  Order? _order;
  StreamSubscription<int>? _subscription;

  Client(this.name, this._barista);

  void update(int orderId) async {
    if (_order is Order) {
      if (orderId == _order!.orderId) {
        print('Client $name took ${_barista.getOrder(orderId)}');
        await _subscription?.cancel();
      }
    }
  }

  void createOrder() {
    var orderType = OrderType.values[_random.nextInt(
      OrderType.values.length,
    )];
    _order = Order(orderType);
    print('Client $name made $_order');
    _barista.takeOrder(_order!);
    _subscription = _barista.subscribe(update);
  }
}

void main() {
  var names = <String>[
    'Alexander',
    'George',
    'Maksim',
    'Hermann',
    'Oleg',
    'Alexey',
    'Stanislav'
  ];

  var barista = Barista();
  var clients = <Client>[for (var name in names) Client(name, barista)];
  for (var client in clients) {
    print('*' * 30);
    client.createOrder();
  }
  print('*' * 30);
  print('*' * 4 + 'Barista starts to fill orders' + '*' * 4);

  for (var it = 0; it < 10; it++) {
    print('*' * 30);
    barista.processingOrder();
  }
}
