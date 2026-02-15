import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:trial_flame/bloc/game_bloc.dart';

class GameOverOverlay extends StatelessWidget {
  final GameBloc gameBloc;

  const GameOverOverlay({super.key, required this.gameBloc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(650, 300, 650, 300),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8), 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(fontSize: 50, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                FlameAudio.play('button.mp3');
                gameBloc.add(GameRestarted());
              },
              child: const Text("AGAIN?", style: TextStyle(fontSize: 40)),
            ),
          ],
        ),
      ),
    );
  }
}