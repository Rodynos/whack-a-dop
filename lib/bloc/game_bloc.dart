import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum GameStatus { start, playing, shop, lost, won }

class GameState{
  final int score;
  final GameStatus status;
  final int shopCooldown;

  final double spawnRate;
  final double ballSize;
  final double ballLifetime;
  final double ballSpeed;

  const GameState({
    required this.score, 
    required this.status, 
    required this.shopCooldown,
    required this.spawnRate,
    required this.ballSize,
    required this.ballLifetime,
    required this.ballSpeed,  
  });

  factory GameState.initial() {
    return const GameState(
      score: 10, 
      status: GameStatus.start, 
      shopCooldown: 20,
      spawnRate: 1.0,
      ballSize: 60,
      ballLifetime: 2.0,
      ballSpeed: 1.0,
    );
  }

  GameState copyWith({
    int? score, 
    GameStatus? status, 
    int? shopCooldown, 
    double? spawnRate, 
    double? ballSize, 
    double? ballLifetime, 
    double? ballSpeed}){
    return GameState(
      score: score ?? this.score, 
      status: status ?? this.status, 
      shopCooldown: shopCooldown ?? this.shopCooldown,
      spawnRate: spawnRate ?? this.spawnRate,
      ballSize: ballSize ?? this.ballSize,
      ballLifetime: ballLifetime ?? this.ballLifetime,
      ballSpeed: ballSpeed ?? this.ballSpeed,
    );
  }

  List<Object> get props => [score, status];
}

abstract class GameEvent{}
class StartGame extends GameEvent {}
class EnemyClicked extends GameEvent {
  final int points;

  EnemyClicked({this.points = 1});
}
class EnemyMissed extends GameEvent {}
class ShopClosed extends GameEvent {} 
class PurchaseItem extends GameEvent {
  final int cost;
  PurchaseItem(this.cost);
}
class GameRestarted extends GameEvent {}
class BuyHealth extends GameEvent {}
class ApplyUpgrade extends GameEvent {
  final int cost;
  final double? spawnRateChange;
  final double? ballSizeChange;
  final double? lifeTimeChange;
  final double? speedChange;

  ApplyUpgrade({
    required this.cost,
    this.spawnRateChange,
    this.ballSizeChange,
    this.lifeTimeChange,
    this.speedChange,
  });
}

class GameBloc extends Bloc<GameEvent, GameState>{

  GameBloc() : super(GameState.initial()){

    on<StartGame>((event, emit){
      emit(state.copyWith(score: 10, status: GameStatus.playing, shopCooldown: 20));
    });

    on<GameRestarted>((event, emit){
      emit(GameState.initial());
    });

    on<EnemyClicked>((event, emit){
      if (state.status != GameStatus.playing) return;

      final newScore = state.score + event.points;
      final newShopCooldown = state.shopCooldown - 1;

      if (newShopCooldown <= 0){
        FlameAudio.play('shopopening.mp3', volume: 0.4);
        emit(state.copyWith(score:newScore, status: GameStatus.shop, shopCooldown: 20));
      } else if (newScore >= 100){
        emit(state.copyWith(score: 100, status: GameStatus.won));
      } else {
        emit(state.copyWith(score: newScore, shopCooldown: newShopCooldown));
      }
    });

    on<EnemyMissed>((event, emit){
      if (state.status != GameStatus.playing) return;

      final newScore = state.score - 1;

      if (newScore <= 0){
        emit(state.copyWith(score: 0, status: GameStatus.lost));
      } else {
        emit(state.copyWith(score: newScore));
      }
    });

    on<PurchaseItem>((event, emit){
      if (state.score >= event.cost) {
        emit(state.copyWith(score: state.score - event.cost));
      }
    });

    on<ShopClosed>((event, emit){
      emit(state.copyWith(status: GameStatus.playing));
    });

    on<ApplyUpgrade>((event, emit){
      if (state.score < event.cost) return;

      FlameAudio.play('purchaseupgrade.mp3');

      emit(state.copyWith(
        score: state.score - event.cost,
        status: GameStatus.playing,
        shopCooldown: 20,

        spawnRate: (state.spawnRate + (event.spawnRateChange ?? 0)).clamp(0.2, 5.0),
        ballSize: (state.ballSize + (event.ballSizeChange ?? 0)).clamp(10.0, 150.0),
        ballLifetime: (state.ballLifetime + (event.lifeTimeChange ?? 0)).clamp(0.5, 5.0),
        ballSpeed: (state.ballSpeed + (event.speedChange ?? 0)).clamp(0.1, 5.0),
      ));
    });
  }
}