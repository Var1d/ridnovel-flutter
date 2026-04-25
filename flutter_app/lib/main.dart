// Farid Dhiya Fairuz
// 247006111058
// B

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/novel_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RidNovelApp());
}

class RidNovelApp extends StatelessWidget {
  const RidNovelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NovelProvider()),
      ],
      child: MaterialApp(
        title: 'RidNovel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7C3AED),
            surface: Color(0xFF0D1117),
          ),
          scaffoldBackgroundColor: const Color(0xFF0D1117),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
