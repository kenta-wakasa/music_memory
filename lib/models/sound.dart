import 'package:audioplayers/audioplayers.dart';
import 'package:music_memory/models/log.dart';
import 'package:music_memory/models/question.dart';
import 'package:music_memory/repositories/user_data.dart';

class Sound {
  Sound({
    required this.soundName,
    required this.soundUri,
  });

  final audioPlayer = AudioPlayer();
  final String soundUri;
  final String soundName;

  Future<void> init() async {
    await audioPlayer.setUrl(soundUri);
  }

  void play(Question question) async {
    UserData.instance.addLog(
      TimeStampLog(questionId: question.id, key: 'play', value: soundName),
    );
    await audioPlayer.resume();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}
