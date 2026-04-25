// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/novel_provider.dart';
import '../widgets/novel_card.dart';
import 'novel_detail_screen.dart';
import 'novel_form_screen.dart';
import 'login_screen.dart';

class NovelListScreen extends StatefulWidget {
  const NovelListScreen({super.key});
  @override
  State<NovelListScreen> createState() => _NovelListScreenState();
}

class _NovelListScreenState extends State<NovelListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  void _load() {
    final token = context.read<AuthProvider>().token;
    if (token != null) context.read<NovelProvider>().fetchNovels(token);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF161B22),
      title: const Text('Logout', style: TextStyle(color: Colors.white)),
      content: const Text('Yakin ingin keluar?', style: TextStyle(color: Colors.grey)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Keluar', style: TextStyle(color: Colors.redAccent))),
      ],
    ));
    if (confirm == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22), elevation: 0,
        title: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18)),
          const SizedBox(width: 10),
          const Text('RidNovel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ]),
        actions: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Center(child: Text(auth.user?.username ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)))),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: _logout, tooltip: 'Logout'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final r = await Navigator.push(context, MaterialPageRoute(builder: (_) => const NovelFormScreen(isEdit: false)));
          if (r == true && mounted) _load();
        },
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Novel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(color: Colors.white),
            onChanged: (q) {
              setState(() {});
              context.read<NovelProvider>().search(q);
            },
            decoration: InputDecoration(
              hintText: 'Cari judul, penulis, atau genre...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () { _searchCtrl.clear(); setState(() {}); context.read<NovelProvider>().clearSearch(); })
                : null,
              filled: true, fillColor: const Color(0xFF161B22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(child: _buildBody()),
      ]),
    );
  }

  Widget _buildBody() {
    return Consumer<NovelProvider>(builder: (context, provider, _) {
      // STATE: LOADING
      if (provider.state == NovelState.loading) {
        return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: Color(0xFF7C3AED)),
          SizedBox(height: 16),
          Text('Memuat novel...', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ]));
      }

      // STATE: ERROR
      if (provider.state == NovelState.error) {
        return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 56),
          const SizedBox(height: 16),
          const Text('Gagal memuat data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(provider.errorMessage ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ])));
      }

      // STATE: LOADED
      final novels = provider.novels;
      if (novels.isEmpty) {
        return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.library_books_outlined, color: Colors.grey, size: 56),
          const SizedBox(height: 16),
          Text(provider.searchQuery.isNotEmpty ? 'Tidak ada hasil untuk "${provider.searchQuery}"' : 'Belum ada novel. Tambahkan yang pertama!',
            style: const TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
        ]));
      }

      return RefreshIndicator(
        color: const Color(0xFF7C3AED), backgroundColor: const Color(0xFF161B22),
        onRefresh: () async => _load(),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          itemCount: novels.length,
          itemBuilder: (context, index) => AnimatedNovelCard(
            novel: novels[index], index: index,
            onTap: () async {
              final r = await Navigator.push(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => NovelDetailScreen(novel: novels[index]),
                transitionsBuilder: (_, anim, __, child) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child),
              ));
              if (r == true && mounted) _load();
            },
          ),
        ),
      );
    });
  }
}
