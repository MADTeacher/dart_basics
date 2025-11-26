var topLevel = 'Сверх-доступная переменная';
void topLevelFunction(){
  print(topLevel);
  var firstLevel= 'Не очень доступная переменная';
  void firstLevelFunction(){
    print(topLevel);
    print(firstLevel);
    var secondLevel= 'Так себе доступная переменная';
  }
  print(secondLevel); // error: Undefined name 'secondLevel'.
}
void main(List<String> arguments) {
  topLevelFunction();
}
