/// Модель информации о пропуске
base class MissedInfoModel {
  final bool isMissed;
  final DateTime day;

  MissedInfoModel({required this.isMissed, required this.day});
}