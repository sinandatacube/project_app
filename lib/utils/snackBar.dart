import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
