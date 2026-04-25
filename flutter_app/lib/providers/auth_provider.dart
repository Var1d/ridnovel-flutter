// Farid Dhiya Fairuz - 247006111058 - B

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum AuthState { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.idle;
  User? _user;
  String? _errorMessage;

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  String? get token => _user?.token;

  Future<void> checkStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final id = prefs.getInt('user_id');
    if (token != null && username != null && email != null && id != null) {
      _user = User(id: id, username: username, email: email, token: token);
      _state = AuthState.authenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await ApiService.login(email, password);
      _user = user;
      _state = AuthState.authenticated;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      await prefs.setInt('user_id', user.id);
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await ApiService.register(username, email, password);
      _state = AuthState.idle;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _state = AuthState.idle;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _state = AuthState.idle;
    notifyListeners();
  }
}
