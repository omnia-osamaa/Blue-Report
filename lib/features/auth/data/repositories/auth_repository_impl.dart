import 'package:general_app/core/errors/exceptions.dart';
import 'package:general_app/core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<User> login({required String email, required String password}) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    final user = await remoteDataSource.login(email: email, password: password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    required String password,
    String? imagePath,
    String? setupToken,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    final user = await remoteDataSource.register(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      nationalId: nationalId,
      password: password,
      imagePath: imagePath,
      setupToken: setupToken,
    );
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      if (await networkInfo.isConnected) await remoteDataSource.logout();
    } finally {
      await localDataSource.clearCache();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isLoggedIn();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> sendOtp({required String email}) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    await remoteDataSource.sendOtp(email: email);
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    await remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    await remoteDataSource.resetPassword(email: email, otp: otp, password: password);
  }

  @override
  Future<User> getMe() async {
    if (!await networkInfo.isConnected) throw NetworkException();
    final user = await remoteDataSource.getMe();
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<User> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    String? password,
    String? imagePath,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();
    final user = await remoteDataSource.updateProfile(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      nationalId: nationalId,
      password: password,
      imagePath: imagePath,
    );
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> updateFcmToken(String token) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateFcmToken(token);
    }
  }
}
