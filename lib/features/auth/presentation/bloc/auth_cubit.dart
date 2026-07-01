import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/errors/exceptions.dart';
import 'package:general_app/core/usecase/usecase.dart';
import 'package:general_app/features/auth/data/models/user_model.dart';
import 'package:general_app/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:general_app/features/auth/domain/usecases/reset_usecase.dart';
import 'package:general_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/update_profile_usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.updateProfileUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      emit(AuthLoading());
      final user = await getCurrentUserUseCase(const NoParams());
      if (user != null && user.isNotEmpty) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user = await loginUseCase(
        LoginParams(email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on UnauthorizedException catch (e) {
      emit(AuthError(e.message));
    } on ValidationException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    required String password,
    String? imagePath,
    String? setupToken,
  }) async {
    try {
      emit(AuthLoading());
      final user = await registerUseCase(
        RegisterParams(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          nationalId: nationalId,
          password: password,
          imagePath: imagePath,
          setupToken: setupToken,
        ),
      );
      emit(AuthRegistrationSuccess(user));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on ValidationException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());
      await forgotPasswordUseCase(ForgotPasswordParams(email: email));
      emit(AuthForgotPasswordSent(email));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp({required String otp, required String email}) async {
    try {
      emit(AuthLoading());
      await verifyOtpUseCase(VerifyOtpParams(email: email, otp: otp));
      emit(AuthOtpVerified(token: otp, email: email));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      emit(AuthLoading());
      await forgotPasswordUseCase(ForgotPasswordParams(email: email));
      emit(AuthOtpResent(email));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      emit(AuthLoading());
      await resetPasswordUseCase(
        ResetPasswordParams(email: email, otp: otp, newPassword: newPassword),
      );
      emit(AuthPasswordResetSuccess());
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on ValidationException catch (e) {
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String nationalId,
    String? password,
    String? imagePath,
  }) async {
    final currentUser = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user
        : null;
    final currentToken = currentUser?.token;

    if (currentUser != null) {
      emit(AuthUpdatingProfile(currentUser));
    }

    try {
      final user = await updateProfileUseCase(
        UpdateProfileParams(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          nationalId: nationalId,
          password: password,
          imagePath: imagePath,
        ),
      );

      final userModel = user is UserModel
          ? user
          : UserModel.fromEntity(user);

      final updatedUser = userModel.copyWith(token: currentToken);

      emit(AuthAuthenticated(updatedUser));
    } on NetworkException catch (e) {
      if (currentUser != null) emit(AuthAuthenticated(currentUser));
      emit(AuthError(e.message));
    } on ValidationException catch (e) {
      if (currentUser != null) emit(AuthAuthenticated(currentUser));
      emit(AuthError(e.message));
    } on ServerException catch (e) {
      if (currentUser != null) emit(AuthAuthenticated(currentUser));
      emit(AuthError(e.message));
    } catch (e) {
      if (currentUser != null) emit(AuthAuthenticated(currentUser));
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase(const NoParams());
    } catch (_) {}
    emit(AuthUnauthenticated());
  }

  void clearError() => emit(AuthInitial());
}
