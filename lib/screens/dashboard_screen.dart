import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gringo_api.dart';
import '../state/user_state.dart';
import 'player_screen.dart';
import 'chat_overlay.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _painLevel = 5;
  int _energyLevel = 5;
  bool _loading = false;
  Map<String, dynamic>? _recommendation;

  Future<void> _getPersonalizedSession() async {
    setState(() => _loading = true);
    try {
      final user = ref.read(userProvider);
      final api = ref.read(gringoApiProvider);
      
      final result = await api.getPersonalization(
        userId: user.userId ?? 'unknown',
        painLevel: _painLevel,
        energyLevel: _energyLevel,
      );

      setState(() => _recommendation = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _startSession() {
    if (_recommendation == null) return;
    
    // Convert list<dynamic> to list<int>
    final movements = (_recommendation!['movements'] as List)
        .map((e) => e as int)
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerScreen(movementSequence: movements),
      ),
    );
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: const ChatOverlay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(userProvider.notifier).logout();
              Navigator.of(context).pushReplacementNamed('/onboarding');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.fullName ?? "Gringo"}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            
            // Sliders
            _buildSlider('Pain Level (0-10)', _painLevel, (v) => setState(() => _painLevel = v.round())),
            const SizedBox(height: 16),
            _buildSlider('Energy Level (1-10)', _energyLevel, (v) => setState(() => _energyLevel = v.round())),

            const SizedBox(height: 32),
            
            if (_recommendation == null)
              ElevatedButton(
                onPressed: _loading ? null : _getPersonalizedSession,
                child: _loading 
                  ? const CircularProgressIndicator() 
                  : const Text('Get My Session'),
              )
            else ...[
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surface,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Text(
                       'Recommended Focus',
                       style: TextStyle(
                         color: Theme.of(context).colorScheme.primary,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     const SizedBox(height: 8),
                     Text(_recommendation!['message'] ?? 'General Flow'),
                     const SizedBox(height: 16),
                     ElevatedButton.icon(
                       onPressed: _startSession,
                       icon: const Icon(Icons.play_arrow),
                       label: const Text('Start Practice'),
                     ),
                   ],
                 ),
               ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat_bubble_outline),
        onPressed: _openChat,
      ),
    );
  }

  Widget _buildSlider(String label, int value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(label),
             Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
