import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar((
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        text,
      ),
    )
  ));
}
