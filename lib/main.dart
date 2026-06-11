import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/app_provider.dart';
import 'themes/app_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const DeepFocusApp(),
    ),
  );
}

class DeepFocusApp extends StatelessWidget {
  const DeepFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return MaterialApp(
      title: 'Deep Focus Pro',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(provider.currentTheme),
      home: const HomeScreen(),
    );
  }
}
