import 'package:flutter/material.dart';

class TextField1 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controllers;
  final String hint;
  final bool obscuretext;
  const TextField1(
      {super.key,
      this.controllers,
      required this.hint,
      required this.obscuretext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controllers,
        obscureText: obscuretext,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          fillColor: const Color.fromARGB(255, 239, 238, 238),
          filled: true,
          hintText: hint,
        ),
      ),
    );
  }
}
