class Item{
  final String name;
  final double weight;

  Item(this.name, this.weight) ;
}

class StorageSystem {
  var itemsList = <Item>[];
  final double weightLimit;

  StorageSystem(this.weightLimit);

  void addItem(Item item) => throw NoSuchMethodError;
  Item popItem() => throw NoSuchMethodError;
  double systemWeight()=> throw NoSuchMethodError;
}

class Box extends StorageSystem {
  Box(double weightLimit):super(weightLimit);

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

void main(List<String> arguments) {
  var box = Box(18);
  StorageSystem? storageSystem = box;
  storageSystem.addItem(Item('Книга', 2.6));
  storageSystem.addItem(Item('Чайник', 3.9));
  storageSystem.addItem(Item('Гантеля', 10));
  storageSystem.addItem(Item('Монитор', 4));

  print(storageSystem.popItem().name);
  print(storageSystem.systemWeight());

   StorageSystem? newStorageSystem = StorageSystem(22);
   newStorageSystem.addItem(Item('Монитор', 4));
}
