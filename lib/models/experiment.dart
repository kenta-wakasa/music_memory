import 'package:cloud_firestore/cloud_firestore.dart';

class Experiment {
  Experiment({
    required this.name,
    required this.instruction,
    required this.ref,
  });

  static Experiment fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Experiment(
      instruction: snapshot.data()!['instruction'] ?? '',
      name: snapshot.data()!['name'],
      ref: snapshot.reference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'instruction': instruction,
      'name': name,
      'ref': ref,
    };
  }

  final String name;
  final String instruction;
  final DocumentReference<Map<String, dynamic>> ref;
}
