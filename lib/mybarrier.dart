// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Mybarrier extends StatelessWidget {
  final size;
  Mybarrier({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.green,
        border: Border.all(
          width: 9,
          color: const Color.fromARGB(255, 0, 124, 4),
        ),
      ),
    );
  }
}
