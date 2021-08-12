import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/models/log.dart';
import 'package:music_memory/models/post_question.dart';
import 'package:music_memory/models/question.dart';
import 'package:music_memory/models/sound.dart';
import 'package:music_memory/repositories/user_data.dart';
import 'package:music_memory/utils/utils.dart';
import 'package:music_memory/widgets/answer_page.dart';
import 'package:music_memory/widgets/atoms/atom_play_widget.dart';
import 'package:music_memory/widgets/finish_experiment.dart';

class PostQuestionPage extends StatefulWidget {
  const PostQuestionPage({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  _PostQuestionPageState createState() => _PostQuestionPageState();
}

class _PostQuestionPageState extends State<PostQuestionPage> {
  late Sound qSound;
  final postQuestionList = UserData.instance.experiment!.postQuestionList;
  final answerMap = <String, double>{};

  Future<void> init() async {
    for (final postQuestion in postQuestionList) {
      answerMap[postQuestion.question] = 2.0;
    }
    qSound = Sound(
      soundName: widget.question.question.keys.first,
      soundUri: widget.question.question.values.first,
    )..init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('アンケート'),
        ),
        body: FutureBuilder(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AtomPlayWidget(
                      onPressed: () {
                        qSound.stop();
                        qSound.play(widget.question);
                      },
                    ),
                    ...postQuestionList
                        .map(
                          (e) => PostQuestionWidget(
                            postQuestion: e,
                            answerMap: answerMap,
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        for (final key in answerMap.keys) {
                          UserData.instance.addLog(
                            TimeStampLog(
                              questionId: widget.question.id,
                              key: key,
                              value: answerMap[key]!.toInt().toString(),
                            ),
                          );
                        }

                        if (UserData.instance.questionList.isEmpty) {
                          // 実験終了画面に遷移
                          pushAndRemoveUntilPage(context, const FinishExperiment());
                          return;
                        }

                        // 次の問題に遷移
                        pushAndRemoveUntilPage(
                          context,
                          AnswerPage(question: UserData.instance.questionList.removeAt(0)),
                        );
                        return;
                      },
                      child: const Text('この内容で回答する'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostQuestionWidget extends StatefulWidget {
  const PostQuestionWidget({
    Key? key,
    required this.postQuestion,
    required this.answerMap,
  }) : super(key: key);
  final PostQuestion postQuestion;
  final Map<String, double> answerMap;

  @override
  State<PostQuestionWidget> createState() => _PostQuestionWidgetState();
}

class _PostQuestionWidgetState extends State<PostQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(widget.postQuestion.question),
          Slider(
            min: 0,
            max: 4,
            value: widget.answerMap[widget.postQuestion.question]!,
            onChanged: (value) {
              widget.answerMap[widget.postQuestion.question] = value;
              setState(() {});
            },
            divisions: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.postQuestion.leftLabel,
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                widget.postQuestion.rightLabel,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
