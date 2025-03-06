import 'package:dotenv/dotenv.dart';

void main(List<String> arguments) {
  // Если такой связки ключ=значение нет, будет исключение
  var adminID = env.getValue<int>('ADMIN_ID');
  // или
  var adminID2 = (env['ADMIN_ID'] ?? 0) as int;
  // или
  int adminID3 = 0;
  if (env['ADMIN_ID'] != null) {
    adminID3 = env.getValue<int>('ADMIN_ID');
  }
  print(adminID); // 123456789
  print(env['ADMIN_PASSWORD']); // wtfPassword1234
  print(env['ADMIN_EMAIL']); // admin@localhost
  print(env['ADMIN_MODE']); // true
}
