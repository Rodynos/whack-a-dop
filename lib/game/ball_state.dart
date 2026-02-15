import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:trial_flame/components/ball.dart';

abstract class BallState {
  void update(double dt, Ball ball, [double speed = 1]);
  void onTap(Ball ball);
  void onEnter(Ball ball) {}
}

class SpawningState implements BallState {
  @override
  void update(double dt, Ball ball, [double speed = 1]) {}

  @override
  void onTap(Ball ball) {
    ball.onClicked();
    ball.changeState(VanishingState());
  }

  @override
  void onEnter(Ball ball) {
    ball.visual.scale = Vector2.zero();

    ball.visual.add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.2),
        onComplete: () => ball.changeState(ActiveState()),
      ),
    );
  }
}

class ActiveState implements BallState {
  @override
  void update(double dt, Ball ball, [double speed = 1]) {
    ball.strategy.move(ball, dt, speed);

    ball.lifeTime -= dt;

    if (ball.lifeTime <= 0) {
      ball.onMissed();
      ball.changeState(VanishingState());
    }
  }

  @override
  void onTap(Ball ball) {
    ball.onClicked();
    ball.changeState(VanishingState());
  }

  @override
  void onEnter(Ball ball) {}
}

class VanishingState implements BallState {
  @override
  void update(double dt, Ball ball, [double speed = 1]) {}

  @override
  void onTap(Ball ball) {}

  @override
  void onEnter(Ball ball) {
    ball.visual.add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.2),
        onComplete: () => ball.despawn(),
      ),
    );
  }
}

class NonActiveState implements BallState {
  @override
  void update(double dt, Ball ball, [double speed = 1]) {}

  @override
  void onTap(Ball ball) {}

  @override
  void onEnter(Ball ball) {
    ball.visual.scale = Vector2.zero();
    ball.visual.removeAll(ball.visual.children.whereType<Effect>());
  }
}
