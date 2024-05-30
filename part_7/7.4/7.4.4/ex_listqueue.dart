import 'dart:collection';
import 'dart:io';

void main() {
  // Создание новой пустой очереди типа ListQueue
  // и приведение к интерфейсу Queue
  Queue<int> queue = ListQueue<int>(50);

  // Добавление элементов в очередь
  queue.add(1); // в конец
  queue.addLast(2); // также в конец
  queue.addFirst(0); // в начало

  print(queue); // {0, 1, 2}

  // Удаление элемента из очереди
  var first = queue.removeFirst(); // удаляет и возвращает первый элемент
  print(first); // 0
  queue.removeLast(); // удаляет и возвращает последний элемент

  print(queue); // {1}

  // Доступ к элементам в очереди
  int firstElement = queue.first; // возвращает первый элемент
  int lastElement = queue.last; // возвращает последний элемент
 
  print('$firstElement $lastElement'); // 1 1

  // Проверка на пустоту
  print(queue.isEmpty); // false
  print(queue.isNotEmpty); // true

  // Проверка наличия элемента
  print(queue.contains(1)); // true
  print(queue.contains(5)); // false

  queue.clear(); // очистка очереди
  print(queue); // {}

  queue.addAll([-1, 2, 3, 4, -2, -1, -5, 0]); // добавление элементов
  print(queue); // {-1, 2, 3, 4, -2, -1, -5, 0}

  queue.remove(2); // удаление элемента по значению
  print(queue); // {-1, 3, 4, -2, -1, -5, 0}

  // удаление элементов по условию
  queue.removeWhere((element) => element < 0); 
  print(queue); // {3, 4, 0}

  // обращение к элементу очереди по индексу
  print(queue.elementAt(1)); // 4

  for (var it in queue) {
    stdout.write('$it '); // 3 4 0
  }
}