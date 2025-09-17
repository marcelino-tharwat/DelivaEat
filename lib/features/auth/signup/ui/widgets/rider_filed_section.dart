import 'dart:io';
import 'dart:math';

import 'package:deliva_eat/core/widgets/app_drop_down.dart';
import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RiderFieldsSection extends StatelessWidget {
  final String selectedVehicleType;
  final ValueChanged<String?> onVehicleTypeChanged;
  final File? profileImage;
  final File? idCardImage;
  final File? licenseImage;
  final File? vehicleImage1;
  final File? vehicleImage2;
  final File? licensePlateImage;
  final VoidCallback onPickProfileImage;
  final VoidCallback onPickIdCardImage;
  final VoidCallback onPickLicenseImage;
  final VoidCallback onPickVehicleImage1;
  final VoidCallback onPickVehicleImage2;
  final VoidCallback onPickLicensePlateImage;

  const RiderFieldsSection({
    super.key,
    required this.selectedVehicleType,
    required this.onVehicleTypeChanged,
    this.profileImage,
    this.idCardImage,
    this.licenseImage,
    this.vehicleImage1,
    this.vehicleImage2,
    this.licensePlateImage,
    required this.onPickProfileImage,
    required this.onPickIdCardImage,
    required this.onPickLicenseImage,
    required this.onPickVehicleImage1,
    required this.onPickVehicleImage2,
    required this.onPickLicensePlateImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rider_info_title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        AppDropdown(
          labelText: l10n.vehicle_type_label,
          prefixIcon: Icons.two_wheeler_outlined,
          value: selectedVehicleType,
          items: [
            l10n.vehicle_motorcycle,
            l10n.vehicle_bicycle,
            l10n.vehicle_scooter,
          ],
          onChanged: onVehicleTypeChanged,
        ),
        SizedBox(height: 16.h),
        _buildImagePicker(
          l10n.profile_photo,
          profileImage,
          onPickProfileImage,
          l10n,
        ),
        SizedBox(height: 16.h),
        _buildImagePicker(
          l10n.id_card_photo,
          idCardImage,
          onPickIdCardImage,
          l10n,
        ),
        SizedBox(height: 16.h),
        _buildImagePicker(
          l10n.license_photo,
          licenseImage,
          onPickLicenseImage,
          l10n,
        ),
        SizedBox(height: 16.h),
        _buildImagePicker(
          l10n.vehicle_photo_front,
          vehicleImage1,
          onPickVehicleImage1,
          l10n,
        ),
        SizedBox(height: 16.h),
        _buildImagePicker(
          l10n.vehicle_photo_side,
          vehicleImage2,
          onPickVehicleImage2,
          l10n,
        ),
        SizedBox(height: 16.h),
        if (selectedVehicleType == l10n.vehicle_motorcycle)
          _buildImagePicker(
            l10n.license_plate_photo,
            licensePlateImage,
            onPickLicensePlateImage,
            l10n,
          ),
      ],
    );
  }

  Widget _buildImagePicker(
    String title,
    File? image,
    VoidCallback onPick,
    l10n,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: image != null
                    ? Image.file(
                        image,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80.w,
                        height: 80.w,
                        color: Colors.grey[200],
                        child: const Icon(Icons.camera_alt, color: Colors.grey),
                      ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    image != null ? Icons.edit : Icons.add_a_photo,
                    color: const Color(0xFFF5C842),
                  ),
                  label: Text(
                    image != null ? l10n.change_photo : l10n.select_photo,
                    style: const TextStyle(
                      color: Color(0xFFF5C842),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onPick,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C842).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
