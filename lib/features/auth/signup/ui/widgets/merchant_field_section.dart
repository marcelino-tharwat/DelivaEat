import 'package:deliva_eat/core/widgets/app_drop_down.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MerchantFieldsSection extends StatelessWidget {
  final TextEditingController restaurantNameController;
  final TextEditingController ownerNameController;
  final TextEditingController ownerPhoneController;
  final TextEditingController descriptionController;
  final TextEditingController deliveryRadiusController;
  final String selectedBusinessType;
  final ValueChanged<String?> onBusinessTypeChanged;

  const MerchantFieldsSection({
    super.key,
    required this.restaurantNameController,
    required this.ownerNameController,
    required this.ownerPhoneController,
    required this.descriptionController,
    required this.deliveryRadiusController,
    required this.selectedBusinessType,
    required this.onBusinessTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.merchant_info_title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        // Business Type Dropdown
        AppDropdown(
          labelText: l10n.business_type_label,
          prefixIcon: Icons.storefront_outlined,
          value: selectedBusinessType,
          items: [
            l10n.business_type_restaurant,
            l10n.business_type_grocery,
            l10n.business_type_pharmacy,
            l10n.business_type_bakery,
          ],
          onChanged: onBusinessTypeChanged,
        ),
        SizedBox(height: 16.h),

        // Business Name
        AppTextField(
          controller: restaurantNameController,
          labelText: l10n.business_name,
          prefixIcon: Icons.store,
          validator: (v) => v!.isEmpty ? l10n.error_required : null,
        ),
        SizedBox(height: 16.h),

        // Owner Name
        AppTextField(
          controller: ownerNameController,
          labelText: l10n.owner_name,
          prefixIcon: Icons.person_outline,
          validator: (v) => v!.isEmpty ? l10n.error_required : null,
        ),
        SizedBox(height: 16.h),

        // Owner Phone
        AppTextField(
          controller: ownerPhoneController,
          labelText: l10n.owner_phone,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) => v!.isEmpty ? l10n.error_required : null,
        ),
        SizedBox(height: 16.h),

        // Business Description
        AppTextField(
          controller: descriptionController,
          labelText: l10n.business_description,
          prefixIcon: Icons.description,
          maxLines: 3,
        ),
        SizedBox(height: 16.h),

        // Delivery Radius
        AppTextField(
          controller: deliveryRadiusController,
          labelText: l10n.delivery_radius,
          prefixIcon: Icons.location_searching,
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? l10n.error_required : null,
        ),
      ],
    );
  }
}
