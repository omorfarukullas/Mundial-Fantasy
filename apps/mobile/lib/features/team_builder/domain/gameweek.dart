import 'package:freezed_annotation/freezed_annotation.dart';

part 'gameweek.freezed.dart';
part 'gameweek.g.dart';

@freezed
class Gameweek with _$Gameweek {
  const factory Gameweek({
    required int id,
    required DateTime deadlineAt,
    required bool isActive,
    required bool isFinished,
  }) = _Gameweek;

  factory Gameweek.fromJson(Map<String, dynamic> json) => _$GameweekFromJson(json);
}

extension GameweekX on Gameweek {
  bool get isLocked => DateTime.now().isAfter(deadlineAt);
}
