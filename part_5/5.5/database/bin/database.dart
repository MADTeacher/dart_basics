import 'package:database/database.dart';

import 'menu.dart';

void main(List<String> arguments) {
  var db = Database(
    pathToSuaiDB: 'bin\\suai.txt',
    pathToUneconDB: 'bin\\unecon.txt',
  );

  var menu = Menu(db);
  menu.loop();
}
