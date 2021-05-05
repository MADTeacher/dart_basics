import 'animal.dart';
import 'cat.dart';
import 'dog.dart';

void main(List<String> arguments) {
  var animalsList = <Animal>[];
  animalsList.add(Cat('Муся', 4));
  animalsList.add(Cat('Тимоха', 5));
  animalsList.add(Dog('Барсик', 5, 6));
  animalsList.add(Dog('Барбос', 2, 3));
  animalsList.add(Dog('Рекс', 3, 1));

  animalsList[0].sleep(); // Муся засыпает: Хр-р-р-р-р...
  animalsList[3].sleep(); // Барбос засыпает: Хр-р-р-р-р...
  
  print('*' * 30);
  for(var it in animalsList){
    it.helloMaster();
  }
  print('*' * 30);
  for(var it in animalsList){
    if (it is Dog){
      // теперь у it доступны методы класса Dog
      print('${it.name} - собака');
      it.whine();
    }
    else if (it is Cat){
      // теперь у it доступны методы класса Cat
      print('${it.name} - кот');
      it.purr();
    }
    else{
      print('${it.name}? Это что еще за покемон???');
    }
    print('-' * 30);
  }
}
