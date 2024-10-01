import 'dart:async';

import 'package:flappy_bird/mybarrier.dart';
import 'package:flappy_bird/mybird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdyAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool gameStarted = false;
  static double barrierXone = 1.8;
  static double barrierXtwo = barrierXone + 1.4;
  static int score = 0;
  static int bestScore = 0;
  late Timer scoreTimer;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdyAxis;
    });
  }

  void startGame() {
    gameStarted = true;
    score = 0;
    initialHeight = birdyAxis;
    scoreTimer = Timer.periodic(
      const Duration(seconds: 1, milliseconds: 500),
      (timer) {
        setState(() {
          score++;
        });
      },
    );

    Timer.periodic(
      const Duration(milliseconds: 60),
      (timer) {
        setState(() {
          time += 0.05;
          height = -4.9 * time * time + 2.8 * time;
          birdyAxis = initialHeight - height;

          if (birdyAxis > 0.9 || checkCollision()) {
            // Bird hits the ground or a barrier
            timer.cancel();
            scoreTimer.cancel();
            gameStarted = false;
            showResult(); // Show the result dialog
          }

          // Move barriers
          if (barrierXone < -1.4) {
            barrierXone += 3;
          } else {
            barrierXone -= 0.07;
          }

          if (barrierXtwo < -1.4) {
            barrierXtwo += 3;
          } else {
            barrierXtwo -= 0.07;
          }
        });
      },
    );
  }

  bool checkCollision() {
    // Check if the bird has hit the barriers
    if ((barrierXone < 0.2 &&
            barrierXone > -0.2 &&
            (birdyAxis < -0.6 || birdyAxis > 0.6)) ||
        (barrierXtwo < 0.2 &&
            barrierXtwo > -0.2 &&
            (birdyAxis < -0.6 || birdyAxis > 0.6))) {
      return true;
    }
    return false;
  }

  void showResult() async {
    if (score > bestScore) {
      bestScore = score; // Update the best score
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 100, 74, 64),
          content: Text(
            "Your Score : $score",
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Play Again",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      birdyAxis = 0;
      barrierXone = 1.8;
      barrierXtwo = barrierXone + 1.4;
      gameStarted = false;
      time = 0;
      initialHeight = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdyAxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: const Mybird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameStarted
                        ? const Text("")
                        : const Text(
                            'T A P  T O  P L A Y',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXone, 1.3),
                    child: Mybarrier(
                      size: 160.0,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXone, -1.3),
                    child: Mybarrier(
                      size: 240.0,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXtwo, 1.3),
                    child: Mybarrier(
                      size: 230.0,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXtwo, -1.3),
                    child: Mybarrier(
                      size: 170.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SCORE",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 55,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BEST",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          bestScore.toString(),
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
