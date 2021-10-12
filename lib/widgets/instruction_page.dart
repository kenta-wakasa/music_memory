import 'package:flutter/material.dart';
import 'package:music_memory/models/experiment.dart';
import 'package:music_memory/repositories/user_data.dart';
import 'package:music_memory/utils/utils.dart';
import 'package:music_memory/widgets/answer_page.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key, required this.experiment}) : super(key: key);
  final Experiment experiment;

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('実験'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.experiment.instruction),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'IDを入力してください',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: controller.text.isNotEmpty
                  ? () {
                      UserData.instance.subjectId = controller.text;

                      pushAndRemoveUntilPage(
                        context,
                        AnswerPage(
                          question: UserData.instance.questionList[0],
                        ),
                      );
                    }
                  : null,
              child: const Text('実験をはじめる'),
            )
          ],
        ),
      ),
    );
  }
}
