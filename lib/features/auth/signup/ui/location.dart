import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(String address, double latitude, double longitude)
  onLocationSelected;
  final String? initialAddress;

  const LocationPickerWidget({
    Key? key,
    required this.onLocationSelected,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  String? _currentAddress;
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.initialAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFF5C842), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.selected_address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _currentAddress ??
                      AppLocalizations.of(context)!.no_location_selected,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _currentAddress != null
                        ? Colors.black87
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _getCurrentLocation,
                  icon: _isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(
                    _isLoading
                        ? AppLocalizations.of(context)!.getting_location
                        : AppLocalizations.of(context)!.current_location_label,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C842),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openMapPicker(),
                  icon: const Icon(Icons.map, size: 18),
                  label: Text(AppLocalizations.of(context)!.pick_on_map),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFF5C842),
                    side: const BorderSide(color: Color(0xFFF5C842)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showAddressInput(),
              icon: const Icon(Icons.edit_location, size: 18),
              label: Text(AppLocalizations.of(context)!.enter_address_manually),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF5C842),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted)
            _showError(
              AppLocalizations.of(context)!.location_permission_denied,
            );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          _showError(
            AppLocalizations.of(
              context,
            )!.location_permissions_permanently_denied,
          );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String address =
          "Current Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";

      if (!mounted) return; // هنا مهم عشان نتأكد إن الـ widget لسه شغال

      setState(() {
        _currentAddress = address;
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
      });

      widget.onLocationSelected(address, position.latitude, position.longitude);
    } catch (e) {
      if (mounted)
        _showError(
          '${AppLocalizations.of(context)!.failed_to_get_location}: ${e.toString()}',
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openMapPicker() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMapPickerModal(),
    );
  }

  Widget _buildMapPickerModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.pick_on_map,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 100.w, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)!.interactive_map,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(context)!.google_maps_integration,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: const Color(0xFFF5C842)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _currentAddress ??
                              AppLocalizations.of(
                                context,
                              )!.tap_on_map_to_select_location,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          const mockAddress = 'Selected Location from Map';
                          const mockLat = 31.2001;
                          const mockLng = 29.9187;

                          setState(() {
                            _currentAddress = mockAddress;
                            _currentLatitude = mockLat;
                            _currentLongitude = mockLng;
                          });

                          widget.onLocationSelected(
                            mockAddress,
                            mockLat,
                            mockLng,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5C842),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressInput() {
    final addressController = TextEditingController(text: _currentAddress);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.enter_address),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(
                  context,
                )!.enter_your_complete_address,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty) {
                if (!mounted) return;
                setState(() => _currentAddress = addressController.text);

                const mockLat = 31.2001;
                const mockLng = 29.9187;

                widget.onLocationSelected(
                  addressController.text,
                  mockLat,
                  mockLng,
                );

                if (mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5C842),
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
