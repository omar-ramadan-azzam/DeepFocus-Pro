import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'أسبوع';
  final List<String> _periods = ['يوم', 'أسبوع', 'شهر', 'سنة'];

  final List<Map<String, dynamic>> _weekData = [
    {'day': 'أح', 'hours': 2.5},
    {'day': 'اث', 'hours': 4.0},
    {'day': 'ثل', 'hours': 3.0},
    {'day': 'أر', 'hours': 5.5},
    {'day': 'خم', 'hours': 3.5},
    {'day': 'جم', 'hours': 6.0},
    {'day': 'سب', 'hours': 2.0},
  ];

  final List<Map<String, dynamic>> _achievements = [
    {'title': 'أول خطوة', 'desc': 'أكمل جلسة واحدة', 'icon': '🥉', 'target': 1, 'type': 'sessions'},
    {'title': 'المركز', 'desc': 'أكمل 10 جلسات', 'icon': '🥈', 'target': 10, 'type': 'sessions'},
    {'title': 'المحترف', 'desc': 'أكمل 50 جلسة', 'icon': '🥇', 'target': 50, 'type': 'sessions'},
    {'title': 'المنظم', 'desc': 'تتابع 7 أيام', 'icon': '⭐', 'target': 7, 'type': 'streak'},
    {'title': 'المثابر', 'desc': 'تتابع 10 أيام', 'icon': '🌟', 'target': 10, 'type': 'streak'},
    {'title': 'الأسطورة', 'desc': 'تتابع 25 يوم', 'icon': '👑', 'target': 25, 'type': 'streak'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final primary = Theme.of(context).colorScheme.primary;
    final maxHours = _weekData.map((e) => e['hours'] as double).reduce((a, b) => a > b ? a : b);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإحصائيات',
                    style: TextStyle(
                        color: primary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.calendar_month_rounded, color: primary),
              ],
            ),
            const SizedBox(height: 20),

            // Period Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: _periods.map((p) {
                  final isSelected = _selectedPeriod == p;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(p,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white38,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Main Stats
            Row(
              children: [
                _BigStat(
                  label: 'إجمالي التركيز',
                  value: '${(provider.totalFocusMinutes / 60).toStringAsFixed(1)}',
                  unit: 'ساعة',
                  icon: Icons.access_time_rounded,
                  primary: primary,
                ),
                const SizedBox(width: 10),
                _BigStat(
                  label: 'الجلسات',
                  value: '${provider.totalSessions}',
                  unit: 'جلسة',
                  icon: Icons.timer_rounded,
                  primary: primary,
                ),
                const SizedBox(width: 10),
                _BigStat(
                  label: 'متوسط الجلسة',
                  value: provider.totalSessions > 0
                      ? '${(provider.totalFocusMinutes / provider.totalSessions).toStringAsFixed(0)}'
                      : '0',
                  unit: 'دقيقة',
                  icon: Icons.bar_chart_rounded,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Chart
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
                  Text('التركيز خلال الأسبوع',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _weekData.map((d) {
                      final h = d['hours'] as double;
                      final barH = (h / maxHours) * 100;
                      final isToday = d['day'] == 'سب';
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${h.toStringAsFixed(0)}س',
                              style: TextStyle(
                                  color: isToday ? primary : Colors.white24,
                                  fontSize: 9)),
                          const SizedBox(height: 4),
                          Container(
                            width: 32,
                            height: barH,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isToday
                                    ? [primary, primary.withOpacity(0.5)]
                                    : [
                                        primary.withOpacity(0.4),
                                        primary.withOpacity(0.1)
                                      ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(d['day'],
                              style: TextStyle(
                                  color: isToday ? primary : Colors.white38,
                                  fontSize: 11,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Distribution
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
                  Text('توزيع التركيز',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 12),
                  _DistRow(label: 'عمل عميق', percent: 60, color: const Color(0xFF00BFA5), primary: primary),
                  _DistRow(label: 'دراسة', percent: 25, color: const Color(0xFF4DA3FF), primary: primary),
                  _DistRow(label: 'استراحة', percent: 10, color: const Color(0xFFF0A028), primary: primary),
                  _DistRow(label: 'تأمل', percent: 5, color: const Color(0xFFA855F7), primary: primary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // XP & Level
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('⭐', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text('المستوى ${provider.level}',
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                      Text('${provider.xp} / ${provider.level * 200} XP',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: provider.xp / (provider.level * 200),
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(primary),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${provider.level * 200 - provider.xp} XP للمستوى التالي',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Achievements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإنجازات',
                    style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('${_achievements.where((a) {
                  if (a['type'] == 'sessions') return provider.totalSessions >= a['target'];
                  return provider.currentStreak >= a['target'];
                }).length}/${_achievements.length}',
                    style: TextStyle(color: primary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: _achievements.map((a) {
                final unlocked = a['type'] == 'sessions'
                    ? provider.totalSessions >= a['target']
                    : provider.currentStreak >= a['target'];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: unlocked
                        ? primary.withOpacity(0.1)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: unlocked
                            ? primary.withOpacity(0.3)
                            : Colors.white12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        unlocked ? a['icon'] : '🔒',
                        style: TextStyle(
                            fontSize: unlocked ? 28 : 22,
                            color: unlocked ? null : null),
                      ),
                      const SizedBox(height: 6),
                      Text(a['title'],
                          style: TextStyle(
                              color: unlocked ? Colors.white : Colors.white38,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 2),
                      Text(a['desc'],
                          style: const TextStyle(
                              color: Colors.white24, fontSize: 9),
                          textAlign: TextAlign.center),
                      if (unlocked)
                        Icon(Icons.check_circle_rounded,
                            color: primary, size: 14),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Streak
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
                  Text('سلاسل التركيز 🔥',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StreakStat(
                          label: 'الحالي',
                          value: '${provider.currentStreak}',
                          icon: '🔥',
                          primary: primary),
                      _StreakStat(
                          label: 'أفضل',
                          value: '${provider.currentStreak}',
                          icon: '👑',
                          primary: primary),
                      _StreakStat(
                          label: 'هذا الأسبوع',
                          value: '5',
                          icon: '⚡',
                          primary: primary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final active = i < provider.currentStreak % 7;
                      return Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: active
                              ? primary.withOpacity(0.2)
                              : Colors.white.withOpacity(0.04),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: active ? primary : Colors.white12),
                        ),
                        child: Center(
                          child: Icon(
                            active
                                ? Icons.check_rounded
                                : Icons.remove_rounded,
                            color: active ? primary : Colors.white24,
                            size: 16,
                          ),
                        ),
                      );
                    }),
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

class _BigStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color primary;

  const _BigStat({
    required this.label,
    required this.value,
    required this.unit,
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primary, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text(unit,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

class _DistRow extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;
  final Color primary;

  const _DistRow({
    required this.label,
    required this.percent,
    required this.color,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const Spacer(),
          Text('$percent%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color primary;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: primary,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }
}
