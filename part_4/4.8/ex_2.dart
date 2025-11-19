class Item{
  final String name;
  final double weight;

  Item(this.name, this.weight) ;
}

abstract class StorageSystem {
  void addItem(Item item);

  Item popItem();

  double systemWeight();
}

class Box implements StorageSystem {
  var itemsList = <Item>[];
  final double weightLimit;

  Box(this.weightLimit);

  @override
  void addItem(Item item) {
    var currentSystemWeight = systemWeight();
    if((currentSystemWeight+item.weight) < weightLimit){
      itemsList.add(item);
      print('${item.name} добалнен(о/а) в коробку!');
    }
    else{
      print('${item.name} не помещается в коробку!');
    }
  }

  
@override
  Item popItem() {
    return itemsList.removeLast();
  }

  @override
  double systemWeight() {
    var sum = 0.0;
    for (var element in itemsList) {
      sum += element.weight;
    }
    return sum;
  }
  // методы, характерные для коробки
}

class Cupboard implements StorageSystem {
  var itemsList = <Item>[];

  @override
  void addItem(Item item) {
    itemsList.add(item);
    print('${item.name} добалнен(о/а) в шкаф!');
  }

  @override
  Item popItem() {
    return itemsList.removeLast();
  }

  @override
  double systemWeight() {
    var sum = 0.0;
    for (var element in itemsList) {
      sum += element.weight;
    }
    return sum;
  }
  // методы, характерные для шкафа
}

void main(List<String> arguments) {
  var box = Box(18);
  var cupboard = Cupboard();
  StorageSystem? storageSystem = box;
  storageSystem.addItem(Item('Книга', 2.6));
  storageSystem.addItem(Item('Чайник', 3.9));
  storageSystem.addItem(Item('Гантеля', 10));
  storageSystem.addItem(Item('Монитор', 4));

  print(storageSystem.popItem().name);
  print(storageSystem.systemWeight());

  storageSystem = cupboard;
  print(storageSystem.systemWeight());
  storageSystem.addItem(Item('Монитор', 4));
  storageSystem.addItem(Item('Чайник', 3.9));
  print(storageSystem.systemWeight());
}
