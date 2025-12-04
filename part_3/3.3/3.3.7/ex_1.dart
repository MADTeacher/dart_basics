void main(List<String> arguments) {
  var myList = ['Привет!', 'Я', '-', 'анонимная', 'функция!'];
  myList.forEach((item) {
    print('По индексу ${myList.indexOf(item)} хранится значение => $item');
  });
}
