extension type TinyJson(Object it) {
  Iterable<num> get leaves sync* {
    final it = this.it;
    if (it is num) {
      yield it;
    } else if (it is List<dynamic>) {
      for (var element in it) {
        yield* TinyJson(element).leaves;
      }
    } else if (it is Map<String, dynamic>) {
      for (var value in it.values) {
        yield* TinyJson(value).leaves;
      }
    } else {
      throw "Unexpected object type: ${it.runtimeType}";
    }
  }
}

void main() {
  var tiny = TinyJson(<String, Object>{
    "key": [1.98, 2],
    "key2": 3,
    "key3": [{"key4": 3}, {"key5": 53}],
    "key6": {"key7": 33}
  });
  print(tiny.leaves);
}
