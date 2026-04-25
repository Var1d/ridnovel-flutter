// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import '../models/novel_model.dart';
import '../services/api_service.dart';

enum NovelState { idle, loading, loaded, error }

class NovelProvider extends ChangeNotifier {
  NovelState _state = NovelState.idle;
  List<Novel> _novels = [];
  List<Novel> _filtered = [];
  String? _errorMessage;
  String _searchQuery = '';

  NovelState get state => _state;
  List<Novel> get novels => _filtered;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchNovels(String token) async {
    _state = NovelState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _novels = await ApiService.getNovels(token);
      _applySearch();
      _state = NovelState.loaded;
      notifyListeners();
    } catch (e) {
      _state = NovelState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<bool> createNovel(String token, Map<String, dynamic> data) async {
    try {
      final novel = await ApiService.createNovel(token, data);
      _novels.insert(0, novel);
      _applySearch();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateNovel(String token, int id, Map<String, dynamic> data) async {
    try {
      final updated = await ApiService.updateNovel(token, id, data);
      final index = _novels.indexWhere((n) => n.id == id);
      if (index != -1) _novels[index] = updated;
      _applySearch();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNovel(String token, int id) async {
    try {
      await ApiService.deleteNovel(token, id);
      _novels.removeWhere((n) => n.id == id);
      _applySearch();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_novels);
    } else {
      final q = _searchQuery.toLowerCase();
      _filtered = _novels.where((n) =>
        n.title.toLowerCase().contains(q) ||
        n.author.toLowerCase().contains(q) ||
        n.genre.toLowerCase().contains(q)
      ).toList();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applySearch();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
