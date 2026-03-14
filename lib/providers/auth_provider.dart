import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final response = await _authService.login(email, password);
    _isLoading = false;
    if (response != null) _userData = response['user'];
    notifyListeners();
    return response != null;
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();
    final response = await _authService.register(name, email, password, role);
    _isLoading = false;
    if (response != null) _userData = response['user'];
    notifyListeners();
    return response != null;
  }
}
