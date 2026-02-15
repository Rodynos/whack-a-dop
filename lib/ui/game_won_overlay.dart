import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:whack_a_dop/bloc/game_bloc.dart';

class GameWonOverlay extends StatelessWidget {
  final GameBloc gameBloc;

  const GameWonOverlay({super.key, required this.gameBloc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(650, 300, 650, 300),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8), 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 118, 233, 3), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "GAME WON",
              style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 66, 218, 5), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 64, 225, 10),
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