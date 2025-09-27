import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final bool isActive = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 10.w : 8.w, // ممكن تعمل فرق بسيط للحجم
          height: isActive ? 10.w : 8.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle, // ✅ دايرة مش مستطيل
            color: isActive
                ? Colors.white // نقطة نشطة
                : Colors.white.withOpacity(0.4), // نقطة خاملة
          ),
        );
      }),
    );
  }
}
