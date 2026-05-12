import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/team_builder/domain/gameweek.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final activeGameweekProvider = FutureProvider<Gameweek?>((ref) async {
  final response = await Supabase.instance.client
      .from('gameweeks')
      .select()
      .eq('is_active', true)
      .maybeSingle();

  if (response == null) return null;
  return Gameweek.fromJson(response);
});
