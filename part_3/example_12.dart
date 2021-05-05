int add(int a, int b){
  return a + b;
}

void main(List<String> arguments) {
  var myAdd = add;
  print(myAdd(10,5)); // 15
}
