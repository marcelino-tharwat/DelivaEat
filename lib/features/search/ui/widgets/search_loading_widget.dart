import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/widgets/skeleton_loader.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonLoader();
  }
}
