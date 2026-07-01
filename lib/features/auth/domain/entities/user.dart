import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? nationalId;
  final String? profileImage;
  final String? token;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.nationalId,
    this.profileImage,
    this.token,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        nationalId,
        profileImage,
        token,
        createdAt,
      ];

  factory User.empty() {
    return const User(
      id: '',
      fullName: '',
      email: '',
    );
  }

  bool get isEmpty => id.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

