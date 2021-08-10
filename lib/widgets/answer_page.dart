import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/models/question.dart';
import 'package:music_memory/models/sound.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late final Sound qSound;
  late final List<Sound> soundList;
  bool isInitialized = false;

  Future<void> initialize() async {
    qSound = Sound(soundName: widget.question.question.keys.first, soundUri: widget.question.question.values.first);
    soundList = widget.question.soundMap.keys
        .map((key) => Sound(soundName: key, soundUri: widget.question.soundMap[key]!))
        .toList();
    await Future.wait([
      qSound.init(),
      ...soundList.map((e) => e.init()).toList(),
    ]);
    isInitialized = true;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('問題'),
        ),
        body: Center(
          child: isInitialized
              ? const CupertinoActivityIndicator()
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        for (final sound in soundList) {
                          sound.stop();
                        }

                        await qSound.play();
                      },
                      child: null,
                    ),
                    ...soundList
                        .map(
                          (sound) => ElevatedButton(
                            onPressed: () async {
                              for (final sound in soundList) {
                                sound.stop();
                              }
                              qSound.stop();
                              await sound.play();
                            },
                            child: null,
                          ),
                        )
                        .toList(),
                  ],
                ),
        ),
      ),
    );
  }
}
