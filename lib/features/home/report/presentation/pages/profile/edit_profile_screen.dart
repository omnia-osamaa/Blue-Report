

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:general_app/core/utils/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:general_app/core/config/app_config.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _fullNameController.text = authState.user.fullName;
      _emailController.text = authState.user.email;
      _phoneController.text = authState.user.phoneNumber ?? '';
      _nationalIdController.text = authState.user.nationalId ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _profileImage = File(image.path));
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Image Source',
                  style: AppTypography.h4.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: AppColors.error),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _profileImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().updateProfile(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          imagePath: _profileImage?.path,
        );
  }

  
  User? _getUserFromState(AuthState state) {
    if (state is AuthAuthenticated) return state.user;
    if (state is AuthUpdatingProfile) return state.user;
    return null;
  }

  String? _buildImageUrl(String? userImageUrl) {
    if (userImageUrl == null || userImageUrl.isEmpty) return null;
    if (userImageUrl.startsWith('http')) return userImageUrl;
    return '${AppConfig.baseUrl}${userImageUrl.startsWith('/') ? '' : '/'}${userImageUrl.contains('storage') ? '' : 'storage/'}$userImageUrl';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated || current is AuthError,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _showSuccessSnackBar('Profile updated successfully!');
          Navigator.pop(context);
        } else if (state is AuthError) {
          _showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        
        final isLoading = state is AuthUpdatingProfile;

        
        final user = _getUserFromState(state);
        final fullImageUrl = _buildImageUrl(user?.profileImage);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: theme.iconTheme.color, size: 20.sp),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
            title: Text(
              'Edit Profile',
              style: AppTypography.h4.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  
                  Stack(
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _profileImage == null && fullImageUrl == null
                              ? LinearGradient(colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.8),
                                  theme.colorScheme.primary,
                                ])
                              : null,
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : fullImageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(fullImageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                        child: _profileImage == null && fullImageUrl == null
                            ? Icon(Icons.person, size: 60.sp, color: Colors.white)
                            : null,
                      ),
                      
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: isLoading ? null : _showImageSourceDialog,
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: theme.scaffoldBackgroundColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.camera_alt,
                                size: 20.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  
                  AuthTextField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: (value) => null,
                    readOnly: isLoading,
                  ),
                  SizedBox(height: 16.h),

                  
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.isNotEmpty
                        ? Validators.email(value)
                        : null,
                    readOnly: isLoading,
                  ),
                  SizedBox(height: 16.h),

                  
                  AuthTextField(
                    controller: _phoneController,
                    hintText: 'Phone Number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value != null && value.isNotEmpty
                        ? Validators.phone(value)
                        : null,
                    readOnly: isLoading,
                  ),
                  SizedBox(height: 24.h),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text('Save Changes',
                              style: AppTypography.button.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: OutlinedButton(
                      onPressed:
                          isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.textTheme.bodyMedium?.color,
                        side: BorderSide(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: Text('Cancel',
                          style: AppTypography.button.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ));
  }
}
