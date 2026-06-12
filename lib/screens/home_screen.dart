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
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
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
              icon: Icon(Icons.insights_outlined, color: Colors.white38),
              selectedIcon: Icon(Icons.insights_rounded, color: primary),
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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late AnimationController _glowController;
  int _selectedSessionType = 0;
  int _dailyGoal = 6;

  final List<Map<String, dynamic>> _sessionTypes = [
    {'label': 'Deep Work', 'icon': '🧠', 'duration': 50},
    {'label': 'دراسة', 'icon': '📚', 'duration': 25},
    {'label': 'تأمل', 'icon': '🧘', 'duration': 10},
    {'label': 'مخصص', 'icon': '⚙️', 'duration': 0},
  ];

  final List<String> _greetings = [
    'صباح التركيز! ☀️',
    'وقت الإنجاز! 🚀',
    'ابدأ الآن! 💪',
    'مساء الإنتاجية! 🌙',
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return _greetings[0];
    if (hour < 15) return _greetings[1];
    if (hour < 18) return _greetings[2];
    return _greetings[3];
  }

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final primary = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final progress = provider.totalSessions / _dailyGoal;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(),
                        style: TextStyle(
                            color: primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3)),
                    Text('ركز على الإنتاج، لا على الانشغال',
                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded, color: primary, size: 16),
                          const SizedBox(width: 4),
                          Text('${provider.currentStreak}',
                              style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('Lv ${provider.level}',
                              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Daily Goal Circle
            Center(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow
                      Container(
                        width: 220 + (_glowController.value * 8),
                        height: 220 + (_glowController.value * 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.08 + _glowController.value * 0.05),
                              blurRadius: 40,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 12,
                          backgroundColor: Colors.white.withOpacity(0.06),
                          valueColor: AlwaysStoppedAnimation(primary),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Inner circle
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bg,
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('هدف اليوم',
                                style: TextStyle(color: Colors.white38, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('$_dailyGoal جلسات',
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${provider.totalSessions} / $_dailyGoal مكتمل',
                                style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('${(progress * 100).clamp(0, 100).toInt()}%',
                                style: TextStyle(
                                    color: primary.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Session Types
            Text('نوع الجلسة',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              children: List.generate(_sessionTypes.length, (i) {
                final session = _sessionTypes[i];
                final isSelected = _selectedSessionType == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSessionType = i),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? primary.withOpacity(0.5) : Colors.white.withOpacity(0.06),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(session['icon'], style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(session['label'],
                              style: TextStyle(
                                  color: isSelected ? primary : Colors.white54,
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          if (session['duration'] > 0)
                            Text('${session['duration']}د',
                                style: TextStyle(color: Colors.white38, fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Start Button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FocusScreen()),
              ),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primary.withOpacity(0.75)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_rounded, color: Colors.black, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      'ابدأ ${_sessionTypes[_selectedSessionType]['label']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Quick Break Button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('☕', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('استراحة سريعة',
                        style: TextStyle(color: Colors.white54, fontSize: 15)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                _MiniStat(
                  label: 'وقت التركيز',
                  value: '${(provider.totalFocusMinutes / 60).toStringAsFixed(1)}س',
                  icon: Icons.access_time_rounded,
                  primary: primary,
                ),
                const SizedBox(width: 10),
                _MiniStat(
                  label: 'الجلسات',
                  value: '${provider.totalSessions}',
                  icon: Icons.timer_rounded,
                  primary: primary,
                ),
                const SizedBox(width: 10),
                _MiniStat(
                  label: 'XP',
                  value: '${provider.xp}',
                  icon: Icons.star_rounded,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Focus Insights
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights_rounded, color: primary, size: 18),
                      const SizedBox(width: 8),
                      Text('Focus Insights',
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Simple bar chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _Bar(height: 30, label: 'أح', primary: primary),
                      _Bar(height: 50, label: 'اث', primary: primary),
                      _Bar(height: 40, label: 'ثل', primary: primary),
                      _Bar(height: 70, label: 'أر', primary: primary),
                      _Bar(height: 45, label: 'خم', primary: primary),
                      _Bar(height: 60, label: 'جم', primary: primary),
                      _Bar(height: 35, label: 'سب', primary: primary, isToday: true),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '💡 أفضل وقت تركيزك: 9-11 صباحاً',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color primary;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final Color primary;
  final bool isToday;

  const _Bar({
    required this.height,
    required this.label,
    required this.primary,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: isToday ? primary : primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white38, fontSize: 9)),
      ],
    );
  }
}
