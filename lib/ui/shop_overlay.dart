import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:whack_a_dop/bloc/game_bloc.dart';
import 'package:whack_a_dop/game/upgrades.dart';

class ShopOverlay extends StatefulWidget {
  final GameBloc gameBloc;

  const ShopOverlay({super.key, required this.gameBloc});

  @override
  State<ShopOverlay> createState() => _ShopOverlayState();
}

class _ShopOverlayState extends State<ShopOverlay> {
  late List<GameUpgrade> offers;

  @override
  void initState() {
    super.initState();
    offers = GameUpgrade.getRandomBatch();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 4),
          boxShadow: [
            BoxShadow(color: Colors.amber.withValues(alpha: 0.5), blurRadius: 20)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CHOOSE YOUR FATE",
              style: TextStyle(fontSize: 45, color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Current Wealth (Points): ${widget.gameBloc.state.score}",
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // 3 cards row
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: offers.map((upgrade) {
                  return _buildUpgradeCard(context, upgrade);
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // close shop button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () {
                FlameAudio.play('button.mp3');
                widget.gameBloc.add(ShopClosed());
              },
              child: const Text("Skip & Continue", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context, GameUpgrade upgrade) {
    final canAfford = widget.gameBloc.state.score >= upgrade.cost;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: canAfford ? Colors.white : Colors.red.withValues(alpha: 0.3), 
          width: 2
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // header
          Column(
            children: [
              Text(
                upgrade.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                upgrade.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),

          // stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (upgrade.spawnRateChange != null) 
                _statRow("Spawn Rate", upgrade.spawnRateChange!, inverted: true),
              if (upgrade.sizeChange != null) 
                _statRow("Size", upgrade.sizeChange!),
              if (upgrade.lifetimeChange != null) 
                _statRow("Lifetime", upgrade.lifetimeChange!),
              if (upgrade.speedChange != null) 
                _statRow("Speed", upgrade.speedChange!, inverted: true),
            ],
          ),

          // buy button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: canAfford ? Colors.amber : Colors.grey,
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
            ),
            onPressed: canAfford
                ? () {
                    FlameAudio.play('button.mp3');
                    widget.gameBloc.add(ApplyUpgrade(
                      cost: upgrade.cost,
                      spawnRateChange: upgrade.spawnRateChange,
                      ballSizeChange: upgrade.sizeChange,
                      lifeTimeChange: upgrade.lifetimeChange,
                      speedChange: upgrade.speedChange,
                    ));
                  }
                : null, 
            child: Text("Cost: ${upgrade.cost}"),
          ),
        ],
      ),
    );
  }

  // helper for pos or negative statas
  Widget _statRow(String label, double value, {bool inverted = false}) {
    bool isGood = inverted ? value < 0 : value > 0;
    Color color = isGood ? Colors.green : Colors.red;
    String prefix = value > 0 ? "+" : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 20)),
          Text(
            "$prefix$value",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}