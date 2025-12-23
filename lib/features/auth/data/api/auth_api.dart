// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:injectable/injectable.dart';
// import 'package:shopping_nti/core/constants/api_constants.dart';
// import 'package:shopping_nti/core/network/result_api.dart';
// import 'package:shopping_nti/features/auth/data/models/login_request_dto.dart';
// import 'package:shopping_nti/features/auth/data/models/login_response_dto.dart';
// import 'package:shopping_nti/features/auth/data/models/register_request_dto.dart';
// import 'package:shopping_nti/features/auth/data/models/register_response_dto.dart';

// @singleton
// class AuthApi {
//   Future<ResultApi<LoginResponseDto>> login(
//     LoginRequestDto loginRequestDto,
//   ) async {
//     final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.login);

//     try {
//       final response = await http.post(uri, body: loginRequestDto.toJson());
//       if (response.statusCode == 201) {
//         final json = jsonDecode(response.body);
//         final loginResponseDto = LoginResponseDto.fromJson(json);
//         log('Login Response: $json');
//         return SuccessApi<LoginResponseDto>(data: loginResponseDto);
//       } else {
//         return ErrorApi<LoginResponseDto>(
//           'Login failed with status: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       return ErrorApi<LoginResponseDto>('An error occurred: $e');
//     }
//   }

//   Future<ResultApi<RegisterResponseDto>> register(
//     RegisterRequestDto registerRequestDto,
//   ) async {
//     final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.register);

//     try {
//       final response = await http.post(uri, body: registerRequestDto.toJson());
//       final json = jsonDecode(response.body);
//       final registerResponseDto = RegisterResponseDto.fromJson(json);
//       return SuccessApi<RegisterResponseDto>(data: registerResponseDto);
//     } catch (e) {
//       return ErrorApi<RegisterResponseDto>('An error occurred: $e');
//     }
//   }
// }