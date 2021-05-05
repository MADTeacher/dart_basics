class MyID {
  final int id;
  final String idString;

  MyID(this.id): idString = id.toString();

  @override
  String toString() {
    return idString;
  }
}

T firstElement<T>(List<T> list){
  return list[0];
}

void main(List<String> arguments) {
  var list = <MyID>[MyID(2), MyID(33)];
  print(firstElement(list)); // 2
}
