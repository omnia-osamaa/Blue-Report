import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    required String password,
    String? imagePath,
    String? setupToken,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<void> sendOtp({required String email});

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  });

  Future<User> getMe();

  Future<User> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    String? password,
    String? imagePath,
  });

  Future<void> updateFcmToken(String token);
}
