import 'package:dio/dio.dart';
import 'package:general_app/core/api/api_consumer.dart';
import 'package:general_app/core/const/server_string.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    required String password,
    String? imagePath,
    String? setupToken,
  });

  Future<void> logout();

  Future<void> sendOtp({required String email});

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  });

  Future<UserModel> getMe();

  Future<UserModel> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    String? password,
    String? imagePath,
  });
  Future<void> updateFcmToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      ServerStrings.userLogin,
      body: {'email': email, 'password': password},
    );
    return UserModel.fromLoginResponse(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    required String password,
    String? imagePath,
    String? setupToken,
  }) async {
    final body = <String, dynamic>{
      'name': fullName,
      'email': email,
      'phone': phoneNumber,
      'national_id': nationalId,
      'password': password,
      'password_confirmation': password,
      if (setupToken != null) 'setup_token': setupToken,
    };

    final response = await apiConsumer.post(
      ServerStrings.userRegister,
      body: body,
    );
    return UserModel.fromLoginResponse(response as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await apiConsumer.post(ServerStrings.logout);
  }

  @override
  Future<void> sendOtp({required String email}) async {
    await apiConsumer.post(ServerStrings.sendOtp, body: {'email': email});
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await apiConsumer.post(
      ServerStrings.verifyOtp,
      body: {'email': email, 'otp': otp},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    await apiConsumer.post(
      ServerStrings.resetPassword,
      body: {
        'email': email,
        'otp': int.tryParse(otp) ?? otp,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  @override
  Future<UserModel> getMe() async {
    final response =
        await apiConsumer.get(ServerStrings.me) as Map<String, dynamic>;
    final user = response['data']['user'] as Map<String, dynamic>;
    return UserModel.fromJson(user);
  }

  @override
  Future<UserModel> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    String? password,
    String? imagePath,
  }) async {
    final formMap = <String, dynamic>{
      if (fullName.isNotEmpty) 'name': fullName,
      if (email.isNotEmpty) 'email': email,
      if (phoneNumber.isNotEmpty) 'phone': phoneNumber,
      if (password != null && password.isNotEmpty) 'password': password,
      if (password != null && password.isNotEmpty)
        'password_confirmation': password,
    };

    if (imagePath != null) {
      final fileName = imagePath.split('/').last;
      formMap['image'] = await MultipartFile.fromFile(
        imagePath,
        filename: fileName,
      );
    }

    final response = await apiConsumer.post(
      ServerStrings.updateProfile,
      body: FormData.fromMap(formMap),
    );

    final data =
        (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final userJson = data['user'] as Map<String, dynamic>;

    if (!userJson.containsKey('national_id') ||
        userJson['national_id'] == null) {
      userJson['national_id'] = nationalId;
    }

    return UserModel.fromJson(userJson);
  }
  @override
  Future<void> updateFcmToken(String token) async {
    await apiConsumer.post(
      ServerStrings.updateFcmToken,
      body: {'fcm_token': token},
    );
  }
}
