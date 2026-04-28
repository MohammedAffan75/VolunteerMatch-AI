import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_match_ai/screens/auth/login_screen.dart';
import 'package:volunteer_match_ai/screens/auth/onboarding_screen.dart';
import 'package:volunteer_match_ai/screens/auth/register_screen.dart';
import 'package:volunteer_match_ai/screens/chat/chat_list_screen.dart';
import 'package:volunteer_match_ai/screens/dashboard/dashboard_screen.dart';
import 'package:volunteer_match_ai/screens/home/opportunities_screen.dart';
import 'package:volunteer_match_ai/screens/home/opportunity_form_screen.dart';
import 'package:volunteer_match_ai/screens/matches/smart_matches_screen.dart';
import 'package:volunteer_match_ai/screens/profile/profile_screen.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';
import 'package:volunteer_match_ai/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  runApp(const ProviderScope(child: VolunteerMatchApp()));
}

class VolunteerMatchApp extends StatelessWidget {
  const VolunteerMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolunteerMatch AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF148F77),
          secondary: const Color(0xFF2E86C1),
        ),
      ),
      routes: {
        '/': (_) => const AppEntry(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => const RootNavScreen(),
        '/opportunity-form': (_) => const OpportunityFormScreen(),
        '/matches': (_) => const SmartMatchesScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/chats': (_) => const ChatListScreen(),
      },
    );
  }
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data != null) return const RootNavScreen();
        return const LoginScreen();
      },
    );
  }
}

class RootNavScreen extends StatefulWidget {
  const RootNavScreen({super.key});

  @override
  State<RootNavScreen> createState() => _RootNavScreenState();
}

class _RootNavScreenState extends State<RootNavScreen> {
  int _index = 0;

  final _screens = const [
    OpportunitiesScreen(),
    SmartMatchesScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Matches'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'My Activity'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
