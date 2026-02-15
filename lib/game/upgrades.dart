import 'dart:math';

class GameUpgrade{
  final String title;
  final String description;
  final int cost;

  final double? spawnRateChange; 
  final double? sizeChange;      
  final double? lifetimeChange;  
  final double? speedChange;

  const GameUpgrade({
    required this.title,
    required this.description,
    required this.cost,
    this.spawnRateChange,
    this.sizeChange,
    this.lifetimeChange,
    this.speedChange,
  });

  static List<GameUpgrade> get all {
    return [
      const GameUpgrade(
        title: "Giant's Eye", 
        description: "Balls are huge, but spawn less.", 
        cost: 10,
        sizeChange: 20.0,
        spawnRateChange: 0.5,
      ),

      const GameUpgrade(
        title: "Adrenaline", 
        description: "More balls, but more chaos.", 
        cost: 10,
        spawnRateChange: -0.3,
        speedChange: 1.5,
      ),

      const GameUpgrade(
        title: "Sniper's Scope", 
        description: "Plenty of time, but tiny targets.", 
        cost: 10,
        sizeChange: -15.0,
        lifetimeChange: 1.0,
      ),

      const GameUpgrade(
        title: "Ghost Protocol", 
        description: "More balls, but they vanish quick.", 
        cost: 10,
        spawnRateChange: -0.4,
        lifetimeChange: -0.5,
      ),

      const GameUpgrade(
        title: "Lifter's Dumbbell", 
        description: "Less chaos, but tiny targets.", 
        cost: 10,
        speedChange: -2.0,
        sizeChange: -10.0,
      ),
    ];
  }

  static List<GameUpgrade> getRandomBatch(){
    final random = Random();
    final List<GameUpgrade> list = List.from(all);
    list.shuffle(random);
    return list.take(3).toList();
  }
}