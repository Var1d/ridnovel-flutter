// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/novel_model.dart';
import '../providers/auth_provider.dart';
import '../providers/novel_provider.dart';
import 'novel_form_screen.dart';

class NovelDetailScreen extends StatelessWidget {
  final Novel novel;
  const NovelDetailScreen({super.key, required this.novel});

  Color _genreColor(String genre) {
    final g = genre.toLowerCase();
    if (g.contains('fantasy')) return const Color(0xFF7C3AED);
    if (g.contains('action')) return const Color(0xFFEF4444);
    if (g.contains('romance')) return const Color(0xFFEC4899);
    if (g.contains('dark')) return const Color(0xFF6B7280);
    if (g.contains('adventure')) return const Color(0xFF10B981);
    if (g.contains('isekai')) return const Color(0xFF3B82F6);
    return const Color(0xFF7C3AED);
  }

  String _formatDate(String raw) {
    try { final dt = DateTime.parse(raw); return '${dt.day}/${dt.month}/${dt.year}'; } catch (_) { return raw; }
  }

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF161B22),
      title: const Text('Hapus Novel', style: TextStyle(color: Colors.white)),
      content: Text('Yakin ingin menghapus "${novel.title}"?', style: const TextStyle(color: Colors.grey)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.redAccent))),
      ],
    ));
    if (confirm == true && context.mounted) {
      final token = context.read<AuthProvider>().token!;
      final success = await context.read<NovelProvider>().deleteNovel(token, novel.id);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Novel berhasil dihapus'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _genreColor(novel.genre);
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true, backgroundColor: const Color(0xFF161B22),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.white), tooltip: 'Edit',
              onPressed: () async {
                final r = await Navigator.push(context, MaterialPageRoute(builder: (_) => NovelFormScreen(isEdit: true, novel: novel)));
                if (r == true && context.mounted) Navigator.pop(context, true);
              }),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), tooltip: 'Hapus', onPressed: () => _delete(context)),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withOpacity(0.5), const Color(0xFF161B22)])),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 40),
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.4), width: 1.5)),
                  child: Icon(Icons.auto_stories_rounded, color: color, size: 36),
                ),
              ])),
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(novel.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [const Icon(Icons.person_outline, color: Colors.grey, size: 16), const SizedBox(width: 6), Text(novel.author, style: const TextStyle(color: Colors.grey, fontSize: 14))]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4), width: 1)),
            child: Text(novel.genre, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 28),
          Row(children: [
            Expanded(child: _statCard(icon: Icons.menu_book_outlined, label: 'Chapters', value: novel.chapters.toString(), color: const Color(0xFF7C3AED))),
            const SizedBox(width: 12),
            Expanded(child: _statCard(icon: Icons.star_rounded, label: 'Rating', value: novel.rating.toStringAsFixed(1), color: const Color(0xFFF59E0B))),
          ]),
          const SizedBox(height: 28),
          const Divider(color: Color(0xFF30363D)),
          const SizedBox(height: 16),
          const Text('Rating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (novel.rating / 10).clamp(0.0, 1.0), minHeight: 10, backgroundColor: const Color(0xFF30363D), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)))),
          const SizedBox(height: 4),
          Text('${novel.rating.toStringAsFixed(1)} / 10', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (novel.createdAt != null) ...[
            const SizedBox(height: 20),
            const Divider(color: Color(0xFF30363D)),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 14), const SizedBox(width: 6), Text('Ditambahkan: ${_formatDate(novel.createdAt!)}', style: const TextStyle(color: Colors.grey, fontSize: 12))]),
          ],
          const SizedBox(height: 40),
        ]))),
      ]),
    );
  }

  Widget _statCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        Icon(icon, color: color, size: 24), const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
    );
  }
}
