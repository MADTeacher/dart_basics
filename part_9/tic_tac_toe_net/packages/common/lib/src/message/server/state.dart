part of 'server_message.dart';

class SuccessSM extends ServerMessage {
  SuccessSM() : super(SMType.success);

  factory SuccessSM.fromJson(Map<String, dynamic> json) {
    return SuccessSM();
  }

  @override
  Map<String, dynamic> _getBody() {
    return {};
  }
}

class ErrorSM extends ServerMessage {
  final String message;
  ErrorSM(this.message) : super(SMType.error);

  factory ErrorSM.fromJson(Map<String, dynamic> json) {
    return ErrorSM(json['message'] as String);
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'message': message,
    };
  }
}