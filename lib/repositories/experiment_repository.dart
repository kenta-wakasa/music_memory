import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_memory/models/experiment.dart';

class ExperimentRepository {
  ExperimentRepository._();
  static CollectionReference<Map<String, dynamic>> get _ref => FirebaseFirestore.instance.collection('experiments');

  static Future<List<Experiment>> fetchExperimentList() async {
    final snapShot = await _ref.get();

    return snapShot.docs
        .map(
          (e) => Experiment(
            name: e['name'],
            ref: e.reference,
          ),
        )
        .toList();
  }
}
