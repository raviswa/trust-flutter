// lib/services/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool       _loading = false;
  String?    _error;

  UserModel? get user      => _user;
  bool       get loading   => _loading;
  String?    get error     => _error;
  bool       get loggedIn  => _user != null;

  void clearError() { _error = null; notifyListeners(); }

  void _set({bool? loading, String? error, UserModel? user, bool clear = false}) {
    if (loading != null) _loading = loading;
    if (clear)           _error   = null;
    if (error != null)   _error   = error;
    if (user  != null)   _user    = user;
    notifyListeners();
  }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<bool> register(Map<String, dynamic> data) async {
    _set(loading: true, clear: true);
    try {
      final res = await ApiService.i.register(data);
      final token = res.data['token'] as String?;
      if (token != null) {
        await ApiService.i.saveToken(token);
        _set(loading: false, user: UserModel.fromJson(res.data['user']));
        return true;
      }
      _set(loading: false, error: 'Registration failed. Please try again.');
      return false;
    } catch (e) {
      _set(loading: false, error: ApiService.parseError(e));
      return false;
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<bool> login(Map<String, dynamic> data) async {
    _set(loading: true, clear: true);
    try {
      final res = await ApiService.i.login(data);
      final token = res.data['token'] as String?;
      if (token != null) {
        await ApiService.i.saveToken(token);
        _set(loading: false, user: UserModel.fromJson(res.data['user']));
        return true;
      }
      _set(loading: false, error: 'Login failed. Please try again.');
      return false;
    } catch (e) {
      _set(loading: false, error: ApiService.parseError(e));
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await ApiService.i.deleteToken();
    _user = null;
    notifyListeners();
  }
}
