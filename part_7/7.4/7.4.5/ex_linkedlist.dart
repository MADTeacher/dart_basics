import 'dart:collection';

base class Worker extends LinkedListEntry<Worker> {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  String toString() => '($name, $id)';
}

void main() {
  var workersList = LinkedList<Worker>();

  // Добавляем элементы в конец LinkedList
  workersList.add(Worker('Stas', 1));
  workersList.add(Worker('Alina', 2));
  Worker marina = Worker('Marina', 3);
  workersList.add(marina);
  print(workersList);

  // Получение первого и последнего элемента
  print(workersList.first);
  print(workersList.last);

  // Добавление нового элемента в начало списка
  workersList.addFirst(Worker('Vlad', 4));
  print(workersList);
  // или
  workersList.first.insertBefore(Worker('Max', 5));
  print(workersList);

  // Еще один способ добавления нового элемента в конец списка
  workersList.last.insertAfter(Worker('Kira', 9));
  print(workersList);

  // Проверка наличия элемента и его удаление
  // проводятся по уникальному идентификатору объекта
  print(workersList.contains(marina)); // true
  // Удаление элемента
  print(workersList.remove(marina)); // true
  // Следующий элемент не удалится, т.к. передается новый объект
  print(workersList.remove(Worker('Alina', 2))); // false
  print(workersList);

  // Удаление первого и последнего элемента
  workersList.first.unlink();
  workersList.last.unlink();
  print(workersList);

  // Удаление элемента по индексу
  workersList.elementAt(1).unlink();
  print(workersList);

  // Проверка, пустой ли список
  print(workersList.isEmpty);
  print(workersList.isNotEmpty);

  // Количество элементов в списке
  print(workersList.length);

  // Итерация по списку
  for (Worker worker in workersList) {
    print(worker);
  }

  // Очистка всего списка
  workersList.clear();
  print(workersList);
}