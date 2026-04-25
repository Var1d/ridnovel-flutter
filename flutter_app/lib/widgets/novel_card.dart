// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import '../models/novel_model.dart';

class AnimatedNovelCard extends StatefulWidget {
  final Novel novel;
  final int index;
  final VoidCallback onTap;
  const AnimatedNovelCard({super.key, required this.novel, required this.index, required this.onTap});
  @override
  State<AnimatedNovelCard> createState() => _AnimatedNovelCardState();
}

class _AnimatedNovelCardState extends State<AnimatedNovelCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.index * 60), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

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

  @override
  Widget build(BuildContext context) {
    final color = _genreColor(widget.novel.genre);
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF30363D), width: 1)),
            child: Row(children: [
              Container(width: 4, height: 90, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)))),
              Container(width: 56, height: 56, margin: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.auto_stories_rounded, color: color, size: 26)),
              Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.novel.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(widget.novel.author, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                    child: Text(widget.novel.genre.split('/').first.trim(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                  const SizedBox(width: 2),
                  Text(widget.novel.rating.toStringAsFixed(1), style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
              ]))),
              Padding(padding: const EdgeInsets.only(right: 14), child: Column(children: [
                Text('${widget.novel.chapters}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('ch', style: TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
              ])),
            ]),
          ),
        ),
      ),
    );
  }
}
