// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'novel_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    await context.read<AuthProvider>().checkStoredToken();
    if (!mounted) return;
    final isAuth = context.read<AuthProvider>().isAuthenticated;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => isAuth ? const NovelListScreen() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.4), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 54),
                ),
                const SizedBox(height: 24),
                const Text('RidNovel', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                const Text('Your Novel Collection', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 48),
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFF7C3AED), strokeWidth: 2.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
