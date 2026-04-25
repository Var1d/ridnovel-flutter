// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/novel_model.dart';
import '../providers/auth_provider.dart';
import '../providers/novel_provider.dart';

class NovelFormScreen extends StatefulWidget {
  final bool isEdit;
  final Novel? novel;
  const NovelFormScreen({super.key, required this.isEdit, this.novel});
  @override
  State<NovelFormScreen> createState() => _NovelFormScreenState();
}

class _NovelFormScreenState extends State<NovelFormScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _chaptersCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  bool _isLoading = false;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    if (widget.isEdit && widget.novel != null) {
      _titleCtrl.text = widget.novel!.title;
      _authorCtrl.text = widget.novel!.author;
      _genreCtrl.text = widget.novel!.genre;
      _chaptersCtrl.text = widget.novel!.chapters.toString();
      _ratingCtrl.text = widget.novel!.rating.toString();
    }
  }

  @override
  void dispose() { _titleCtrl.dispose(); _authorCtrl.dispose(); _genreCtrl.dispose(); _chaptersCtrl.dispose(); _ratingCtrl.dispose(); _ctrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final token = context.read<AuthProvider>().token!;
    final data = {
      'title': _titleCtrl.text.trim(), 'author': _authorCtrl.text.trim(), 'genre': _genreCtrl.text.trim(),
      'chapters': int.tryParse(_chaptersCtrl.text) ?? 0,
      'rating': double.tryParse(_ratingCtrl.text) ?? 0.0,
    };
    bool success;
    if (widget.isEdit) {
      success = await context.read<NovelProvider>().updateNovel(token, widget.novel!.id, data);
    } else {
      success = await context.read<NovelProvider>().createNovel(token, data);
    }
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.isEdit ? 'Novel berhasil diupdate!' : 'Novel berhasil ditambahkan!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
      Navigator.pop(context, true);
    } else if (mounted) {
      final err = context.read<NovelProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Terjadi kesalahan'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(widget.isEdit ? 'Edit Novel' : 'Tambah Novel', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3))),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Color(0xFF7C3AED), size: 18), const SizedBox(width: 10),
              Expanded(child: Text(widget.isEdit ? 'Ubah informasi novel "${widget.novel?.title}"' : 'Isi form berikut untuk menambahkan novel baru', style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 24),
          _field(controller: _titleCtrl, label: 'Judul Novel', icon: Icons.title, validator: (v) => (v == null || v.isEmpty) ? 'Judul wajib diisi' : null),
          const SizedBox(height: 14),
          _field(controller: _authorCtrl, label: 'Penulis', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'Penulis wajib diisi' : null),
          const SizedBox(height: 14),
          _field(controller: _genreCtrl, label: 'Genre', icon: Icons.category_outlined, hint: 'Contoh: Fantasy, Action, Romance', validator: (v) => (v == null || v.isEmpty) ? 'Genre wajib diisi' : null),
          const SizedBox(height: 14),
          _field(controller: _chaptersCtrl, label: 'Jumlah Chapter', icon: Icons.menu_book_outlined, keyboard: TextInputType.number,
            validator: (v) { if (v == null || v.isEmpty) return null; final n = int.tryParse(v); if (n == null || n < 0) return 'Masukkan angka yang valid'; return null; }),
          const SizedBox(height: 14),
          _field(controller: _ratingCtrl, label: 'Rating (0.0 - 10.0)', icon: Icons.star_outline, keyboard: const TextInputType.numberWithOptions(decimal: true), hint: 'Contoh: 9.5',
            validator: (v) { if (v == null || v.isEmpty) return null; final n = double.tryParse(v); if (n == null || n < 0 || n > 10) return 'Rating harus antara 0 dan 10'; return null; }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(widget.isEdit ? Icons.save_outlined : Icons.add, color: Colors.white),
              label: Text(widget.isEdit ? 'Simpan Perubahan' : 'Tambahkan Novel', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ]))),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String label, required IconData icon,
      String? hint, TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller, keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, hintText: hint, labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Color(0xFF484F58), fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true, fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }
}
