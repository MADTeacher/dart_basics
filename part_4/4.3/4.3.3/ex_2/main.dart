import 'singlecat.dart';

void main(List<String> arguments) {
  var cat = SingleCat('Тимоха', 2);
  var newCat = SingleCat('Твикс', 3);
  print(cat.name); // Тимоха
  print(newCat.name); // Тимоха

  var newCat2 = SingleCat();
  print(newCat2.name); // Тимоха

  print(identical(cat, newCat2)); // true
  print(identical(newCat, newCat2)); // true
}
