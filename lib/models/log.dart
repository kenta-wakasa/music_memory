import 'package:music_memory/repositories/user_data.dart';

class TimeStampLog {
  TimeStampLog({
    required this.questionId,
    required this.key,
    required this.value,
  });

  @override
  String toString() {
    return '$time, $experimentId, $subjectId, $questionId, $key, $value';
  }

  final DateTime time = DateTime.now();
  final String experimentId = UserData.instance.experiment!.ref.id;
  final String subjectId = UserData.instance.subjectId;
  final String questionId;
  final String key;
  final String value;
}
