// Класс исключения для базы данных
class DbException implements Exception {
  final String message;
  DbException(this.message);

  @override
  String toString() => message;
}
