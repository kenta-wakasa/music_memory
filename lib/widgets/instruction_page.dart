import 'package:flutter/material.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key, required this.experimentId}) : super(key: key);
  final String experimentId;

  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
