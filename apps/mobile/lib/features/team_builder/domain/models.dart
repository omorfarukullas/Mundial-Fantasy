import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

enum PlayerPosition {
  @JsonValue('GK') goalkeeper,
  @JsonValue('DEF') defender,
  @JsonValue('MID') midfielder,
  @JsonValue('FWD') forward,
}

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    required PlayerPosition position,
    required double price,
    required String teamName,
    String? photoUrl,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

@freezed
class UserTeam with _$UserTeam {
  const factory UserTeam({
    required List<Player> players,
    @Default('4-4-2') String formation,
    @Default(100.0) double remainingBudget,
  }) = _UserTeam;
}
