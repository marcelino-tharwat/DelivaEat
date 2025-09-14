import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdown extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const AppDropdown({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
  
    final primaryColor = const Color(0xFFF5C842);

    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        final bool isSelected = item == value;
        return DropdownMenuItem<String>(
          value: item,
          child: Container(
          
            width: double.infinity, 
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor.withOpacity(0.8) : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,

   

      dropdownColor: Colors.white, 
      elevation: 4, 
      borderRadius: BorderRadius.circular(15.r), 

      
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis, 
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: primaryColor,
        size: 24.sp,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIcon, color: primaryColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h).copyWith(left: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}