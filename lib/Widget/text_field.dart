import 'package:flutter/material.dart';
import 'package:recipe/Utils/constants.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingcontroller;
  final bool isPass;
  final String hintText;
  final IconData icon;

  const TextFieldInput(
      {required this.textEditingcontroller,
      this.isPass = false,
      required this.hintText,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: TextField(
        obscureText: isPass,
        controller: textEditingcontroller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.black45,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xFFedf0f8),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: kprimaryColor,
              ),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }
}
