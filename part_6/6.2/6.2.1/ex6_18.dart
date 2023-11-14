void main() async{
  print('Запуск main');
  var count = 0;
  Future.doWhile(() async {
    print('count = $count');
    count++;
    await Future.delayed(Duration(milliseconds: 500));
    return count <= 4;
  });
  // либо
  // Future.doWhile((){
  //   print('count = $count');
  //   count++;
  //   await Future.delayed(Duration(milliseconds: 500));
  //   if (count > 4) {
  //     return false;
  //   };
  //   return true;
  // });
  print('Завершение main');
}
