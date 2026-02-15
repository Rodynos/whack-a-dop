import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trial_flame/bloc/game_bloc.dart';

class ScoreOverlay extends StatelessWidget {
  final GameBloc gameBloc;

  const ScoreOverlay({super.key, required this.gameBloc});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: BlocBuilder<GameBloc, GameState>(
        bloc: gameBloc,
        builder: (context, state) {
          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain, 
              alignment: Alignment.center,
              child: Text(
                '${state.score}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(49, 255, 255, 255), 
                  height: 1, 
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}