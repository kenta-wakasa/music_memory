import 'package:cloud_firestore/cloud_firestore.dart';

class Experiment {
  Experiment({
    required this.name,
    required this.ref,
  });
  final String name;
  final DocumentReference<Map<String, dynamic>> ref;
}
