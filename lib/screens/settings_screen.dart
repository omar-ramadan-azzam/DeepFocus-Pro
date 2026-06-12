import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            Text('الإعدادات',
                style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Focus Duration
            _SectionTitle(title: '⏱️ مدة التركيز', primary: primary),
            const SizedBox(height: 12),
            _SliderCard(
              label: 'التركيز: ${provider.focusDuration} دقيقة',
              value: provider.focusDuration.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              primary: primary,
              onChanged: (v) => provider.setFocusDuration(v.round()),
            ),
            const SizedBox(height: 8),
            _SliderCard(
              label: 'الاستراحة: ${provider.breakDuration} دقيقة',
              value: provider.breakDuration.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              primary: primary,
              onChanged: (v) => provider.setBreakDuration(v.round()),
            ),

            const SizedBox(height: 24),

            // Themes
            _SectionTitle(title: '🎨 الثيمات', primary: primary),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
              children: [
                _ThemeCard(
                  name: 'deep_gold',
                  label: '🌟 Deep Gold',
                  color: const Color(0xFFF0A028),
                  bg: const Color(0xFF08090D),
                  selected: provider.currentTheme == 'deep_gold',
                  onTap: () => provider.setTheme('deep_gold'),
                ),
                _ThemeCard(
                  name: 'forest',
                  label: '🌲 Forest',
                  color: const Color(0xFF4CAF50),
                  bg: const Color(0xFF07110B),
                  selected: provider.currentTheme == 'forest',
                  onTap: () => provider.setTheme('forest'),
                ),
                _ThemeCard(
                  name: 'ocean',
                  label: '🌊 Ocean',
                  color: const Color(0xFF4DA3FF),
                  bg: const Color(0xFF08121B),
                  selected: provider.currentTheme == 'ocean',
                  onTap: () => provider.setTheme('ocean'),
                ),
                _ThemeCard(
                  name: 'purple',
                  label: '💜 Purple',
                  color: const Color(0xFFA855F7),
                  bg: const Color(0xFF0E0815),
                  selected: provider.currentTheme == 'purple',
                  onTap: () => provider.setTheme('purple'),
                ),
                _ThemeCard(
                  name: 'amoled',
                  label: '⚫ AMOLED',
                  color: const Color(0xFFF0A028),
                  bg: const Color(0xFF000000),
                  selected: provider.currentTheme == 'amoled',
                  onTap: () => provider.setTheme('amoled'),
                ),
                _ThemeCard(
                  name: 'red',
                  label: '🔴 Ruby',
                  color: const Color(0xFFE53935),
                  bg: const Color(0xFF120808),
                  selected: provider.currentTheme == 'red',
                  onTap: () => provider.setTheme('red'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Notifications
            _SectionTitle(title: '🔔 الإشعارات', primary: primary),
            const SizedBox(height: 12),
            _ToggleCard(
              label: 'إشعارات تحفيزية',
              subtitle: 'رسائل تشجيعية كل ساعة',
              value: true,
              primary: primary,
              onChanged: (v) {},
            ),
            const SizedBox(height: 8),
            _ToggleCard(
              label: 'تذكير بالجلسة',
              subtitle: 'تذكيرك ببدء جلسة التركيز',
              value: true,
              primary: primary,
              onChanged: (v) {},
            ),

            const SizedBox(height: 24),

            // App Info
            _SectionTitle(title: '📊 معلومات', primary: primary),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'الإصدار', value: '1.0.0'),
                  _InfoRow(label: 'الجلسات', value: '${provider.totalSessions}'),
                  _InfoRow(label: 'وقت التركيز', value: '${provider.totalFocusMinutes} دقيقة'),
                  _InfoRow(label: 'المستوى', value: '${provider.level}'),
                  _InfoRow(label: 'XP', value: '${provider.xp}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color primary;
  const _SectionTitle({required this.title, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            color: primary, fontSize: 16, fontWeight: FontWeight.bold));
  }
}

class _SliderCard extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color primary;
  final Function(double) onChanged;

  const _SliderCard({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.primary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: primary,
            inactiveColor: Colors.white12,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String name;
  final String label;
  final Color color;
  final Color bg;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.name,
    required this.label,
    required this.color,
    required this.bg,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.white12,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: selected ? color : Colors.white54,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12)),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded, color: color, size: 14),
            ]
          ],
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final Color primary;
  final Function(bool) onChanged;

  const _ToggleCard({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.primary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
