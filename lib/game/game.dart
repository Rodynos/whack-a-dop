import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trial_flame/bloc/game_bloc.dart';
import 'package:trial_flame/components/game_border.dart';
import 'package:trial_flame/game/world.dart';

class WhackADopGame extends FlameGame {
  final WhackADopWorld myWorld;

  final GameBloc gameBloc = GameBloc();

  late GameBorder gameBorder;

  WhackADopGame({required this.myWorld}); 

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await FlameAudio.audioCache.loadAll([
      'button.mp3',
      'hit.mp3',
      'MusicHappy6BySkibkaMusic.mp3',
      'purchaseupgrade.mp3',
      'shopopening.mp3',
    ]);

    await FlameAudio.createPool('hit.mp3', minPlayers: 1, maxPlayers: 6);
    await FlameAudio.createPool('shopopening.mp3', minPlayers: 1, maxPlayers: 2);
    await FlameAudio.createPool('purchaseupgrade.mp3', minPlayers: 1, maxPlayers: 2);
    await FlameAudio.createPool('button.mp3', minPlayers: 1, maxPlayers: 2);

    gameBorder = GameBorder();
    
    await add(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [
          myWorld,
        ],
      ),
    );

    camera.world = myWorld;
    camera.viewport.add(gameBorder);
  }

  void startBgmAndSpawning() {
    FlameAudio.bgm.play('MusicHappy6BySkibkaMusic.mp3', volume: 0.5);
    myWorld.startSpawning();
  }

  void shakeCamera() {
    // Check if a shake is already running to avoid "earthquake" stacking
    if (camera.viewfinder.children.whereType<MoveEffect>().isNotEmpty) return;

    final effect = MoveEffect.by(
      Vector2(10, 10), // Shake intensity (10 pixels)
      EffectController(
        duration: 0.05, // Very fast
        alternate: true, // Go back and forth
        repeatCount: 3,  // Shake 3 times
      ),
    );
    
    camera.viewfinder.add(effect);
  }

  void tintBorder(Color color){
    gameBorder.tintBorder(color);
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    super.onRemove();
  }
}