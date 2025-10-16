import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final navBarHeight = (85.h).clamp(70.h, 100.h);

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            appLocalizations.homePageTitle,
            Icons.home_rounded,
            0,
            context,
          ),
          _buildNavItem(
            appLocalizations.ordersTitle,
            Icons.receipt_long_rounded,
            1,
            context,
          ),
          _buildNavItem(
            appLocalizations.offersTitle,
            Icons.local_offer_rounded,
            2,
            context,
          ),
          _buildNavItem(
            appLocalizations.accountTitle,
            Icons.person_rounded,
            3,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    IconData icon,
    int index,
    BuildContext context,
  ) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onItemSelected(index),
        borderRadius: BorderRadius.circular(24.r),
        splashColor: colors.primary.withOpacity(0.1),
        highlightColor: colors.primary.withOpacity(0.05),
        child: SizedBox(
          height: 60.h, // تحديد ارتفاع ثابت للمنطقة القابلة للنقر
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- الخلفية المتحركة (الدائرة) ---
              // هذه الدائرة تتحرك وتكبر في الخلفية
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: isSelected ? 0.h : 8.h, // تتحرك للأعلى عند الاختيار
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: isSelected ? 40.w : 0, // تظهر وتختفي
                  height: isSelected ? 40.w : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colors.primary.withOpacity(0.15),
                        colors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // --- محتوى الأيقونة والنص (في المقدمة) ---
              // هذا العمود لا يتغير موضعه، فقط محتواه
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الأيقونة يتغير حجمها ولونها فقط
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      icon,
                      key: ValueKey<bool>(
                        isSelected,
                      ), // مهم للـ AnimatedSwitcher
                      color: isSelected
                          ? colors.primary 
                          : colors.onSurface.withOpacity(0.6),
                      size: 24
                          .sp, // الحجم ثابت هنا، الحركة تأتي من AnimatedSwitcher
                    ),
                  ),
                  SizedBox(height: 4.h), // مسافة ثابتة
                  // النص يتغير الستايل الخاص به فقط
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style:
                        textStyles.bodySmall?.copyWith(
                          color: isSelected
                              ? colors.primary
                              : colors.onSurface.withOpacity(0.7),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 11.sp,
                        ) ??
                        const TextStyle(),
                    child: Text(title, maxLines: 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
