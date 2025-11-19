part of 'server_message.dart';

class NickNamePlayerSM extends ServerMessage {
  final String nickName;

  NickNamePlayerSM(this.nickName) : super(SMType.nickName);

  factory NickNamePlayerSM.fromJson(Map<String, dynamic> json) {
    return NickNamePlayerSM(json['nickName'] as String);
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'nickName': nickName,
    };
  }
}