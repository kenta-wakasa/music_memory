import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/models/log.dart';
import 'package:music_memory/models/question.dart';
import 'package:music_memory/models/sound.dart';
import 'package:music_memory/repositories/user_data.dart';
import 'package:music_memory/utils/utils.dart';
import 'package:music_memory/widgets/atoms/atom_play_widget.dart';
import 'package:music_memory/widgets/post_question_page.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Sound qSound;
  List<Sound> soundList = [];
  bool isInitialized = false;

  Future<void> init() async {
    qSound = Sound(
      soundName: widget.question.question.keys.first,
      soundUri: widget.question.question.values.first,
    );
    soundList = widget.question.soundMap.keys
        .map(
          (key) => Sound(
            soundName: key,
            soundUri: widget.question.soundMap[key]!,
          ),
        )
        .toList()
      ..shuffle();

    await Future.wait([
      qSound.init(),
      ...soundList.map((e) => e.init()).toList(),
    ]);
    isInitialized = true;
  }

  void stopAll() {
    qSound.stop();
    for (final sound in soundList) {
      sound.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '${UserData.instance.index + 1} / ${UserData.instance.questionList.length}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          title: const Text('問題'),
        ),
        body: FutureBuilder(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return Column(
              children: [
                const SizedBox(height: 16),
                AtomPlayWidget(
                  color: Colors.amber,
                  onPressed: () async {
                    stopAll();
                    qSound.play(widget.question);
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: soundList
                      .map(
                        (sound) => Column(
                          children: [
                            AtomPlayWidget(
                              onPressed: () async {
                                stopAll();
                                sound.play(widget.question);
                              },
                              color: Colors.blue,
                            ),
                            TextButton(
                              onPressed: () {
                                UserData.instance.addLog(
                                  TimeStampLog(questionId: widget.question.id, key: 'select', value: sound.soundName),
                                );
                                stopAll();
                                pushAndRemoveUntilPage(
                                  context,
                                  PostQuestionPage(
                                    question: widget.question,
                                  ),
                                );
                              },
                              child: const Text('選択'),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
