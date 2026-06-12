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
  late AnimationController _progressController;
  String _selectedSound = 'none';

  final List<Map<String, dynamic>> _sounds = [
    {'id': 'none', 'label': 'بدون صوت', 'icon': '🔇'},
    {'id': 'rain', 'label': 'مطر', 'icon': '🌧️'},
    {'id': 'forest', 'label': 'غابة', 'icon': '🌲'},
    {'id': 'birds', 'label': 'عصافير', 'icon': '🐦'},
    {'id': 'ocean', 'label': 'أمواج', 'icon': '🌊'},
    {'id': 'wind', 'label': 'رياح', 'icon': '💨'},
    {'id': 'fire', 'label': 'نار', 'icon': '🔥'},
    {'id': 'cafe', 'label': 'كافيه', 'icon': '☕'},
  ];

  final List<String> _motivationalQuotes = [
    'ركز! أنت أقرب مما تعتقد 💪',
    'كل دقيقة تركيز تقربك من هدفك 🎯',
    'الانضباط يبني المستقبل 🚀',
    'لا تستسلم، النجاح قادم ⭐',
    'أنت أقوى من أي تشتيت 🛡️',
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
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _progressController.dispose();
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
      _secondsLeft = provider.focusDuration * 60;
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
        _secondsLeft = provider.focusDuration * 60;
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
            Text('جلسة تركيز مكتملة بنجاح!',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _motivationalQuotes[DateTime.now().second % _motivationalQuotes.length],
                style: TextStyle(color: primary, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); _startTimer(); },
            child: Text('ابدأ الاستراحة ☕', style: TextStyle(color: primary)),
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
    final total = (_isBreak ? provider.breakDuration : provider.focusDuration) * 60;
    final progress = 1 - (_secondsLeft / total);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isBreak ? '☕ استراحة' : '🎯 جلسة تركيز',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Timer Circle
            Expanded(
              flex: 3,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        if (_isRunning)
                          Container(
                            width: 280 + (_pulseController.value * 10),
                            height: 280 + (_pulseController.value * 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.1 + _pulseController.value * 0.1),
                                  blurRadius: 40,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation(primary),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(_secondsLeft),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 68,
                                fontWeight: FontWeight.w200,
                                letterSpacing: 4,
                              ),
                            ),
                            Text(
                              _isBreak ? 'استراحة' : 'تركيز',
                              style: TextStyle(color: primary.withOpacity(0.8), fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(color: Colors.white38, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Sound Selector
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sounds.length,
                itemBuilder: (context, index) {
                  final sound = _sounds[index];
                  final isSelected = _selectedSound == sound['id'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSound = sound['id']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primary : Colors.white12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(sound['icon'], style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(sound['label'],
                              style: TextStyle(
                                  color: isSelected ? primary : Colors.white54,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                },
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
                      _ControlButton(
                        icon: Icons.refresh_rounded,
                        onTap: _resetTimer,
                        color: Colors.white38,
                        size: 50,
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: _isRunning ? _pauseTimer : _startTimer,
                        child: Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 45,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      _ControlButton(
                        icon: Icons.skip_next_rounded,
                        onTap: _onTimerComplete,
                        color: Colors.white38,
                        size: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'جلسات اليوم: ${provider.totalSessions}',
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
