import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final IconData icon1;
  final String status;
  final VoidCallback ontaped;

  const Cards(
      {super.key,
      required this.icon1,
      required this.status,
      required this.ontaped});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: ontaped,
      child: Card(
        color: const Color.fromARGB(255, 194, 186, 186),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(
                icon1,
                color: Colors.black,
                size: 24.0,
              ),
              Text(status)
            ],
          ),
        ),
      ),
    ));
  }
}
