class MyClass {
  final int? _privateField;
  MyClass(this._privateField);

  void someMethod1() {
    if (_privateField != null) {
      int i = _privateField!; // OK
    }
  }

  void someMethod2() {
    if (_privateField is int) {
      int i = _privateField!; // OK
    }
  }
}