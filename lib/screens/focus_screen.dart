import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _secondsLeft = 0;
  bool _isRunning = false;
  bool _isBreak = false;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  String _selectedSound = 'none';
  int _selectedSession = 0;

  final List<Map<String, dynamic>> _sessionTypes = [
    {'label': 'عمل عميق', 'icon': '🧠', 'duration': 50, 'color': 0xFF00BFA5},
    {'label': 'دراسة', 'icon': '📚', 'duration': 25, 'color': 0xFF4DA3FF},
    {'label': 'تأمل', 'icon': '🧘', 'duration': 15, 'color': 0xFFA855F7},
    {'label': 'استراحة', 'icon': '☕', 'duration': 10, 'color': 0xFFF0A028},
  ];

  final List<Map<String, dynamic>> _sounds = [
    {'id': 'none', 'label': 'بدون', 'icon': '🔇'},
    {'id': 'rain', 'label': 'مطر', 'icon': '🌧️'},
    {'id': 'forest', 'label': 'غابة', 'icon': '🌲'},
    {'id': 'ocean', 'label': 'أمواج', 'icon': '🌊'},
    {'id': 'birds', 'label': 'عصافير', 'icon': '🐦'},
    {'id': 'fire', 'label': 'نار', 'icon': '🔥'},
    {'id': 'cafe', 'label': 'كافيه', 'icon': '☕'},
    {'id': 'wind', 'label': 'رياح', 'icon': '💨'},
  ];

  final List<String> _quotes = [
    'أنت أقرب مما تعتقد 💪',
    'كل دقيقة تقربك من هدفك 🎯',
    'الانضباط يبني المستقبل 🚀',
    'لا تستسلم، النجاح قادم ⭐',
    'أنت أقوى من أي تشتيت 🛡️',
    'ركز الآن، استمتع لاحقاً 🏆',
    'كل جلسة تغيرك للأفضل ✨',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _secondsLeft = provider.focusDuration * 60;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        _onTimerComplete();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    final provider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _secondsLeft = _sessionTypes[_selectedSession]['duration'] * 60;
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (!_isBreak) {
      provider.completeSession();
      setState(() {
        _isBreak = true;
        _secondsLeft = provider.breakDuration * 60;
        _isRunning = false;
      });
      _showCompletionDialog();
    } else {
      setState(() {
        _isBreak = false;
        _secondsLeft = _sessionTypes[_selectedSession]['duration'] * 60;
        _isRunning = false;
      });
    }
  }

  void _showCompletionDialog() {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('أحسنت! 🎉',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('جلسة ${_sessionTypes[_selectedSession]['label']} مكتملة!',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('+50 XP 🌟',
                style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withOpacity(0.3)),
              ),
              child: Text(
                _quotes[DateTime.now().second % _quotes.length],
                style: TextStyle(color: primary, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إنهاء', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _startTimer(); },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('ابدأ الاستراحة ☕',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final primary = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final sessionColor = Color(_sessionTypes[_selectedSession]['color']);
    final totalSeconds = _sessionTypes[_selectedSession]['duration'] * 60;
    final progress = 1 - (_secondsLeft / totalSeconds);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(_isBreak ? '☕ استراحة' : '${_sessionTypes[_selectedSession]['icon']} ${_sessionTypes[_selectedSession]['label']}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Session Type Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_sessionTypes.length, (i) {
                  final s = _sessionTypes[i];
                  final isSelected = _selectedSession == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSession = i;
                          if (!_isRunning) {
                            _secondsLeft = s['duration'] * 60;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(s['color']).withOpacity(0.15)
                              : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(s['color']).withOpacity(0.5)
                                : Colors.white.withOpacity(0.06),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(s['icon'], style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 2),
                            Text(s['label'],
                                style: TextStyle(
                                    color: isSelected
                                        ? Color(s['color'])
                                        : Colors.white38,
                                    fontSize: 9,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            Text('${s['duration']}د',
                                style: const TextStyle(
                                    color: Colors.white24, fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Timer Circle
            Expanded(
              flex: 4,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow rings
                        if (_isRunning) ...[
                          Container(
                            width: 300 + (_pulseController.value * 15),
                            height: 300 + (_pulseController.value * 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: sessionColor.withOpacity(0.06),
                                  blurRadius: 60,
                                  spreadRadius: 30,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 270 + (_pulseController.value * 10),
                            height: 270 + (_pulseController.value * 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sessionColor.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                          ),
                        ],

                        // Progress Circle
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.white.withOpacity(0.06),
                            valueColor: AlwaysStoppedAnimation(sessionColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),

                        // Inner content
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bg,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isBreak ? '☕' : _sessionTypes[_selectedSession]['icon'],
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(_secondsLeft),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                _isBreak ? 'استراحة' : _sessionTypes[_selectedSession]['label'],
                                style: TextStyle(
                                    color: sessionColor.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الهدف: ${_sessionTypes[_selectedSession]['duration']} دقيقة',
                                style: const TextStyle(
                                    color: Colors.white24, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Sound Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎵 أصوات التركيز',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sounds.length,
                      itemBuilder: (context, index) {
                        final sound = _sounds[index];
                        final isSelected = _selectedSound == sound['id'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSound = sound['id']),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? sessionColor.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? sessionColor.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.06),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(sound['icon'],
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 5),
                                Text(sound['label'],
                                    style: TextStyle(
                                        color: isSelected
                                            ? sessionColor
                                            : Colors.white38,
                                        fontSize: 11,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ControlBtn(
                        icon: Icons.refresh_rounded,
                        onTap: _resetTimer,
                        color: Colors.white38,
                        size: 52,
                        bg: Colors.white.withOpacity(0.05),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: _isRunning ? _pauseTimer : _startTimer,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: sessionColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: sessionColor.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 42,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      _ControlBtn(
                        icon: Icons.skip_next_rounded,
                        onTap: _onTimerComplete,
                        color: Colors.white38,
                        size: 52,
                        bg: Colors.white.withOpacity(0.05),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SmallBtn(
                        label: 'إنهاء الجلسة',
                        icon: Icons.stop_rounded,
                        color: Colors.red.withOpacity(0.7),
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      _SmallBtn(
                        label: 'استراحة سريعة',
                        icon: Icons.coffee_rounded,
                        color: Colors.white38,
                        onTap: () {
                          _timer?.cancel();
                          setState(() {
                            _isBreak = true;
                            _isRunning = false;
                            _secondsLeft = 5 * 60;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final Color bg;

  const _ControlBtn({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.size,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
