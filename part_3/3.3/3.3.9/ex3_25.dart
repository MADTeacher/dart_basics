int addFunction(List<int> myList){
  print(myList);
  if (myList.length <=1){
    return myList[0];
  }
  else{ return myList[0] + addFunction(myList.sublist(1)); }
}

void main(List<String> arguments) {
  var myList = [10, 20, 30, 5, 3, 2];
  print(addFunction(myList));
}
