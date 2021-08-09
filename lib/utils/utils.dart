import 'package:flutter/material.dart';

Future<T?> pushPage<T>(BuildContext context, Widget page) async {
  return await Navigator.of(context).push<T>(
    MaterialPageRoute(builder: (_) => page),
  );
}

Future<void> pushAndRemoveUntilPage(BuildContext context, Widget page) async {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => page),
    (Route<dynamic> route) => false,
  );
}