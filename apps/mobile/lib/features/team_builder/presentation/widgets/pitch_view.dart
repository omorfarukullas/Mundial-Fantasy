import 'package:flutter/material.dart';
import 'package:mobile/features/team_builder/domain/models.dart';

class PitchView extends StatelessWidget {
  final List<Player> players;
  final String formation;

  const PitchView({
    super.key,
    required this.players,
    required this.formation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[800],
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Pitch lines (Simplified)
              Center(
                child: Container(
                  width: width * 0.9,
                  height: height * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                ),
              ),
              
              // Players
              ..._buildPlayerWidgets(width, height),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPlayerWidgets(double width, double height) {
    // This is a simplified positioning logic
    // In a real app, we would map players to specific formation slots
    final List<Widget> widgets = [];
    
    // Positions for 4-4-2 (normalized 0-1)
    final positions = [
      Offset(0.5, 0.85), // GK
      Offset(0.2, 0.65), Offset(0.4, 0.65), Offset(0.6, 0.65), Offset(0.8, 0.65), // DEF
      Offset(0.2, 0.40), Offset(0.4, 0.40), Offset(0.6, 0.40), Offset(0.8, 0.40), // MID
      Offset(0.35, 0.15), Offset(0.65, 0.15), // FWD
    ];

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final player = i < players.length ? players[i] : null;

      widgets.add(
        Positioned(
          left: pos.dx * width - 30,
          top: pos.dy * height - 40,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: player != null ? Colors.blue : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: player != null 
                  ? const Icon(Icons.person, color: Colors.white)
                  : const Icon(Icons.add, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  player?.name ?? 'Empty',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
