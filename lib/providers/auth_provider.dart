import 'package:flutter/material.dart';
import 'package:habit_tracker/services/api_dio.dart';

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
      final registerResponse = await ApiClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (registerResponse.statusCode == 201) {
        final loginResponse = await ApiClient.dio.post('/auth/login', data: {
          'email': email,
          'password': password,
        });

        if (loginResponse.statusCode == 200) {
          _token = 'cookie-authenticated';
          _error = null;
        } else {
          _error = loginResponse.data['error'];
        }
      } else {
        _error = registerResponse.data['error'];
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
      final response = await ApiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        _token = 'cookie-authenticated';
        _error = null;
      } else {
        _error = response.data['error'];
      }
    } catch (e) {
      _error = 'Connection failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    try {
      await ApiClient.dio.post('/auth/logout');
    } catch (e) {}
    _token = null;
    notifyListeners();
  }
}
