import 'package:flutter/material.dart';

class AtomPlayWidget extends StatelessWidget {
  const AtomPlayWidget({
    Key? key,
    required this.onPressed,
    this.color,
  }) : super(key: key);
  final Function() onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: color),
      child: const Icon(Icons.play_arrow),
    );
  }
}
