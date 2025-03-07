void main(List<String> arguments) {
  String name = 'Tommy';
  int age = 10;
  String? master;

  Map<String, dynamic> cat = {
    'name': name,
    'age': age,
    // эта пара ключ:значение не попадет в таблицу
    'firstMaster': ?master, 
    // эта пара попадет, но значение будет null
    ?'secondMaster': master,
  };
  print(cat); // {name: Tommy, age: 10, secondMaster: null}

  master = 'Alex'; // задаем имя хозяина кота
  Map<String, dynamic> newCat = {
    'name': name,
    'age': age,
    'master1': ?master,
    ?'master2': master,
  };
  print(newCat); // {name: Tommy, age: 10, master1: Alex, master2: Alex}
}
