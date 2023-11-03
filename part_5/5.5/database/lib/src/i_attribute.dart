abstract interface class IAttribute {
  bool check(String attribute, String value);
  bool change(String attribute, String value);

  @override
  String toString();
}