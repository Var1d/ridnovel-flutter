// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() { _usernameCtrl.dispose(); _emailCtrl.dispose(); _passwordCtrl.dispose(); _ctrl.dispose(); super.dispose(); }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthProvider>().register(_usernameCtrl.text.trim(), _emailCtrl.text.trim(), _passwordCtrl.text);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () { context.read<AuthProvider>().clearError(); Navigator.pop(context); })),
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(child: Center(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(key: _formKey, child: Column(children: [
            const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF7C3AED), size: 56),
            const SizedBox(height: 16),
            const Text('Buat Akun Baru', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Daftar untuk mulai menggunakan RidNovel', style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Consumer<AuthProvider>(builder: (_, auth, __) {
              if (auth.errorMessage == null) return const SizedBox.shrink();
              return Container(
                width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.withOpacity(0.4))),
                child: Row(children: [const Icon(Icons.error_outline, color: Colors.red, size: 18), const SizedBox(width: 8), Expanded(child: Text(auth.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)))]),
              );
            }),
            _field(controller: _usernameCtrl, label: 'Username', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'Username wajib diisi' : null),
            const SizedBox(height: 14),
            _field(controller: _emailCtrl, label: 'Email', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress,
              validator: (v) { if (v == null || v.isEmpty) return 'Email wajib diisi'; if (!v.contains('@')) return 'Format email tidak valid'; return null; }),
            const SizedBox(height: 14),
            _field(controller: _passwordCtrl, label: 'Password', icon: Icons.lock_outline, obscure: _obscure,
              suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20), onPressed: () => setState(() => _obscure = !_obscure)),
              validator: (v) { if (v == null || v.isEmpty) return 'Password wajib diisi'; if (v.length < 6) return 'Password minimal 6 karakter'; return null; }),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(builder: (_, auth, __) => SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: auth.state == AuthState.loading ? null : _register,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: auth.state == AuthState.loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )),
          ])),
        ))),
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
