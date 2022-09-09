import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/data.dart';
import 'package:snake/model/painter.dart';

import '../model/snake_pos.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(
      Duration(milliseconds: snakeSpeed),
      (Timer timer) {
        gameLoop();
      },
    );

    super.initState();
  }

  Position applePosition = Position(
    x: Random.secure().nextInt(12),
    y: Random.secure().nextInt(20),
  );

  int snakeSpeed = 500;
  int runs = 1;

  void gameLoop() {
    for (int i = snakePositions.length - 1; i > 0; i--) {
      final part = snakePositions[i];
      final lastPart = snakePositions[i - 1];

      setState(() {
        part.x = lastPart.x;
        part.y = lastPart.y;
      });
    }

    if (moveDirection == "TOP") {
      setState(() {
        snakePositions[0].y -= 1;
      });
    }
    if (moveDirection == "BOTTOM") {
      setState(() {
        snakePositions[0].y += 1;
      });
    }
    if (moveDirection == "RIGHT") {
      setState(() {
        snakePositions[0].x += 1;
      });
    }
    if (moveDirection == "LEFT") {
      setState(() {
        snakePositions[0].x -= 1;
      });
    }

    if (snakePositions[0].x >= 13 ||
        snakePositions[0].x <= 0 ||
        snakePositions[0].y >= 21 ||
        snakePositions[0].y <= 0) {
      setState(() {
        snakePositions = [
          Position(x: 7, y: 10),
          Position(x: 6, y: 10),
          Position(x: 5, y: 10),
        ];
        moveDirection = "TOP";
        runs += 1;
      });
    }

    for (Position snakePos in snakePositions) {
      if (snakePos == snakePositions[0]) {
        continue;
      }
      if (snakePos.x == snakePositions[0].x &&
          snakePos.y == snakePositions[0].y) {
        setState(() {
          snakePositions = [
            Position(x: 7, y: 10),
            Position(x: 6, y: 10),
            Position(x: 5, y: 10),
          ];
          moveDirection = "TOP";
          runs += 1;
        });
      }
    }

    if (snakePositions[0].x == applePosition.x &&
        snakePositions[0].y == applePosition.y) {
      setState(
        () {
          snakePositions = [
            ...snakePositions,
            Position(
              x: snakePositions[snakePositions.length - 1].x,
              y: snakePositions[snakePositions.length - 1].y,
            ),
          ];
        },
      );
      createNewApple();
    }
  }

  void createNewApple() {
    bool run = true;
    while (run) {
      applePosition = Position(
        x: Random.secure().nextInt(12),
        y: Random.secure().nextInt(20),
      );
      for (Position snakePos in snakePositions) {
        if (applePosition.x != snakePos.x && applePosition.y != snakePos.y) {
          run = false;
        }
      }
      if (applePosition.x <= 0 ||
          applePosition.y <= 0 ||
          applePosition.x >= 13 ||
          applePosition.y >= 21) {
        run = true;
      }
    }
    setState(() {
      applePosition = applePosition;
    });
  }

  String moveDirection = "TOP";

  List<Position> snakePositions = [
    Position(x: 7, y: 10),
    Position(x: 6, y: 10),
    Position(x: 5, y: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Score: ${snakePositions.length - 3}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Runs: $runs",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                if (details.delta.dx > 0 && moveDirection != "LEFT") {
                  moveDirection = "RIGHT";
                }
                if (details.delta.dx < 0 && moveDirection != "RIGHT") {
                  moveDirection = "LEFT";
                }
                if (details.delta.dy > 0 && moveDirection != "TOP") {
                  moveDirection = "BOTTOM";
                }
                if (details.delta.dy < 0 && moveDirection != "BOTTOM") {
                  moveDirection = "TOP";
                }
              },
              child: Container(
                width: 300,
                height: 500,
                decoration: BoxDecoration(
                  color: BLUE,
                  border: Border.all(
                    strokeAlign: StrokeAlign.outside,
                    color: Colors.black,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CustomPaint(
                  painter: GamePainter(
                    snakePositions: snakePositions,
                    applePosition: applePosition,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        snakePositions = [
                          Position(x: 7, y: 10),
                          Position(x: 6, y: 10),
                          Position(x: 5, y: 10),
                        ];
                        moveDirection = "TOP";
                        runs = 1;
                      });
                      createNewApple();
                    },
                    icon: const Icon(Icons.update_rounded),
                    label: const Text("Reset"),
                  ),
                  Slider(
                    value: snakeSpeed.toDouble(),
                    min: 50,
                    max: 1000,
                    onChanged: (newValue) {
                      timer!.cancel();
                      timer = Timer.periodic(
                        Duration(milliseconds: snakeSpeed),
                        (Timer timer) {
                          gameLoop();
                        },
                      );
                      setState(() {
                        snakeSpeed = newValue.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
