extension type TinyJson(Object value) {
  Iterable<num> get leaves sync* {
    final it = this.value;
    if (it is num) {
      yield it;
    } else if (it is List<dynamic>) {
      for (var element in it) {
        yield* TinyJson(element).leaves;
      }
    } else {
      throw "Unexpected object type: ${it.runtimeType}";
    }
  }
}

void main() {
  var tiny = TinyJson(<dynamic>[
    <dynamic>[
      1,
      2,
      <dynamic>[3, 4, 5]
    ],
    3,
    <dynamic>[],
  ]);
  print(tiny.leaves);
}
