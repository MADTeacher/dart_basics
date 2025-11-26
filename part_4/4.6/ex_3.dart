class Person {
  final String _name;
  int age;
  Person(this._name, this.age);

  int howMuchOlder(Person person) => age - person.age;
  String greet(Person person){
    return 'Привет, ${person._name}!!!. Меня зовут $_name.';
  } 
}

class Alan implements Person{
  @override
  int age = 33;

  @override
  String get _name => 'Алан';

  @override
  String greet(Person person) {
      return 'Привет, ${person._name}!!! Меня зовут $_name.';
    }
  
  @override
  int howMuchOlder(Person person) {
    return age*2 - person.age;
  }
}

class Impostor implements Person {
  @override
  int age = 0;

  @override
  String get _name => '';

  @override
  String greet(Person person) {
    return 'Вот ты и попался, ${person._name}!!!';
  }
  
  @override
  int howMuchOlder(Person person) {
    return -1;
  }
}

String greet(Person firstperson, Person secondPerson){
  return firstperson.greet(secondPerson);
}

int checkAge(Person firstperson, Person secondPerson){
  return firstperson.howMuchOlder(secondPerson);
}

void main(List<String> arguments) {
  var maxim = Person('Макс', 45);
  var alan = Alan();
  var impostor = Impostor();

  print(greet(maxim, alan)); // Привет, Алан!!!. Меня зовут Макс.
  print(greet(impostor, maxim)); // Вот ты и попался, Макс!!!
  print(checkAge(maxim, alan)); // 12
  print(checkAge(alan, maxim)); // 22
}
