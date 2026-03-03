// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final bool onboardingComplete;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.onboardingComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] as String? ?? '',
        name: j['name'] as String? ?? '',
        email: j['email'] as String? ?? '',
        onboardingComplete: j['onboardingComplete'] as bool? ?? false,
      );
}
