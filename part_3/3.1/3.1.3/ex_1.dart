var topLevel = 'Сверх-доступная переменная';
void topLevelFunction(){
  print(topLevel);
  var firstLevel= 'Не очень доступная переменная';
  void firstLevelFunction(){
    print(topLevel);
    print(firstLevel);
    var secondLevel= 'Так себе доступная переменная';
    void secondLevelFunction(){
      print(topLevel);
      print(firstLevel);
      print(secondLevel);
    }
    secondLevelFunction();
  }
  firstLevelFunction();
}

void main(List<String> arguments) {
  topLevelFunction();
}
