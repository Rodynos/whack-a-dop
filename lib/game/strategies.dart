import 'dart:math';
import 'package:flame/components.dart';
import 'package:trial_flame/components/ball.dart';

abstract class MovementStrategy{
  void move (Ball ball, double dt, double speed);
}

class StaticStrategy implements MovementStrategy {
  @override
  void move(Ball ball, double dt, double speed) {}
}

class WiggleStrategy implements MovementStrategy {
  double _time = 0;

  @override
  void move(Ball ball, double dt, double speed) {
    _time += dt * 20 * 2;

    double offsetX = sin(_time) * 2;
    double offsetY = cos(_time) * 2;

    ball.position.add(Vector2(offsetX, offsetY) * dt * 60 * speed); 
  }
}

class GravityStrategy implements MovementStrategy {
  final double fallSpeed = 100.0;

  @override
  void move(Ball ball, double dt, double speed) {
    ball.position.y += fallSpeed * dt;
  }
}