part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUpdatingProfile extends AuthState {
  final User user;
  const AuthUpdatingProfile(this.user);
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthRegistrationSuccess extends AuthState {
  final User user;
  const AuthRegistrationSuccess(this.user);
}

class AuthForgotPasswordSent extends AuthState {
  final String email;
  const AuthForgotPasswordSent(this.email);
}

class AuthOtpVerified extends AuthState {
  final String token;
  final String email;
  const AuthOtpVerified({required this.token, required this.email});
}

class AuthOtpResent extends AuthState {
  final String email;
  const AuthOtpResent(this.email);
}

class AuthPasswordResetSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
