Stream<int> myAsyncGenerator(int n) async* {
  var k = 0;
  while(k < n){
    if (k % 4 == 0){
      yield k;
    }
    k++;
  }
}

void main(List<String> arguments) {
  Stream<int> sequence = myAsyncGenerator(30);
  sequence.listen(print);	// 0  4  8 … 28
}
