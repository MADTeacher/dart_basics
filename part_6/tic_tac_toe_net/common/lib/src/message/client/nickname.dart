part of 'client_message.dart';

class NickNameCM extends ClientMessage {
  final String nickName;
  NickNameCM(this.nickName) : super(CMType.nickName);

  factory NickNameCM.fromJson(Map<String, dynamic> json) {
    return NickNameCM(json['nickName'] as String);
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'nickName': nickName,
    };
  }
}