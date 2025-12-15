import 'package:flutter/material.dart';
// Verified Push from Antigravity
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GringoApp(),
    ),
  );
}

class GringoApp extends ConsumerWidget {
  const GringoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gringo-QI-Gong',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Simple routing for now - in a real app use GoRouter
      home: const OnboardingScreen(), 
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
