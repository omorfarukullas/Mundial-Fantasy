import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/leagues/domain/league.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

final leaguesProvider = FutureProvider<List<League>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final response = await Supabase.instance.client
      .from('league_members')
      .select('league:leagues(*)')
      .filter('fantasy_team_id', 'in', 
        Supabase.instance.client.from('fantasy_teams').select('id').eq('user_id', user.id)
      );

  return (response as List).map((item) => League.fromJson(item['league'])).toList();
});

class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(leaguesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Leagues')),
      body: leaguesAsync.when(
        data: (leagues) => leagues.isEmpty
            ? const Center(child: Text('You are not in any leagues yet.'))
            : ListView.builder(
                itemCount: leagues.length,
                itemBuilder: (context, index) {
                  final league = leagues[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.group)),
                    title: Text(league.name),
                    subtitle: Text('Code: ${league.inviteCode}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'join',
            onPressed: () => _showJoinDialog(context, ref),
            label: const Text('Join League'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'create',
            onPressed: () => _showCreateDialog(context, ref),
            label: const Text('Create League'),
            icon: const Icon(Icons.create),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join League'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter Invite Code'),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final user = Supabase.instance.client.auth.currentUser;
                final leagueResponse = await Supabase.instance.client
                    .from('leagues')
                    .select()
                    .eq('invite_code', controller.text.trim().toUpperCase())
                    .single();
                
                final teamResponse = await Supabase.instance.client
                    .from('fantasy_teams')
                    .select()
                    .eq('user_id', user!.id)
                    .single();

                await Supabase.instance.client.from('league_members').insert({
                  'league_id': leagueResponse['id'],
                  'fantasy_team_id': teamResponse['id'],
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(leaguesProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to join: $e')),
                  );
                }
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create League'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'League Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final user = Supabase.instance.client.auth.currentUser;
                final inviteCode = _generateRandomCode(8);
                
                final leagueResponse = await Supabase.instance.client.from('leagues').insert({
                  'name': controller.text.trim(),
                  'creator_id': user!.id,
                  'invite_code': inviteCode,
                }).select().single();

                final teamResponse = await Supabase.instance.client
                    .from('fantasy_teams')
                    .select()
                    .eq('user_id', user.id)
                    .single();

                await Supabase.instance.client.from('league_members').insert({
                  'league_id': leagueResponse['id'],
                  'fantasy_team_id': teamResponse['id'],
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(leaguesProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create: $e')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
