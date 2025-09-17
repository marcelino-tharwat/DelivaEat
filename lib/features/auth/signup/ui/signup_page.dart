import 'dart:developer';
import 'dart:io';
import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/basic_info_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/merchant_field_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/rider_filed_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/role_selector_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/signup_button_link.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/signup_header.dart';
import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/core/network/api_client.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deliveryRadiusController = TextEditingController();

  String _selectedRoleKey = 'user'; // canonical key: user|rider|merchant
  String? _selectedVehicleType; // localized label
  String? _selectedBusinessType; // localized label
  
  File? _profileImage;
  File? _idCardImage;
  File? _licenseImage;
  File? _vehicleImage1;
  File? _vehicleImage2;
  File? _licensePlateImage;

  final ImagePicker _picker = ImagePicker();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      _selectedVehicleType ??= l10n.vehicle_motorcycle; // default
      _selectedBusinessType ??= l10n.business_type_restaurant; // default
      _initialized = true;
    }
  }

  Future<void> _pickImage(void Function(File) setImageCallback) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        setImageCallback(File(image.path));
      });
    }
  }

  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final api = ApiClient.create();
      Map<String, dynamic> res;

      if (_selectedRoleKey == 'rider') {
        // Upload images if available
        String? avatarUrl;
        String? idCardUrl;
        String? licenseUrl;
        String? vehicleUrlFront;
        String? vehicleUrlSide;
        String? licensePlateUrl;

        if (_profileImage != null) {
          avatarUrl = await api.uploadImage(filePath: _profileImage!.path);
        }
        if (_idCardImage != null) {
          idCardUrl = await api.uploadImage(filePath: _idCardImage!.path);
        }
        if (_licenseImage != null) {
          licenseUrl = await api.uploadImage(filePath: _licenseImage!.path);
        }
        if (_vehicleImage1 != null) {
          vehicleUrlFront = await api.uploadImage(filePath: _vehicleImage1!.path);
        }
        if (_vehicleImage2 != null) {
          vehicleUrlSide = await api.uploadImage(filePath: _vehicleImage2!.path);
        }
        if (_licensePlateImage != null) {
          licensePlateUrl = await api.uploadImage(filePath: _licensePlateImage!.path);
        }

        res = await api.postRiderRegister(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          vehicleType: _selectedVehicleType ??  AppLocalizations.of(context)!.vehicle_motorcycle,
          avatarUrl: avatarUrl,
          idCardUrl: idCardUrl,
          licenseUrl: licenseUrl,
          vehicleUrlFront: vehicleUrlFront,
          vehicleUrlSide: vehicleUrlSide,
          licensePlateUrl: licensePlateUrl,
        );
      } else if (_selectedRoleKey == 'merchant') {
        // Optional: upload avatar if we decide to support merchant logo selection later
        String? avatarUrl;

        // Parse delivery radius
        final radiusText = _deliveryRadiusController.text.trim();
        final radius = double.tryParse(radiusText.isEmpty ? '0' : radiusText) ?? 0;

        res = await api.postMerchantRegister(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          businessType: _selectedBusinessType ?? AppLocalizations.of(context)!.business_type_restaurant,
          restaurantName: _restaurantNameController.text.trim(),
          ownerName: _ownerNameController.text.trim(),
          ownerPhone: _ownerPhoneController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          deliveryRadius: radius,
          address: null,
          lat: null,
          lng: null,
          avatarUrl: avatarUrl,
        );
      } else {
        // user
        res = await api.postAuthRegister(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          role: _selectedRoleKey, // send canonical key: user|rider|merchant
        );
      }

      if (res['success'] == true) {
        final roleMsg = _selectedRoleKey == 'rider'
            ? 'تم إنشاء حساب المندوب بنجاح'
            : _selectedRoleKey == 'merchant'
                ? 'تم إنشاء حساب التاجر بنجاح'
                :  AppLocalizations.of(context)!.signup_success;
        _showSuccess(roleMsg);
      } else {
        final err = (res['error'] ?? {}) as Map<String, dynamic>;
        final msg = (err['message'] ?? 'Registration failed').toString();
        final details = (res['details'] ?? []) as List<dynamic>;
        if (details.isNotEmpty) {
          final items = details
              .whereType<Map>()
              .map((d) {
                final field = (d['path'] ?? d['param'] ?? '').toString();
                final reason = (d['msg'] ?? d['message'] ?? '').toString();
                if (field.isNotEmpty && reason.isNotEmpty) return '$field: $reason';
                return reason;
              })
              .where((s) => s.isNotEmpty)
              .toList();
          _showErrorDialog(title: msg, items: items);
        } else {
          _showError(msg);
        }
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _restaurantNameController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _descriptionController.dispose();
    _deliveryRadiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset + 24),
          child: Column(
            children: [
              const SignupHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicInfoSection(
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        phoneController: _phoneController,
                      ),
                      SizedBox(height: 24.h),
                      
                      RoleSelectorSection(
                        selectedRole: _roleLabelForKey(context, _selectedRoleKey),
                        onRoleChanged: (value) => setState(() => _selectedRoleKey = _roleKeyFromLabel(context, value!)),
                      ),
                      SizedBox(height: 24.h),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildRoleSpecificFields(),
                      ),
                      
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.infinity, 
                        height: 55.h, 
                        child: AbsorbPointer(
                          absorbing: _loading,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: _loading ? 0.6 : 1,
                                child: AppButton(onPressed: _signUp, text:  AppLocalizations.of(context)!.signup_create_account),
                              ),
                              if (_loading)
                                const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const SignupBottomLinks(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSpecificFields() {
    if (_selectedRoleKey == 'rider') {
      return RiderFieldsSection(
        key: const ValueKey('rider'),
        selectedVehicleType: _selectedVehicleType ?? AppLocalizations.of(context)!.vehicle_motorcycle,
        onVehicleTypeChanged: (value) => setState(() => _selectedVehicleType = value!),
        profileImage: _profileImage,
        idCardImage: _idCardImage,
        licenseImage: _licenseImage,
        vehicleImage1: _vehicleImage1,
        vehicleImage2: _vehicleImage2,
        licensePlateImage: _licensePlateImage,
        onPickProfileImage: () => _pickImage((file) => _profileImage = file),
        onPickIdCardImage: () => _pickImage((file) => _idCardImage = file),
        onPickLicenseImage: () => _pickImage((file) => _licenseImage = file),
        onPickVehicleImage1: () => _pickImage((file) => _vehicleImage1 = file),
        onPickVehicleImage2: () => _pickImage((file) => _vehicleImage2 = file),
        onPickLicensePlateImage: () => _pickImage((file) => _licensePlateImage = file),
      );
    }
    if (_selectedRoleKey == 'merchant') {
      return MerchantFieldsSection(
        key: const ValueKey('merchant'),
        restaurantNameController: _restaurantNameController,
        ownerNameController: _ownerNameController,
        ownerPhoneController: _ownerPhoneController,
        descriptionController: _descriptionController,
        deliveryRadiusController: _deliveryRadiusController,
        selectedBusinessType: _selectedBusinessType ??  AppLocalizations.of(context)!.business_type_restaurant,
        onBusinessTypeChanged: (value) => setState(() => _selectedBusinessType = value!),
      );
    }
    return const SizedBox.shrink(key: ValueKey('empty'));
  }
  
  // Map role label <-> key to be locale-agnostic
  String _roleKeyFromLabel(BuildContext context, String label) {
    final l10n =  AppLocalizations.of(context)!;
    if (label == l10n.role_rider) return 'rider';
    if (label == l10n.role_merchant) return 'merchant';
    return 'user';
  }

  String _roleLabelForKey(BuildContext context, String key) {
    final l10n =  AppLocalizations.of(context)!;
    switch (key) {
      case 'rider':
        return l10n.role_rider;
      case 'merchant':
        return l10n.role_merchant;
      default:
        return l10n.role_user;
    }
  }
  
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green)
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red)
    );
  }

  void _showErrorDialog({required String title, required List<String> items}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in items) Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(s)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}