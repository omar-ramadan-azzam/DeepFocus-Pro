import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'focus_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'deep_mode_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const StatisticsScreen(),
    const DeepModeScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: primary.withOpacity(0.2),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.home, color: primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.bar_chart, color: primary),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.shield, color: primary),
            label: 'Deep Mode',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.settings, color: primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('Deep Focus Pro',
                style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Stay focused, achieve more',
                style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 30),

            // Stats Row
            Row(
              children: [
                _StatCard(
                  label: 'Sessions',
                  value: '${provider.totalSessions}',
                  icon: Icons.timer,
                  primary: primary,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Minutes',
                  value: '${provider.totalFocusMinutes}',
                  icon: Icons.access_time,
                  primary: primary,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Level',
                  value: '${provider.level}',
                  icon: Icons.star,
                  primary: primary,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // XP Bar
            Text('XP Progress',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: provider.xp / (provider.level * 200),
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(primary),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text('${provider.xp} / ${provider.level * 200} XP',
                style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 40),

            // Start Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FocusScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Start Focus Session',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color primary;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
