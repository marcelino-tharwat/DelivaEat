import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchSuggestions extends StatelessWidget {
  final SearchSuggestionsSuccess state;
  final Function(String) onSuggestionTap;

  const SearchSuggestions({
    super.key,
    required this.state,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: state.suggestions.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              suggestion.type == "restaurant"
                  ? Icons.restaurant
                  : Icons.fastfood,
              color: Theme.of(context).primaryColor,
              size: 20.sp,
            ),
          ),
          title: Text(
            suggestion.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
          ),
          subtitle: suggestion.restaurant != null
              ? Text(
                  "${AppLocalizations.of(context)!.from}: ${suggestion.restaurant}",
                  style: TextStyle(fontSize: 14.sp),
                )
              : null,
          trailing: Icon(
            Icons.north_west,
            color: Colors.grey[400],
            size: 16.sp,
          ),
          onTap: () => onSuggestionTap(suggestion.name),
        );
      },
    );
  }
}
