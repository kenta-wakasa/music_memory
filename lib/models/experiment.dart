import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_memory/models/post_question.dart';

class Experiment {
  Experiment({
    required this.name,
    required this.instruction,
    required this.postQuestionList,
    required this.ref,
  });

  static Experiment fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Experiment(
      instruction: snapshot.data()!['instruction'] ?? '',
      name: snapshot.data()!['name'] ?? '',
      postQuestionList: List<Map<String, dynamic>>.from(snapshot.data()!['postQuestionList'] as List? ?? [])
          .map(
            (e) => PostQuestion(
              question: e['question'] ?? '',
              leftLabel: e['leftLabel'] ?? '',
              rightLabel: e['rightLabel'] ?? '',
            ),
          )
          .toList(),
      ref: snapshot.reference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'instruction': instruction,
      'name': name,
      'postQuestionList': postQuestionList,
      'ref': ref,
    };
  }

  final String name;
  final String instruction;
  final List<PostQuestion> postQuestionList;

  final DocumentReference<Map<String, dynamic>> ref;
}

