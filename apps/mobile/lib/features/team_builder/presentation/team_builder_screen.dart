import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/team_builder/presentation/providers/team_provider.dart';
import 'package:mobile/features/team_builder/presentation/widgets/pitch_view.dart';

class TeamBuilderScreen extends ConsumerWidget {
  const TeamBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final formations = ['4-4-2', '4-3-3', '3-5-2', '5-3-2'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Team'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Budget: \$${teamState.remainingBudget.toStringAsFixed(1)}m',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Formation Picker
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: formations.length,
              itemBuilder: (context, index) {
                final formation = formations[index];
                final isSelected = teamState.formation == formation;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(formation),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(teamProvider.notifier).setFormation(formation);
                    },
                  ),
                );
              },
            ),
          ),
          
          // Pitch View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PitchView(
                players: teamState.players,
                formation: teamState.formation,
              ),
            ),
          ),
          
          // Stats Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Players', value: '${teamState.players.length}/15'),
                const _StatItem(label: 'GW1 Points', value: '0'),
                const _StatItem(label: 'Global Rank', value: '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
