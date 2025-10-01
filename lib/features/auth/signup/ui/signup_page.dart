import 'dart:developer';
import 'dart:io';
import 'package:deliva_eat/features/auth/signup/ui/widgets/role_selector_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/signup_button_link.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/features/auth/signup/cubit/signup_cubit.dart';
import 'package:deliva_eat/features/auth/signup/data/models/merchant_model.dart';
import 'package:deliva_eat/features/auth/signup/data/repos/signup_repo.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/basic_info_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/merchant_field_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/rider_filed_section.dart';
import 'package:deliva_eat/features/auth/signup/ui/widgets/signup_header.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// ... SignUpPage class remains the same ...
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(signupRepo: getIt<SignupRepo>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // ... All your controllers and variables remain the same ...
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

  String _selectedRoleKey = 'user';
  String? _selectedVehicleType;
  String? _selectedBusinessType;

  File? _profileImage;
  File? _idCardImage;
  File? _licenseImage;
  File? _vehicleImage1;
  File? _vehicleImage2;
  File? _licensePlateImage;

  String? _address;
  double? _latitude;
  double? _longitude;

  final ImagePicker _picker = ImagePicker();
  bool _initialized = false;
  // NEW: Add a state for loading indicator during compression
  bool _isCompressing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      _selectedVehicleType ??= l10n.vehicle_motorcycle;
      _selectedBusinessType ??= l10n.business_type_restaurant;
      _initialized = true;
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

  // MODIFIED: _pickImage method is now updated to use the compression helper
  Future<void> _pickImage(void Function(File) setImageCallback) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _isCompressing = true); // Show loading

      final compressedFile = await _compressImage(File(image.path));

      setState(() {
        setImageCallback(compressedFile);
        _isCompressing = false; // Hide loading
      });
    }
  }

  // NEW: Helper function to compress the image file
  Future<File> _compressImage(File file) async {
    try {
      // 1. Get the temporary directory
      final tempDir = await getTemporaryDirectory();

      // 2. Create a target path for the compressed file
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 3. Compress the file and get the result
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality from 0 to 100
      );

      if (result != null) {
        final resultFile = File(result.path);
        log('Original image size: ${file.lengthSync() / 1024} KB');
        log('Compressed image size: ${resultFile.lengthSync() / 1024} KB');
        return resultFile;
      }
    } catch (e) {
      log('Failed to compress image: $e');
    }

    // If compression fails for any reason, return the original file
    return file;
  }

  Future<void> _signUp() async {
    if (_isCompressing || !_formKey.currentState!.validate()) return;

    final cubit = context.read<SignupCubit>();
    final l10n = AppLocalizations.of(context)!;

    if (_selectedRoleKey == 'rider') {
      // Rider registration logic (remains the same)
      await cubit.riderRegister(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        vehicleType: _selectedVehicleType ?? l10n.vehicle_motorcycle,
        avatarFile: _profileImage,
        idCardFile: _idCardImage,
        licenseFile: _licenseImage,
        vehicleFileFront: _vehicleImage1,
        vehicleFileSide: _vehicleImage2,
        licensePlateFile: _licensePlateImage,
      );
    } else if (_selectedRoleKey == 'merchant') {
      // Merchant registration logic (remains the same)
      final radiusText = _deliveryRadiusController.text.trim();
      final radius =
          double.tryParse(radiusText.isEmpty ? '0' : radiusText) ?? 0;

      LocationModel? location;
      if (_latitude != null && _longitude != null) {
        location = LocationModel(lat: _latitude!, lng: _longitude!);
      }

      await cubit.merchantRegister(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        restaurantName: _restaurantNameController.text.trim(),
        businessType: _selectedBusinessType ?? l10n.business_type_restaurant,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        deliveryRadius: radius,
        address: _address,
        location: location,
        avatarUrl: null,
      );
    } else {
      // THIS IS THE FIX: Handle the 'user' role
      await cubit.register(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        role: _selectedRoleKey, // This will be 'user'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ...
    // The build method will mostly be the same. You can add a loading indicator
    // for when `_isCompressing` is true if you want.
    // For simplicity, I will just disable the button.

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          // ... listener logic remains the same
          if (state is SignupSuccess) {
            final roleMsg = _selectedRoleKey == 'rider'
                ? 'تم إنشاء حساب المندوب بنجاح'
                : _selectedRoleKey == 'merchant'
                ? 'تم إنشاء حساب التاجر بنجاح'
                : l10n.signup_success;
            _showSuccess(roleMsg);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context);
            });
          } else if (state is SignupFailure) {
            _showError(state.errorMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is SignupLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomInset + 24),
            child: Stack(
              children: [
                // Your main content
                Column(
                  children: [
                    const SignupHeader(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ... your widgets here (BasicInfoSection, etc.)
                            BasicInfoSection(
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              phoneController: _phoneController,
                            ),
                            SizedBox(height: 24.h),
                            RoleSelectorSection(
                              selectedRole: _roleLabelForKey(
                                context,
                                _selectedRoleKey,
                              ),
                              onRoleChanged: (value) => setState(
                                () => _selectedRoleKey = _roleKeyFromLabel(
                                  context,
                                  value!,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _buildRoleSpecificFields(),
                            ),
                            SizedBox(height: 30.h),
                            // Your button section
                            SizedBox(
                              width: double.infinity,
                              height: 55.h,
                              child: AbsorbPointer(
                                // MODIFIED: Also disable button during compression
                                absorbing: isLoading || _isCompressing,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Opacity(
                                      opacity: isLoading || _isCompressing
                                          ? 0.6
                                          : 1,
                                      child: AppButton(
                                        onPressed: _signUp,
                                        text: l10n.signup_create_account,
                                      ),
                                    ),
                                    if (isLoading)
                                      const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
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
                // NEW: Overlay indicator for image compression
                if (_isCompressing)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'جاري ضغط الصورة...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ... _buildRoleSpecificFields and other helper methods remain the same ...
  Widget _buildRoleSpecificFields() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedRoleKey == 'rider') {
      return RiderFieldsSection(
        key: const ValueKey('rider'),
        selectedVehicleType: _selectedVehicleType ?? l10n.vehicle_motorcycle,
        onVehicleTypeChanged: (value) =>
            setState(() => _selectedVehicleType = value!),
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
        onPickLicensePlateImage: () =>
            _pickImage((file) => _licensePlateImage = file),
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
        selectedBusinessType:
            _selectedBusinessType ?? l10n.business_type_restaurant,
        onBusinessTypeChanged: (value) =>
            setState(() => _selectedBusinessType = value!),
        onLocationSelected: (address, lat, lng) {
          setState(() {
            _address = address;
            _latitude = lat;
            _longitude = lng;
          });
        },
      );
    }
    return const SizedBox.shrink(key: ValueKey('empty'));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _roleKeyFromLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    if (label == l10n.role_rider) return 'rider';
    if (label == l10n.role_merchant) return 'merchant';
    return 'user';
  }

  String _roleLabelForKey(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'rider':
        return l10n.role_rider;
      case 'merchant':
        return l10n.role_merchant;
      default:
        return l10n.role_user;
    }
  }
}
