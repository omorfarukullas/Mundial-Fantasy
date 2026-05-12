import 'package:freezed_annotation/freezed_annotation.dart';

part 'league.freezed.dart';
part 'league.g.dart';

@freezed
class League with _$League {
  const factory League({
    required String id,
    required String name,
    required String inviteCode,
    required String creatorId,
    required bool isPublic,
    required DateTime createdAt,
  }) = _League;

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);
}
