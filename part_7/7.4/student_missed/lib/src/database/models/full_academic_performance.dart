import 'missed_info.dart';

/// Модель полной успеваемости (с днями)
base class FullAcademicPerformanceModel {
  final String studentName;
  final List<MissedInfoModel> missedData;

  FullAcademicPerformanceModel({
    required this.studentName,
    required this.missedData,
  });
}