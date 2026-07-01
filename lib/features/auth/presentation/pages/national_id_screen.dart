import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/features/auth/domain/usecases/national_id_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:general_app/core/di/injection_container.dart' as di;
import '../widgets/bracket_painter.dart';

class NationalIdScanScreen extends StatefulWidget {
  const NationalIdScanScreen({super.key});

  @override
  State<NationalIdScanScreen> createState() => _NationalIdScanScreenState();
}

class _NationalIdScanScreenState extends State<NationalIdScanScreen>
    with TickerProviderStateMixin {
  File? _idImage;
  bool _isScanning = false;
  bool _scanSuccess = false;
  String? _scanError;
  String? _setupToken;

  final _nationalIdController = TextEditingController();
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;

  final ImagePicker _picker = ImagePicker();
  final ExtractNationalIdUseCase _extractUseCase =
      di.sl<ExtractNationalIdUseCase>();

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.05, end: 0.9).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    final status = await permission.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      if (!mounted) return;
      if (status.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: const Text('Permission Required'),
                content: Text(
                  source == ImageSource.camera
                      ? 'Camera access is required. Please enable it in Settings.'
                      : 'Gallery access is required. Please enable it in Settings.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      openAppSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? 'Camera permission denied'
                  : 'Gallery permission denied',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
      return;
    }

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );
    if (picked == null) return;

    setState(() {
      _idImage = File(picked.path);
      _scanError = null;
      _scanSuccess = false;
    });

    await _extractId();
  }

  Future<void> _extractId() async {
    if (_idImage == null) return;
    setState(() => _isScanning = true);

    try {
      final result = await _extractUseCase(
        ExtractNationalIdParams(imagePath: _idImage!.path),
      );
      if (!mounted) return;
      setState(() {
        _nationalIdController.text = result['national_id'] ?? '';
        _setupToken = result['setup_token'];
        _isScanning = false;
        _scanSuccess = true;
        _scanError = null;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanSuccess = false;
        _scanError = e.toString().replaceAll('Exception: ', '');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanSuccess = false;
        _scanError = 'Something went wrong. Please try again.';
      });
    }
  }

  void _goToRegister() {
    if (_nationalIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please scan your ID first'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.register,
      arguments: {
        'national_id': _nationalIdController.text,
        'setup_token': _setupToken ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Identity Verification',
          style: AppTypography.h4.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 8.h),

            Text(
              'Scan National ID',
              style: AppTypography.h3.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Align your National ID within the frame.\nEnsure the lighting is clear.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            _buildScannerFrame(isDark),

            SizedBox(height: 24.h),

            if (_scanSuccess) ...[
              _buildNationalIdField(theme, isDark),
              SizedBox(height: 20.h),
            ],

            if (_scanError != null) ...[
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _scanError!,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 13.sp,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:
                      _isScanning ? null : () => _pickImage(ImageSource.camera),
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      color:
                          _isScanning
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child:
                        _isScanning
                            ? Padding(
                              padding: EdgeInsets.all(18.w),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                            : Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                  ),
                ),

                SizedBox(width: 32.w),

                GestureDetector(
                  onTap:
                      _isScanning
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                  child: Column(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.surfaceDark
                                  : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.borderDark
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 22.sp,
                          color:
                              _isScanning ? Colors.grey : theme.iconTheme.color,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'GALLERY',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Text(
              'Capture will happen automatically when\nthe ID is stable and in focus.',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 12.sp,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 28.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isScanning ? null : _goToRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: AppTypography.button.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerFrame(bool isDark) {
    return Container(
      height: 210.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            if (_idImage != null)
              Positioned.fill(child: Image.file(_idImage!, fit: BoxFit.cover))
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.credit_card_outlined,
                      size: 52.sp,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Place your ID here',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),

            if (_idImage != null)
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),

            ..._buildCornerBrackets(),

            if (_isScanning)
              AnimatedBuilder(
                animation: _scanLineAnimation,
                builder:
                    (context, _) => Positioned(
                      top: _scanLineAnimation.value * 210.h,
                      left: 16.w,
                      right: 16.w,
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary,
                              AppColors.primary,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
              ),

            if (_isScanning || _scanSuccess)
              Positioned(
                top: 14.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _isScanning ? AppColors.primary : AppColors.success,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isScanning)
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        SizedBox(width: 6.w),
                        Text(
                          _isScanning ? 'SCANNING...' : 'ID EXTRACTED',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const color = AppColors.primary;
    const t = 3.0;
    const l = 22.0;
    return [
      Positioned(top: 12, left: 12, child: _bracket(color, t, l, true, true)),
      Positioned(top: 12, right: 12, child: _bracket(color, t, l, true, false)),
      Positioned(
        bottom: 12,
        left: 12,
        child: _bracket(color, t, l, false, true),
      ),
      Positioned(
        bottom: 12,
        right: 12,
        child: _bracket(color, t, l, false, false),
      ),
    ];
  }

  Widget _bracket(Color c, double t, double l, bool top, bool left) {
    return SizedBox(
      width: l,
      height: l,
      child: CustomPaint(
        painter: BracketPainter(color: c, thickness: t, top: top, left: left),
      ),
    );
  }

  Widget _buildNationalIdField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.badge_outlined, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 6.w),
            Text(
              'National ID Number',
              style: AppTypography.labelLarge.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Auto-filled',
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _nationalIdController,
          readOnly: true,
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: theme.textTheme.titleMedium?.color,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isDark
                    ? AppColors.surfaceDark
                    : AppColors.primary.withOpacity(0.05),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            suffixIcon: Icon(
              Icons.lock_outline,
              size: 18.sp,
              color: theme.iconTheme.color?.withOpacity(0.4),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
