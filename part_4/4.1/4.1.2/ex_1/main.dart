import 'cat.dart';

void main(List<String> arguments) {
  var cat = const ImmutableCat('Тимоха', 3);
  var newcat = const ImmutableCat('Тимоха', 3);

  var barsik = const ImmutableCat('Барсик', 2);

  print(identical(cat, newcat)); // cat == newcat
  print(identical(cat, barsik)); // cat != barsik
  barsik.helloMaster(); // Мя-я-я-я-у!!!
}
