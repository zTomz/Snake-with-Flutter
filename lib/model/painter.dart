import 'package:flutter/material.dart';
import 'package:snake/model/snake_pos.dart';

class GamePainter extends CustomPainter {
  List<Position> snakePositions;
  Position applePosition;
  GamePainter({
    required this.snakePositions,
    required this.applePosition,
  });

  // Canvas size = 300 x 500

  double fieldSize = 25;
  bool foodCollected = false;

  double colums = 300 / 25; // 12
  double rows = 500 / 25; // 20

  // Snake Positions

  @override
  void paint(Canvas canvas, Size size) {
    for (Position snakePos in snakePositions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          // Snake Positions
          Rect.fromLTRB(
            fieldSize * (snakePos.x - 1),
            fieldSize * (snakePos.y - 1),
            fieldSize + fieldSize * (snakePos.x - 1),
            fieldSize + fieldSize * (snakePos.y - 1),
          ),
          Radius.circular(fieldSize * 0.4),
        ),
        Paint()
          ..color = const Color(0xFF91FF85)
          ..strokeWidth = 2,
      );
    }

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          // Snake Positions
          Rect.fromLTRB(
            fieldSize * (applePosition.x - 1),
            fieldSize * (applePosition.y - 1),
            fieldSize + fieldSize * (applePosition.x - 1),
            fieldSize + fieldSize * (applePosition.y - 1),
          ),
          Radius.circular(fieldSize * 0.4),
        ),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    if (snakePositions[0].x == oldDelegate.snakePositions[0].x) {
      return true;
    }

    return false;
  }

  // @override
  // bool shouldRebuildSemantics(GamePainter oldDelegate) => false;
}
