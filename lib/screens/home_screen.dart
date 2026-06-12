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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: primary.withOpacity(0.1))),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: primary.withOpacity(0.15),
          height: 65,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white38),
              selectedIcon: Icon(Icons.home_rounded, color: primary),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, color: Colors.white38),
              selectedIcon: Icon(Icons.bar_chart_rounded, color: primary),
              label: 'الإحصائيات',
            ),
            NavigationDestination(
              icon: Icon(Icons.shield_outlined, color: Colors.white38),
              selectedIcon: Icon(Icons.shield_rounded, color: primary),
              label: 'Deep Mode',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.white38),
              selectedIcon: Icon(Icons.settings_rounded, color: primary),
              label: 'الإعدادات',
            ),
          ],
        ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deep Focus Pro',
                        style: TextStyle(
                            color: primary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5)),
                    Text('ابقَ مركزاً، حقق أهدافك',
                        style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: primary, size: 16),
                      const SizedBox(width: 4),
                      Text('Lv ${provider.level}',
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Stats Row
            Row(
              children: [
                _StatCard(label: 'جلسات', value: '${provider.totalSessions}', icon: Icons.timer_rounded, primary: primary),
                const SizedBox(width: 10),
                _StatCard(label: 'دقائق', value: '${provider.totalFocusMinutes}', icon: Icons.access_time_rounded, primary: primary),
                const SizedBox(width: 10),
                _StatCard(label: 'تتابع 🔥', value: '${provider.currentStreak}', icon: Icons.local_fire_department_rounded, primary: primary),
              ],
            ),

            const SizedBox(height: 20),

            // XP Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المستوى ${provider.level}',
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                      Text('${provider.xp} / ${provider.level * 200} XP',
                          style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: provider.xp / (provider.level * 200),
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation(primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Start Button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FocusScreen()),
              ),
              child: Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primary.withOpacity(0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_rounded, color: Colors.black, size: 28),
                    SizedBox(width: 10),
                    Text('ابدأ جلسة تركيز',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ضع هاتفك بعيداً وركز على مهمة واحدة فقط',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ),
                ],
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
