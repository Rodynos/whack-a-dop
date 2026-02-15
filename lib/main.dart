import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trial_flame/bloc/game_bloc.dart';
import 'package:trial_flame/game/game.dart';
import 'package:trial_flame/game/world.dart';
import 'package:trial_flame/ui/game_over_overlay.dart';
import 'package:trial_flame/ui/game_won_overlay.dart';
import 'package:trial_flame/ui/score_overlay.dart';
import 'package:trial_flame/ui/shop_overlay.dart';
import 'package:trial_flame/ui/start_overlay.dart';

void main() {
  final myGame = WhackADopGame(myWorld: WhackADopWorld());

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWrapper(game: myGame),
    ),
  );
}

class GameWrapper extends StatefulWidget {
  final WhackADopGame game;
  const GameWrapper({super.key, required this.game});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  void _startGame() {
    widget.game.startBgmAndSpawning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: ScoreOverlay(gameBloc: widget.game.gameBloc)),
          
          Positioned.fill(child: GameWidget(game: widget.game)),

          Positioned.fill(
            child: BlocBuilder<GameBloc, GameState>(
              bloc: widget.game.gameBloc,
              builder: (context, state) {

                if (state.status == GameStatus.start) {
                  return StartOverlay(
                    gameBloc: widget.game.gameBloc, 
                    onStart: _startGame
                  );
                }

                if (state.status == GameStatus.lost) {
                  return GameOverOverlay(gameBloc: widget.game.gameBloc);
                }
                
                if (state.status == GameStatus.shop) {
                  return ShopOverlay(gameBloc: widget.game.gameBloc);
                }

                if (state.status == GameStatus.won) {
                  return GameWonOverlay(gameBloc: widget.game.gameBloc);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}