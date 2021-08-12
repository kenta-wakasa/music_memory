import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/models/experiment.dart';
import 'package:music_memory/models/log.dart';
import 'package:music_memory/models/question.dart';
import 'package:path_provider/path_provider.dart';

class UserData {
  UserData._();
  static final instance = UserData._();
  String subjectId = '';
  Experiment? experiment;
  List<Question> questionList = [];
  List<TimeStampLog> timeStampLogList = [];

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

  void addLog(TimeStampLog log) {
    UserData.instance.timeStampLogList.add(log);
  }

  Future<bool> uploadLog() async {
    final experiment = this.experiment;
    if (experiment == null) {
      return false;
    }
    final dir = await getApplicationDocumentsDirectory();
    try {
      final logString = timeStampLogList.join('\n');
      final now = DateTime.now();
      File csvFile = File('${dir.path}/log.csv');
      await csvFile.writeAsString(logString);
      await FirebaseStorage.instance.ref().child('${experiment.ref.path}/$now.csv').putFile(csvFile);
      return true;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  void reset() {
    subjectId = '';
    experiment = null;
    questionList.clear();
    timeStampLogList.clear();
  }
}
