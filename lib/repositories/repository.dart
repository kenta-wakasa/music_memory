import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_memory/models/experiment.dart';

class Repository {
  Repository._();
  static CollectionReference<Experiment> get _ref => FirebaseFirestore.instance.collection('experiments').withConverter(
        fromFirestore: (snapshot, _) => Experiment.fromFirestore(snapshot),
        toFirestore: (experiment, _) => experiment.toFirestore(),
      );
  static Stream<List<Experiment>> streamExperiment() {
    return _ref.snapshots().asyncMap((event) => event.docs.map((e) => e.data()).toList());
  }
}
