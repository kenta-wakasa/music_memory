import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Memory',
      theme: ThemeData(),
      home: MainPage(title: 'Music Memory'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final player = AudioCache();
  bool clear = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 100,
            top: 50,
            child: SoundButton(
              player: player,
              fileName: 'se_001.mp3',
            ),
          ),
          Positioned(
            left: 300,
            top: 230,
            child: SoundButton(
              player: player,
              fileName: 'se_002.mp3',
            ),
          ),
          Positioned(
            left: 120,
            top: 400,
            child: SoundButton(
              player: player,
              fileName: 'se_003.mp3',
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: DragTarget<String>(
              builder: (
                context,
                accepted,
                rejected,
              ) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(200),
                    ),
                    color: Colors.amber.withOpacity(.5),
                  ),
                );
              },
              onAccept: (fileName) {
                if (fileName == 'se_002.mp3') {
                  setState(() {
                    clear = true;
                  });
                }
              },
            ),
          ),
          if (clear)
            Center(
              child: Text(
                'CLEAR!!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          player.play('se_002.mp3');
        },
      ),
    );
  }
}

class SoundButton extends StatelessWidget {
  SoundButton({required this.player, required this.fileName});
  final AudioCache player;
  final String fileName;
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: fileName,
      child: RawMaterialButton(
        onPressed: () {
          player.play(fileName);
        },
        shape: CircleBorder(),
        fillColor: Colors.amber,
      ),
      feedback: RawMaterialButton(
        onPressed: () {
          player.play(fileName);
        },
        shape: CircleBorder(),
        fillColor: Colors.amber,
      ),
      childWhenDragging: const SizedBox.shrink(),
    );
  }
}
