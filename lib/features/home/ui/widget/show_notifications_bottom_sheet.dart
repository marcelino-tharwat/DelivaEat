import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.notifications,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text(appLocalizations.readAll)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  Divider(color: context.colors.outline.withOpacity(0.3)),
              itemBuilder: (context, index) {
                final notifications = [
                  {
                    'title': 'تم قبول طلبك', // Consider localization for notifications
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color).withOpacity(
                        0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: notification['color'] as Color,
                    ),
                  ),
                  title: Text(
                    notification['title'] as String,
                    style: context.textStyles.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification['subtitle'] as String,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['time'] as String,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index < 2
                          ? context.colors.primary
                          // ignore: use_full_hex_values_for_flutter_colors
                          : const Color(0x0000000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
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