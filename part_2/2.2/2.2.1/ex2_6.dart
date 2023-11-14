void main(List<String> arguments) {
  var listA = [1, 2, 3];
  var listB = [4, 5, 6];

  [listA, listB] = [listB, listA];
  print(listA); // [4, 5, 6]
  print(listB); // [1, 2, 3]
}
