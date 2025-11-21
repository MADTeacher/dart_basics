part of 'client_message.dart';

class WinnerListCM extends ClientMessage {
  WinnerListCM() : super(CMType.getWinnerList);

  factory WinnerListCM.fromJson(Map<String, dynamic> json) {
    return WinnerListCM();
  }

  @override
  Map<String, dynamic> _getBody() {
    return {};
  }
}

class WinnerInfoCM extends ClientMessage {
  final String winner;

  WinnerInfoCM(
    this.winner,
  ) : super(CMType.getWinnerInfo);

  factory WinnerInfoCM.fromJson(Map<String, dynamic> json) {
    return WinnerInfoCM(
      json['winner'] as String,
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'winner': winner,
    };
  }
}