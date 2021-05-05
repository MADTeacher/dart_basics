import 'dart:async';

void main(List<String> arguments) {
  final controller = StreamController<String>();

  final subscription = controller.stream.listen((String data) {
    print(data);
  });

  controller.add('Привет!!!');
  controller.add('И еще раз, Привет!!!');
}
