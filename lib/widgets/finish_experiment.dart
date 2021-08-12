import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/main.dart';
import 'package:music_memory/repositories/user_data.dart';
import 'package:music_memory/utils/utils.dart';

class FinishExperiment extends StatelessWidget {
  const FinishExperiment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('実験完了'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Text('ご協力ありがとうございました！'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                  final res = await UserData.instance.uploadLog();
                  // アップロードに失敗したら処理を終了する。
                  if (!res) {
                    Navigator.of(context).pop();
                    return;
                  }
                  UserData.instance.reset();
                  pushAndRemoveUntilPage(context, const MainPage());
                },
                child: const Text('実験データをアップロードする'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
