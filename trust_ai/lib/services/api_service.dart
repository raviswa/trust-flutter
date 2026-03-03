// lib/services/api_service.dart
//
// Direct Dart equivalent of trustai-app/services/api.js
// Same base URL, same endpoints, same Bearer token pattern.
//
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ─── Change _kDev to false before production deployment ──────────────────────
const bool _kDev       = false;
const _devUrl  = 'http://localhost:5000/api';
const _prodUrl = 'https://YOUR_PRODUCTION_URL/api';

class ApiService {
  ApiService._();
  static final ApiService i = ApiService._();

  // HIPAA-grade: iOS Keychain / Android Keystore
  final _store = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  late final _dio = Dio(BaseOptions(
    baseUrl: _kDev ? _devUrl : _prodUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (opts, handler) async {
        // Auto-attach JWT Bearer token — mirrors the Axios interceptor
        final token = await _store.read(key: 'jwt');
        if (token != null) {
          opts.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(opts);
      },
      onError: (e, handler) => handler.next(e),
    ));

  // ── Token management ─────────────────────────────────────────────────────
  Future<void>    saveToken(String t) => _store.write(key: 'jwt', value: t);
  Future<String?> getToken()          => _store.read(key: 'jwt');
  Future<void>    deleteToken()       => _store.delete(key: 'jwt');

  // ── POST /api/auth/register ──────────────────────────────────────────────
  Future<Response> register(Map<String, dynamic> body) =>
      _dio.post('/auth/register', data: body);

  // ── POST /api/auth/login ─────────────────────────────────────────────────
  Future<Response> login(Map<String, dynamic> body) =>
      _dio.post('/auth/login', data: body);

  // ── POST /api/intake/feelings ────────────────────────────────────────────
  Future<Response> submitFeelings(List<String> feelings) =>
      _dio.post('/intake/feelings', data: {'heavyFeelings': feelings});

  // ── POST /api/intake/addiction ───────────────────────────────────────────
  Future<Response> submitAddiction(List<String> types) =>
      _dio.post('/intake/addiction', data: {'primaryAddictionType': types});

  // ── POST /api/intake/support ─────────────────────────────────────────────
  Future<Response> submitSupport(List<String> network) =>
      _dio.post('/intake/support', data: {'supportNetwork': network});

  // ── POST /api/intake/consent ─────────────────────────────────────────────
  Future<Response> submitConsent() =>
      _dio.post('/intake/consent', data: {'consentGiven': true});

  // ── GET /api/intake/me ───────────────────────────────────────────────────
  Future<Response> getIntake() => _dio.get('/intake/me');

  // ── Helper: parse error message from Dio exception ───────────────────────
  static String parseError(Object e) {
    if (e is DioException) {
      final msg = e.response?.data?['message'];
      if (msg is String && msg.isNotEmpty) return msg;
      return e.message ?? 'Network error. Please try again.';
    }
    return 'An unexpected error occurred.';
  }
}
