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

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _secondsLeft = provider.focusDuration * 60;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Session Complete! 🎉',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
        content: const Text('Great work! Time for a break.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            child: Text('Start Break', style: TextStyle(color: primary)),
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
    final total = (_isBreak
            ? provider.breakDuration
            : provider.focusDuration) *
        60;
    final progress = 1 - (_secondsLeft / total);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isBreak ? 'Break Time' : 'Focus Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isBreak ? '☕ Take a Break' : '🎯 Stay Focused',
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 50),

            // Timer Circle
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(primary),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          _formatTime(_secondsLeft),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 4,
                          ),
                        ),
                        Text(
                          _isBreak ? 'Break' : 'Focus',
                          style: TextStyle(
                              color: primary.withOpacity(0.7), fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 60),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh, color: Colors.white54),
                  iconSize: 36,
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: _isRunning ? _pauseTimer : _startTimer,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: _onTimerComplete,
                  icon: const Icon(Icons.skip_next, color: Colors.white54),
                  iconSize: 36,
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text(
              'Sessions today: ${provider.totalSessions}',
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
