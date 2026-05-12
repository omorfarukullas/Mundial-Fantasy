import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/team_builder/domain/models.dart';

class TeamNotifier extends StateNotifier<UserTeam> {
  TeamNotifier() : super(const UserTeam(players: []));

  void addPlayer(Player player) {
    if (state.players.length >= 15) return; // Basic squad limit
    if (state.remainingBudget < player.price) return;
    
    state = state.copyWith(
      players: [...state.players, player],
      remainingBudget: state.remainingBudget - player.price,
    );
  }

  void removePlayer(Player player) {
    state = state.copyWith(
      players: state.players.where((p) => p.id != player.id).toList(),
      remainingBudget: state.remainingBudget + player.price,
    );
  }

  void setFormation(String formation) {
    state = state.copyWith(formation: formation);
  }
}

final teamProvider = StateNotifierProvider<TeamNotifier, UserTeam>((ref) {
  return TeamNotifier();
});
