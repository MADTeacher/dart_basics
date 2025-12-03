import 'package:client/client.dart';

void main(List<String> arguments) async {
  var client = TicTacToeClient();
  await client.run();
}
