import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class BallVisual extends PositionComponent {
  Color color = Colors.white;

  SpriteAnimation? _animation;
  SpriteAnimationTicker? _animationTicker;

  BallVisual()
      : super(
          size: Vector2.all(60),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _animationTicker?.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (_animation != null){
      final sprite = _animationTicker!.getSprite();
      sprite.render(
        canvas,
        position: Vector2.zero(),
        size: size,
      );
    } else {
      final radius = size.x / 2;
      final center = Offset(radius, radius);

      final outer = _darken(color, 0.2).withValues(alpha: 0.85);
      final inner = _lighten(color, 0.25).withValues(alpha: 0.9);

      canvas.drawCircle(center, radius, Paint()..color = outer);
      canvas.drawCircle(center, radius * 0.7, Paint()..color = inner);
    }
  }

  void setColor(Color c) {
    color = c;
    _animation = null;
    _animationTicker = null;
  }

  void setAnimation(SpriteAnimation animation){
    _animation = animation;
    _animationTicker = animation.createTicker();
  }

  Color _lighten(Color c, double amount) {
    return Color.lerp(c, Colors.white, amount)!;
  }

  Color _darken(Color c, double amount) {
    return Color.lerp(c, Colors.black, amount)!;
  }
}
