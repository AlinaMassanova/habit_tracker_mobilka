import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> register(String name, String email, String password) async {
  _isLoading = true;
  notifyListeners();

  try {
    final registerResponse = await ApiService.register(name, email, password);
    
    if (registerResponse.statusCode == 201) {
      final loginResponse = await ApiService.login(email, password);
      
      if (loginResponse.statusCode == 200) {
        _token = _extractToken(loginResponse.headers['set-cookie']);
        _error = null;
      } else {
        _error = jsonDecode(loginResponse.body)['error'];
      }
    } else {
      _error = jsonDecode(registerResponse.body)['error'];
    }
  } catch (e) {
    _error = 'Connection failed';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      if (response.statusCode == 200) {
        _token = _extractToken(response.headers['set-cookie']);
        _error = null;
      } else {
        _error = jsonDecode(response.body)['error'];
      }
    } catch (e) {
      _error = 'Connection failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _extractToken(String? cookieHeader) {
    if (cookieHeader == null) return null;
    final regExp = RegExp(r'authToken=([^;]+)');
    final match = regExp.firstMatch(cookieHeader);
    return match?.group(1);
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}