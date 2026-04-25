// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'novel_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() { _emailCtrl.dispose(); _passwordCtrl.dispose(); _ctrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthProvider>().login(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (success && mounted) {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const NovelListScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 20),
                    const Text('RidNovel', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Masuk ke akun kamu', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 36),
                    Consumer<AuthProvider>(builder: (_, auth, __) {
                      if (auth.errorMessage == null) return const SizedBox.shrink();
                      return Container(
                        width: double.infinity, margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.withOpacity(0.4))),
                        child: Row(children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(auth.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                        ]),
                      );
                    }),
                    _field(controller: _emailCtrl, label: 'Email', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress,
                      validator: (v) { if (v == null || v.isEmpty) return 'Email wajib diisi'; if (!v.contains('@')) return 'Format email tidak valid'; return null; }),
                    const SizedBox(height: 14),
                    _field(controller: _passwordCtrl, label: 'Password', icon: Icons.lock_outline, obscure: _obscure,
                      suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20), onPressed: () => setState(() => _obscure = !_obscure)),
                      validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null),
                    const SizedBox(height: 24),
                    Consumer<AuthProvider>(builder: (_, auth, __) => SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: auth.state == AuthState.loading ? null : _login,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: auth.state == AuthState.loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Belum punya akun? ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      GestureDetector(
                        onTap: () { context.read<AuthProvider>().clearError(); Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())); },
                        child: const Text('Daftar', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String label, required IconData icon,
      bool obscure = false, TextInputType? keyboard, Widget? suffix, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller, obscureText: obscure, keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20), suffixIcon: suffix,
        filled: true, fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }
}
