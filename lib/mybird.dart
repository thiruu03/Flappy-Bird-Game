import 'package:flutter/material.dart';

class Mybird extends StatelessWidget {
  const Mybird({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: 80,
        child: Image.asset('assets/images/flappybird.png'));
  }
}
