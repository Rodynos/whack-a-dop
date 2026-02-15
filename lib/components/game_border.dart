import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class GameBorder extends PositionComponent with HasGameReference {
  
  GameBorder() : super(anchor: Anchor.topLeft);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = size;
  }

  @override
  void render(Canvas canvas){
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  void tintBorder(Color color){
    decorator = PaintDecorator.tint(
      Color.fromRGBO(
        (color.r * 255.0).toInt(), 
        (color.g * 255.0).toInt(), 
        (color.b * 255.0).toInt(), 
        0.8
      )
    );
  }
}