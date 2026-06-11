import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeepModeScreen extends StatefulWidget {
  const DeepModeScreen({super.key});

  @override
  State<DeepModeScreen> createState() => _DeepModeScreenState();
}

class _DeepModeScreenState extends State<DeepModeScreen> {
  bool _isActive = false;
  int _totalDays = 30;
  int _daysLeft = 30;
  int _attempts = 0;
  String _goal = '';
  String _personalMessage = '';
  String _mode = 'normal';

  final List<String> _quotes = [
    'الانضباط هو أن تتذكر ما تريده أكثر من أي شيء آخر.',
    'لا تدع شعوراً مؤقتاً يدمر هدفاً دائماً.',
    'النجاح هو الاستمرار عندما يفقد الآخرون الحماس.',
    'أنت أقوى من رغبة مؤقتة في التصفح.',
    'كل يوم تصمد فيه هو انتصار على نفسك.',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isActive = prefs.getBool('deepModeActive') ?? false;
      _totalDays = prefs.getInt('deepModeTotalDays') ?? 30;
      _daysLeft = prefs.getInt('deepModeDaysLeft') ?? 30;
      _attempts = prefs.getInt('deepModeAttempts') ?? 0;
      _goal = prefs.getString('deepModeGoal') ?? '';
      _personalMessage = prefs.getString('deepModeMessage') ?? '';
      _mode = prefs.getString('deepModeType') ?? 'normal';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deepModeActive', _isActive);
    await prefs.setInt('deepModeTotalDays', _totalDays);
    await prefs.setInt('deepModeDaysLeft', _daysLeft);
    await prefs.setInt('deepModeAttempts', _attempts);
    await prefs.setString('deepModeGoal', _goal);
    await prefs.setString('deepModeMessage', _personalMessage);
    await prefs.setString('deepModeType', _mode);
  }

  void _startDeepMode() {
    setState(() {
      _isActive = true;
      _daysLeft = _totalDays;
      _attempts = 0;
    });
    _saveData();
  }

  void _tryCancel() {
    setState(() => _attempts++);
    _saveData();

    if (_mode == 'monk') {
      _showMonkModeDialog();
      return;
    }

    _showCancelLayer1();
  }

  void _showMonkModeDialog() {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('وضع الراهب 🧘', style: TextStyle(color: primary)),
        content: const Text(
          'لا يمكن إيقاف وضع الراهب حتى انتهاء المدة المحددة.\n\nاستمر في طريقك!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً 💪', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _showCancelLayer1() {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('هل أنت متأكد؟ 🤔',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
        content: Text(
          'لقد قطعت شوطاً طويلاً، لا تجعل لحظة ضعف تهدم أياماً من الانضباط.\n\nاليوم ${_totalDays - _daysLeft} من ${_totalDays}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCancelLayer2();
            },
            child: const Text('أريد المتابعة في الإلغاء',
                style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('أكمل التحدي 💪',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showCancelLayer2() {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('هدفك 🎯', style: TextStyle(color: primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withOpacity(0.3)),
              ),
              child: Text(
                _goal.isEmpty ? 'لم تحدد هدفاً بعد' : '"$_goal"',
                style: TextStyle(color: primary, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            if (_personalMessage.isNotEmpty) ...[
              const Text('رسالتك لنفسك:',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _personalMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'منعت $_attempts محاولة تشتيت',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_mode == 'strict') {
                _showStrictModeDialog();
              } else {
                _cancelDeepMode();
              }
            },
            child:
                const Text('إلغاء التحدي', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('ارجع للدراسة 📚',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showStrictModeDialog() {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            Text('الوضع الصارم ⏰', style: TextStyle(color: primary)),
        content: const Text(
          'في الوضع الصارم، يمكنك الإلغاء بعد انتظار 24 ساعة.\n\nإذا كنت ما زلت مقتنعاً غداً، يمكنك الخروج.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _cancelDeepMode() {
    setState(() => _isActive = false);
    _saveData();
  }

  void _showSetupDialog() {
    final primary = Theme.of(context).colorScheme.primary;
    final goalController = TextEditingController(text: _goal);
    final messageController = TextEditingController(text: _personalMessage);
    int selectedDays = _totalDays;
    String selectedMode = _mode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('إعداد Deep Mode',
              style:
                  TextStyle(color: primary, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المدة', style: TextStyle(color: primary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [7, 14, 30, 60, 90].map((days) {
                    return ChoiceChip(
                      label: Text('$days يوم'),
                      selected: selectedDays == days,
                      onSelected: (_) =>
                          setDialogState(() => selectedDays = days),
                      selectedColor: primary,
                      labelStyle: TextStyle(
                          color: selectedDays == days
                              ? Colors.black
                              : Colors.white70),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('مستوى الصعوبة', style: TextStyle(color: primary)),
                const SizedBox(height: 8),
                ...['normal', 'strict', 'monk'].map((m) {
                  final labels = {
                    'normal': 'عادي - يمكن الإيقاف بكلمة مرور',
                    'strict': 'صارم - انتظار 24 ساعة',
                    'monk': 'راهب - لا يمكن الإيقاف نهائياً',
                  };
                  return RadioListTile(
                    value: m,
                    groupValue: selectedMode,
                    onChanged: (v) =>
                        setDialogState(() => selectedMode = v!),
                    title: Text(labels[m]!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    activeColor: primary,
                    dense: true,
                  );
                }),
                const SizedBox(height: 16),
                Text('هدفك', style: TextStyle(color: primary)),
                const SizedBox(height: 8),
                TextField(
                  controller: goalController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'مثال: إنهاء منهج الفيزياء...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: primary.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('رسالة لنفسك عند الضعف',
                    style: TextStyle(color: primary)),
                const SizedBox(height: 8),
                TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'إذا كنت تقرأ هذا فأنت تفكر في الاستسلام...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: primary.withOpacity(0.3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء',
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _totalDays = selectedDays;
                  _mode = selectedMode;
                  _goal = goalController.text;
                  _personalMessage = messageController.text;
                });
                Navigator.pop(ctx);
                _startDeepMode();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('ابدأ التحدي 🚀',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deep Mode',
                style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            Text('ابتعد عن التشتيت كلياً',
                style:
                    TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            if (_isActive) ...[
              // Active State
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text('🛡️',
                        style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'اليوم ${_totalDays - _daysLeft + 1} من $_totalDays',
                      style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_totalDays - _daysLeft) / _totalDays,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(primary),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoChip(
                            label: 'محاولات الفتح',
                            value: '$_attempts',
                            primary: primary),
                        _InfoChip(
                            label: 'أيام متبقية',
                            value: '$_daysLeft',
                            primary: primary),
                      ],
                    ),
                    if (_goal.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '"$_goal"',
                        style: TextStyle(
                            color: primary.withOpacity(0.8),
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Random quote
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _quotes[_attempts % _quotes.length],
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: _tryCancel,
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      child: const Text('إيقاف التحدي',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Inactive State
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    const Text('🧘', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text('ابدأ تحدي الابتعاد',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'حدد مدة، اكتب هدفك، واترك التطبيق يحميك من التشتيت',
                      style:
                          TextStyle(color: Colors.white54, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showSetupDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('ابدأ التحدي 🚀',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Modes explanation
              _ModeCard(
                  title: 'الوضع العادي',
                  desc: 'يمكن إيقافه بكلمة مرور',
                  icon: '🔓',
                  primary: primary),
              _ModeCard(
                  title: 'الوضع الصارم',
                  desc: 'انتظار 24 ساعة قبل الإلغاء',
                  icon: '⚔️',
                  primary: primary),
              _ModeCard(
                  title: 'وضع الراهب',
                  desc: 'لا يمكن إيقافه حتى النهاية',
                  icon: '🧘',
                  primary: primary),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color primary;

  const _InfoChip(
      {required this.label, required this.value, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: primary,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String desc;
  final String icon;
  final Color primary;

  const _ModeCard(
      {required this.title,
      required this.desc,
      required this.icon,
      required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(desc,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
