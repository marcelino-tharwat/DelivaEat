import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      height: 0.7.sh, // 👈 متجاوب
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.outline,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.notifications,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp, // 👈 متجاوب
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    appLocalizations.readAll,
                    style: TextStyle(fontSize: 14.sp), // 👈 متجاوب
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  Divider(color: context.colors.outline.withOpacity(0.3)),
              itemBuilder: (context, index) {
                final notifications = [
                  {
                    'title': 'تم قبول طلبك',
                    'subtitle': 'طلبك من مطعم النور قيد التحضير',
                    'time': 'منذ 5 دقائق',
                    'icon': Icons.restaurant,
                    'color': const Color(0xFF4CAF50),
                  },
                  {
                    'title': 'عرض خاص لك!',
                    'subtitle': 'خصم 25% على طلبك القادم',
                    'time': 'منذ ساعة',
                    'icon': Icons.local_offer,
                    'color': const Color(0xFFFF9800),
                  },
                  {
                    'title': 'تم توصيل الطلب',
                    'subtitle': 'وصل طلبك بنجاح، نرجو التقييم',
                    'time': 'منذ ساعتين',
                    'icon': Icons.check_circle,
                    'color': const Color(0xFF2196F3),
                  },
                  {
                    'title': 'مطعم جديد!',
                    'subtitle': 'افتتح مطعم جديد في منطقتك',
                    'time': 'أمس',
                    'icon': Icons.store,
                    'color': const Color(0xFF9C27B0),
                  },
                  {
                    'title': 'تذكير',
                    'subtitle': 'لديك نقاط يمكن استبدالها',
                    'time': 'منذ يومين',
                    'icon': Icons.stars,
                    'color': const Color(0xFFFFD700),
                  },
                ];

                final notification = notifications[index];

                return ListTile(
                  leading: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: notification['color'] as Color,
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    notification['title'] as String,
                    style: context.textStyles.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        notification['subtitle'] as String,
                        style: context.textStyles.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: context.colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification['time'] as String,
                        style: context.textStyles.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: context.colors.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: index < 2
                          ? context.colors.primary
                          : const Color(0x00000000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
