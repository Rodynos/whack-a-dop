import 'package:flutter/material.dart';
import 'package:whack_a_dop/bloc/game_bloc.dart';

class StartOverlay extends StatelessWidget {
  final GameBloc gameBloc;
  final VoidCallback onStart;

  const StartOverlay({
    super.key, 
    required this.gameBloc, 
    required this.onStart
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "WHACK-A-DOP",
              style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Reach 100 points",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: onStart,
              child: const Text("START GAME", style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}