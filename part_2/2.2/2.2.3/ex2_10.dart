void main(List<String> arguments) {
  final myMap = {"first": 1, "second": 2};
  print(myMap); // {first: 1, second: 2}

  final {"first": first, "second": second} = myMap;
  print("$first, $second"); // 1, 2

  final {"first": a} = myMap;
  print("$a"); // 1

  final {"second": b} = myMap;
  print("$b"); // 2
}
