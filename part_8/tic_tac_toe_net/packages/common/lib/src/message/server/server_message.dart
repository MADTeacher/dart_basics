import '../../board.dart';
import '../../cell_type.dart';
import '../../../match_history.dart';
import 'message_type.dart';

part 'nickname.dart';
part 'state.dart';
part 'rooms.dart';
part 'game.dart';
part 'history.dart';

sealed class ServerMessage {
  final SMType mType;

  ServerMessage(this.mType);

  factory ServerMessage.fromJson(Map<String, dynamic> json) {
    var messageType = SMType.values.firstWhere(
      (e) => e.toString() == json['type'],
    );
    var body = json['body'] as Map<String, dynamic>;
    return switch (messageType) {
      SMType.initiateGame => InitiateGameSM.fromJson(body),
      SMType.success => SuccessSM.fromJson(body),
      SMType.error => ErrorSM.fromJson(body),
      SMType.nickName => NickNamePlayerSM.fromJson(body),
      SMType.roomsInfo => RoomsInfoSM.fromJson(body),
      SMType.opponentLeft => OpponentLeftSM.fromJson(body),
      SMType.joinToRoom => JoinToRoomSM.fromJson(body),
      SMType.updateState => UpdateStateSM.fromJson(body),
      SMType.endGame => EndGameSM.fromJson(body),
      SMType.winnersList => WinnersListSM.fromJson(body),
      SMType.winnerInfo => WinnerInfoSM.fromJson(body),
    };
  }

  Map<String, dynamic> toJson() {
    return {'type': mType.toString(), 'body': _getBody()};
  }

  Map<String, dynamic> _getBody();
}
