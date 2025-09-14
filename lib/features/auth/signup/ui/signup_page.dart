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

  String _selectedRole = 'User';
  String _selectedVehicleType = 'Motorcycle';
  String _selectedBusinessType = 'Restaurant';
  
  File? _profileImage;
  File? _idCardImage;
  File? _licenseImage;
  File? _vehicleImage1;
  File? _vehicleImage2;
  File? _licensePlateImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(void Function(File) setImageCallback) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        setImageCallback(File(image.path));
      });
    }
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      log('Form is valid. Proceeding with sign up...');
      _showSuccess(S.of(context).signup_success);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
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
                      selectedRole: _selectedRole,
                      onRoleChanged: (value) => setState(() => _selectedRole = value!),
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
                      child: AppButton(onPressed: _signUp, text: S.of(context).signup_create_account)
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
    );
  }

  Widget _buildRoleSpecificFields() {
    if (_selectedRole == 'Rider') {
      return RiderFieldsSection(
        key: const ValueKey('rider'),
        selectedVehicleType: _selectedVehicleType,
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
    if (_selectedRole == 'Merchant') {
      return MerchantFieldsSection(
        key: const ValueKey('merchant'),
        restaurantNameController: _restaurantNameController,
        ownerNameController: _ownerNameController,
        ownerPhoneController: _ownerPhoneController,
        descriptionController: _descriptionController,
        deliveryRadiusController: _deliveryRadiusController,
        selectedBusinessType: _selectedBusinessType,
        onBusinessTypeChanged: (value) => setState(() => _selectedBusinessType = value!),
      );
    }
    return const SizedBox.shrink(key: ValueKey('empty'));
  }
  
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green)
    );
  }
}