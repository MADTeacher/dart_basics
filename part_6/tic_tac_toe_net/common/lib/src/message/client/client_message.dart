import 'message_type.dart';

part 'nickname.dart';
part 'board.dart';
part 'rooms.dart';
part 'history.dart';

sealed class ClientMessage {
  final CMType mType;

  ClientMessage(this.mType);

  factory ClientMessage.fromJson(Map<String, dynamic> json) {
    var messageType = CMType.values.firstWhere(
      (e) => e.toString() == json['type'],
    );
    var body = json['body'] as Map<String, dynamic>;
    return switch (messageType) {
      CMType.nickName => NickNameCM.fromJson(body),
      CMType.cellValue => CellValueCM.fromJson(body),
      CMType.roomsList => RoomsListCM.fromJson(body),
      CMType.joinToRoom => JoinToRoomCM.fromJson(body),
      CMType.getWinnerList => WinnerListCM.fromJson(body),
      CMType.getWinnerInfo => WinnerInfoCM.fromJson(body),
      CMType.leaveFromRoom => LeaveFromRoomCM.fromJson(body),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'type': mType.toString(),
      'body': _getBody(),
    };
  }

  Map<String, dynamic> _getBody();
}
