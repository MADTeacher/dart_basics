
void main() {
  var myStr = 'Hi!';
  var i = 0;
  while (i < myStr.length) {
    print(myStr[i]); // H i !
    i++;
  }

  i = 0;
  do {
    print(i); // 0  1  2
    i++;
  } while (i < 3);
}
