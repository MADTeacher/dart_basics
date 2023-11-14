class Cat {
  final String name;
  final int age;

  Cat(this.name, this.age);
}

void main() {
  Cat obj = Cat('Tom', 30);
  if (obj case Cat(: int age) when age > 20) {
    print('Cat name is ${obj.name}, age is $age'); 
  }

  obj = Cat('Tommy', 3);
  if (obj case Cat(: int age) when age > 20) {
    print('Cat name is ${obj.name}, age is $age');
  }

  var list = [8, 3];
  if (list case [int a, int b] when a + b > 10) {
    print('list sum is ${a + b}');
  }
}
