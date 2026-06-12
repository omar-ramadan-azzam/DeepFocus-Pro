import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  String _currentTheme = 'teal';
  int _focusDuration = 25;
  int _breakDuration = 5;
  int _totalFocusMinutes = 0;
  int _currentStreak = 0;
  int _totalSessions = 0;
  int _xp = 0;
  int _level = 1;
  bool _notificationsEnabled = true;
  bool _motivationalEnabled = true;

  String get currentTheme => _currentTheme;
  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
  int get totalFocusMinutes => _totalFocusMinutes;
  int get currentStreak => _currentStreak;
  int get totalSessions => _totalSessions;
  int get xp => _xp;
  int get level => _level;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get motivationalEnabled => _motivationalEnabled;

  AppProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString('theme') ?? 'deep_gold';
    _focusDuration = prefs.getInt('focusDuration') ?? 25;
    _breakDuration = prefs.getInt('breakDuration') ?? 5;
    _totalFocusMinutes = prefs.getInt('totalFocusMinutes') ?? 0;
    _currentStreak = prefs.getInt('streak') ?? 0;
    _totalSessions = prefs.getInt('totalSessions') ?? 0;
    _xp = prefs.getInt('xp') ?? 0;
    _level = prefs.getInt('level') ?? 1;
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    _motivationalEnabled = prefs.getBool('motivational') ?? true;
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', _currentTheme);
    await prefs.setInt('focusDuration', _focusDuration);
    await prefs.setInt('breakDuration', _breakDuration);
    await prefs.setInt('totalFocusMinutes', _totalFocusMinutes);
    await prefs.setInt('streak', _currentStreak);
    await prefs.setInt('totalSessions', _totalSessions);
    await prefs.setInt('xp', _xp);
    await prefs.setInt('level', _level);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('motivational', _motivationalEnabled);
  }

  void setTheme(String theme) {
    _currentTheme = theme;
    saveData();
    notifyListeners();
  }

  void setFocusDuration(int minutes) {
    _focusDuration = minutes;
    saveData();
    notifyListeners();
  }

  void setBreakDuration(int minutes) {
    _breakDuration = minutes;
    saveData();
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    saveData();
    notifyListeners();
  }

  void setMotivational(bool value) {
    _motivationalEnabled = value;
    saveData();
    notifyListeners();
  }

  void completeSession() {
    _totalSessions++;
    _totalFocusMinutes += _focusDuration;
    _xp += 50;
    _currentStreak++;
    if (_xp >= _level * 200) {
      _level++;
      _xp = 0;
    }
    saveData();
    notifyListeners();
  }
}
