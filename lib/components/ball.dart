import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trial_flame/bloc/game_bloc.dart';
import 'package:trial_flame/game/ball_state.dart';
import 'package:trial_flame/components/ball_visual.dart';
import 'package:trial_flame/game/strategies.dart';
import 'package:trial_flame/game/game.dart';

class Ball extends PositionComponent
    with TapCallbacks, CollisionCallbacks, FlameBlocReader<GameBloc, GameState>, HasGameReference<WhackADopGame> {
  double lifeTime = 1.0;
  late MovementStrategy strategy;

  BallState _currentState = NonActiveState();

  late ui.Image _coinImage;
  late BallVisual visual;

  bool _isCoin = false;

  Ball() : super(size: Vector2.all(60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(CircleHitbox());

    _coinImage = await game.images.load('coinspritesheet.png');

    visual = BallVisual();
    visual.position = size / 2;
    add(visual);

    _currentState.onEnter(this);
  }

  void changeState(BallState newState) {
    visual.removeAll(visual.children.whereType<Effect>());
    _currentState = newState;
    _currentState.onEnter(this);
  }

  void spawn(Vector2 position, Color color, MovementStrategy strategy, {bool isCoin = false}) {
    this.position = position;
    this.strategy = strategy;

    _isCoin = isCoin;

    final s = bloc.state;
    lifeTime = s.ballLifetime;

    if (isCoin) {

      final animation = SpriteAnimation.fromFrameData(
        _coinImage,
        SpriteAnimationData.sequenced(
          amount: 10, 
          stepTime: 0.1, 
          textureSize: Vector2.all(32)),  
      );

      visual.setColor(Colors.amber);
      visual.setAnimation(animation);
      visual.size = Vector2.all(s.ballSize);
      size = visual.size * 0.8;
    } else {
      visual.setColor(color);
      visual.size = Vector2.all(s.ballSize);
      size = visual.size;
    }
    
    changeState(SpawningState());
  }

  void despawn() {
    changeState(NonActiveState());
  }

  void onClicked() {
    FlameAudio.play('hit.mp3');

    final Color effectColor = _isCoin ? Colors.amber : visual.color;

    final int pointsToAdd = _isCoin ? 10 : 1;

    game.tintBorder(effectColor);

    parent!.add(
    ParticleSystemComponent(
      position: position, // Spawn at ball's center
      particle: Particle.generate(
        count: 20,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 200), // Gravity-like effect
          speed: Vector2(
            (Random().nextDouble() - 0.5) * 600, // Random X speed
            (Random().nextDouble() - 0.5) * 600, // Random Y speed
          ),
          child: CircleParticle(
            radius: 4,
            paint: Paint()..color = effectColor, // Match ball color!
          ),
        ),
      ),
    ),
  );

    bloc.add(EnemyClicked(points: pointsToAdd));
  } 

  void onMissed() {
    game.shakeCamera();
    bloc.add(EnemyMissed());
  }

  @override
  void update(double dt) {
    super.update(dt);

    _currentState.update(dt, this, bloc.state.ballSpeed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _currentState.onTap(this);
  }

  bool get isActive => _currentState is! NonActiveState;
}
