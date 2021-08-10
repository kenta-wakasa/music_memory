import 'package:music_memory/models/experiment.dart';
import 'package:music_memory/models/question.dart';

class UserData {
  UserData._();
  static final instance = UserData._();
  String userId = '';
  Experiment? experiment;
  List<Question> questionList = [];

  Future<void> fetchQuestionList() async {
    final experiment = this.experiment;
    if (experiment == null) {
      questionList = [];
      return;
    }
    final snapshot = await experiment.ref
        .collection('questions')
        .withConverter<Question>(
            fromFirestore: (snapshot, _) => Question.fromFirestore(snapshot),
            toFirestore: (question, _) => question.toFirestore())
        .get();
    questionList = snapshot.docs.map((e) => e.data()).toList();
  }
}
