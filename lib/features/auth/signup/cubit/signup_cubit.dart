import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:deliva_eat/features/auth/signup/data/models/merchant_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/rider_model.dart';
import 'package:meta/meta.dart';
import 'package:deliva_eat/features/auth/signup/data/models/signup_req_model.dart';
import 'package:deliva_eat/features/auth/signup/data/repos/signup_repo.dart';
import 'package:flutter/widgets.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;
  SignupCubit({required this.signupRepo}) : super(SignupInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role,
    required BuildContext context,
  }) async {
    emit(SignupLoading());
    final req = SignupReqModel(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );
    final result = await signupRepo.register(
      signupReqModel: req,
      context: context,
    );
    result.fold(
      (error) => emit(SignupFailure(error.errorMessage)),
      (res) => emit(SignupSuccess()),
    );
  }

  Future<void> riderRegister({
    required String name,
    required String email,
    required String password,
    String? phone,
    required String vehicleType,
    String? licenseNumber,
    String? nationalId,
    File? avatarFile,
    File? idCardFile,
    File? licenseFile,
    File? vehicleFileFront,
    File? vehicleFileSide,
    File? licensePlateFile,
    required BuildContext context,
  }) async {
    emit(SignupLoading());

    try {
      // Step 1: Upload images one by one and collect their URLs.
      // This now uses the correctly configured Dio instance from the repo.
      String? avatarUrl,
          idCardUrl,
          licenseUrl,
          vehicleUrlFront,
          vehicleUrlSide,
          licensePlateUrl;

      if (avatarFile != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: avatarFile,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => avatarUrl = url,
        );
      }
      if (idCardFile != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: idCardFile,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => idCardUrl = url,
        );
      }
      if (licenseFile != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: licenseFile,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => licenseUrl = url,
        );
      }
      if (vehicleFileFront != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: vehicleFileFront,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => vehicleUrlFront = url,
        );
      }
      if (vehicleFileSide != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: vehicleFileSide,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => vehicleUrlSide = url,
        );
      }
      if (licensePlateFile != null) {
        final result = await signupRepo.uploadRiderImage(
          imageFile: licensePlateFile,
          context: context,
        );
        result.fold(
          (err) => throw (err.errorMessage),
          (url) => licensePlateUrl = url,
        );
      }

      // Step 2: Create the RiderModel with the URLs we received from the server.
      final req = RiderModel(
        false, // active parameter
        name: name,
        email: email,
        password: password,
        phone: phone,
        vehicleType: vehicleType,
        // licenseNumber: licenseNumber,
        // nationalId: nationalId,
        avatarUrl: avatarUrl,
        idCardUrl: idCardUrl,
        licenseUrl: licenseUrl,
        vehicleUrlFront: vehicleUrlFront,
        vehicleUrlSide: vehicleUrlSide,
        licensePlateUrl: licensePlateUrl,
      );

      // Step 3: Send the final registration data to the server.
      final registrationResult = await signupRepo.riderRegister(
        riderModel: req,
        context: context,
      );

      registrationResult.fold(
        (err) => emit(SignupFailure(err.errorMessage)),
        (_) => emit(SignupSuccess()),
      );
    } catch (e) {
      // If any step fails (uploading or registering), we'll end up here.
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> merchantRegister({
  // NEW: Add the required basic user fields to the signature
  required String name,
  required String email,
  required String password,
  required String phone,

  // These are the existing merchant-specific fields
  required String ownerName,
  required String ownerPhone,
  required String restaurantName,
  required String businessType,
  String? description,
  double? deliveryRadius,
  String? address,
  LocationModel? location,
  String? avatarUrl,
  required BuildContext context,
}) async {
  emit(SignupLoading());

  // إنشاء ال model عشان يبعت لل API
  // MODIFIED: Now we pass ALL the required data to the model
  final merchant = MerchantModel(
    // Pass the basic user info
    name: name,
    email: email,
    password: password,
    phone: phone,

    // Pass the merchant-specific info
    id: '', // Server will generate this
    userId: '', // Server will generate this
    businessType: businessType,
    restaurantName: restaurantName,
    ownerName: ownerName,
    ownerPhone: ownerPhone,
    description: description,
    deliveryRadius: deliveryRadius ?? 0.0,
    address: address,
    location: location,
    // The backend requires a valid URL. Null is not accepted.
    // We send a placeholder if no avatar is provided. The backend should ideally handle this.
    avatarUrl: avatarUrl ?? 'https://via.placeholder.com/150',
    active: false,
  );

  final result = await signupRepo.merchantRegister(
    merchantModel: merchant,
    context: context,
  );

  result.fold(
    (err) => emit(SignupFailure(err.errorMessage)),
    (_) => emit(SignupSuccess()),
  );
}
}
