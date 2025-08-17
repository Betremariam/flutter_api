import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      _user = User.fromJson(response);
      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _user!.token);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.register(name, email, password);
      _user = User.fromJson(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _user!.token);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  // Load user from saved token (optional auto-login)
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _user = User(id: '', name: '', email: '', token: token);
      notifyListeners();
    }
  }
}
