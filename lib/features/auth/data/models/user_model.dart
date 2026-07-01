import '../../domain/entities/user.dart';


class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.nationalId,
    super.profileImage,
    super.token,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',          
      fullName: json['name']?.toString() ?? '',   
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      profileImage: json['image']?.toString(),    
      token: json['token']?.toString(),           
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  factory UserModel.fromLoginResponse(Map<String, dynamic> response) {

  
  final data = response['data'] as Map<String, dynamic>;
  final user = data['user'] as Map<String, dynamic>;
  

  
  return UserModel(
    id: user['id']?.toString() ?? '',
    fullName: user['name']?.toString() ?? '',
    email: user['email']?.toString() ?? '',
    phoneNumber: user['phone']?.toString(),
    nationalId: user['national_id']?.toString(),
    profileImage: user['image']?.toString(),
    token: data['token']?.toString(),
    createdAt: user['created_at'] != null
        ? DateTime.tryParse(user['created_at'].toString())
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': fullName,
      'email': email,
      'phone': phoneNumber,
      'national_id': nationalId,
      'image': profileImage,
      'token': token,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      nationalId: user.nationalId,
      profileImage: user.profileImage,
      token: user.token,
      createdAt: user.createdAt,
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? nationalId,
    String? profileImage,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalId: nationalId ?? this.nationalId,
      profileImage: profileImage ?? this.profileImage,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
