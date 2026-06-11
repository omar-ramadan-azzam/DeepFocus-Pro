import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

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
            Text('Statistics',
                style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Main Stats
            Row(
              children: [
                _BigStatCard(
                  label: 'Total Sessions',
                  value: '${provider.totalSessions}',
                  icon: Icons.timer,
                  primary: primary,
                ),
                const SizedBox(width: 12),
                _BigStatCard(
                  label: 'Focus Hours',
                  value:
                      '${(provider.totalFocusMinutes / 60).toStringAsFixed(1)}h',
                  icon: Icons.access_time_filled,
                  primary: primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _BigStatCard(
                  label: 'Current Level',
                  value: 'Lv ${provider.level}',
                  icon: Icons.star,
                  primary: primary,
                ),
                const SizedBox(width: 12),
                _BigStatCard(
                  label: 'Streak',
                  value: '${provider.currentStreak} 🔥',
                  icon: Icons.local_fire_department,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // XP Progress
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Level ${provider.level}',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.bold)),
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
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${provider.level * 200 - provider.xp} XP to next level',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Achievements
            Text('Achievements',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _AchievementTile(
              title: 'First Session',
              desc: 'Complete your first focus session',
              unlocked: provider.totalSessions >= 1,
              primary: primary,
            ),
            _AchievementTile(
              title: 'Focus Master',
              desc: 'Complete 10 sessions',
              unlocked: provider.totalSessions >= 10,
              primary: primary,
            ),
            _AchievementTile(
              title: 'Level 5',
              desc: 'Reach level 5',
              unlocked: provider.level >= 5,
              primary: primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color primary;

  const _BigStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primary, size: 28),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style:
                    const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final String title;
  final String desc;
  final bool unlocked;
  final Color primary;

  const _AchievementTile({
    required this.title,
    required this.desc,
    required this.unlocked,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: unlocked ? primary.withOpacity(0.4) : Colors.white12),
      ),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.emoji_events : Icons.lock_outline,
            color: unlocked ? primary : Colors.white24,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: unlocked ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold)),
                Text(desc,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          if (unlocked)
            Icon(Icons.check_circle, color: primary, size: 20),
        ],
      ),
    );
  }
}
