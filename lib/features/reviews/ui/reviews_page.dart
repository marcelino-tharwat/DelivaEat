import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/core/network/dio_factory.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class ReviewsPage extends StatefulWidget {
  final String? foodId;
  final String? restaurantId;
  final String title;
  const ReviewsPage({super.key, this.foodId, this.restaurantId, this.title = ''});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  bool _loading = true;
  String? _error;
  List<dynamic> _items = [];
  int _page = 1;
  bool _hasMore = true;

  Future<void> _fetch({bool loadMore = false}) async {
    if (loadMore && !_hasMore) return;
    setState(() {
      _loading = !loadMore;
      _error = null;
    });
    try {
      final dio = DioFactory.getDio();
      final lang = Localizations.localeOf(context).languageCode;
      final res = await dio.get(
        ApiConstant.reviewsUrl,
        queryParameters: {
          if (widget.foodId != null) 'foodId': widget.foodId,
          if (widget.restaurantId != null) 'restaurantId': widget.restaurantId,
          'limit': 20,
          'page': loadMore ? _page + 1 : 1,
          'lang': lang,
        },
      );
      final ok = res.data is Map && (res.data['success'] == true);
      if (!ok) throw Exception('Failed');
      final data = res.data['data'] as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>?) ?? [];
      final total = (data['total'] as num?)?.toInt() ?? 0;
      final page = (data['page'] as num?)?.toInt() ?? 1;
      setState(() {
        _page = page;
        if (loadMore) {
          _items.addAll(items);
        } else {
          _items = items;
        }
        _hasMore = _items.length < total;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load reviews');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.title.isNotEmpty ? widget.title : AppLocalizations.of(context)!.seeAllReviews;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: () => _fetch(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(12.w),
                    itemCount: _items.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == _items.length) {
                        _fetch(loadMore: true);
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final it = _items[i] as Map<String, dynamic>;
                      final user = (it['userName'] ?? 'Anonymous').toString();
                      final rating = (it['rating'] as num?)?.toDouble() ?? 0.0;
                      final comment = (it['comment'] ?? '').toString();
                      final dt = (it['createdAt'] ?? '').toString();
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, size: 18.sp),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(user, style: theme.textTheme.titleSmall),
                                  ),
                                  Icon(Icons.star, color: Colors.amber, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(rating.toStringAsFixed(1)),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(comment, style: theme.textTheme.bodyMedium),
                              SizedBox(height: 6.h),
                              Text(dt, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
