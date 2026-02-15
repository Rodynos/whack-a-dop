import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:whack_a_dop/bloc/game_bloc.dart';
import 'package:whack_a_dop/components/ball.dart';
import 'package:whack_a_dop/game/strategies.dart';

class WhackADopWorld extends World with HasGameReference, FlameBlocReader<GameBloc, GameState> {
  final Random _randomPos = Random();
  final Random _randomCol = Random();
  late Timer spawnTimer;

  final List<Ball> _ballPool = [];
  final int _poolSize = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (int i = 0; i < _poolSize; i++){
      final ball = Ball();
      _ballPool.add(ball);
      add(ball);
    }
    
    spawnTimer = Timer(
      1.0,
      onTick: _spawnBall,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    if (bloc.state.status != GameStatus.playing) return;

    super.update(dt);

    if (spawnTimer.limit != bloc.state.spawnRate){
      spawnTimer.limit = bloc.state.spawnRate;
    }
    
    if (bloc.state.status == GameStatus.playing){
      spawnTimer.update(dt);
    }
  }

  void _spawnBall() {
    final Ball? freeBall = _ballPool.firstWhere(
      (ball) => !ball.isActive,
      orElse: () => _ballPool[0],
    );

    if (freeBall == null || freeBall.isActive) return;

    double randomX = (_randomPos.nextDouble() - 0.5) * game.size.x;
    double randomY = (_randomPos.nextDouble() - 0.5) * game.size.y;

    final r = _randomCol.nextInt(256);
    final g = _randomCol.nextInt(256);
    final b = _randomCol.nextInt(256);
    const int a = 180;

    MovementStrategy strategy = StaticStrategy();
    final choice = _randomPos.nextInt(3);
    if (choice == 0){
      strategy = StaticStrategy();
    } else if (choice == 1){
      strategy = WiggleStrategy();
    } else if (choice == 2){
      strategy = GravityStrategy();
    }

    bool isCoin = _randomPos.nextDouble() < 0.05;

    freeBall.spawn(Vector2(randomX, randomY), Color.fromARGB(a, r, g, b), strategy, isCoin: isCoin);  
  }

  void startSpawning(){
    bloc.add(StartGame());
    spawnTimer.start();
  }
} 