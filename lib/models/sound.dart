import 'package:audioplayers/audioplayers.dart';

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

  Future<void> play() async {
    await audioPlayer.resume();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }
}
