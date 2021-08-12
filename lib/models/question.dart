import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  Question({
    required this.id,
    required this.answer,
    required this.question,
    required this.soundMap,
  });

  static Question fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Question(
      id: data['id'],
      answer: data['answer'],
      question: Map<String, String>.from(data['question']),
      soundMap: Map<String, String>.from(data['soundMap']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'answer': answer,
      'question': question,
      'soundMap': soundMap,
    };
  }

  final String id;
  final String answer;
  final Map<String, String> question;
  final Map<String, String> soundMap;
}
