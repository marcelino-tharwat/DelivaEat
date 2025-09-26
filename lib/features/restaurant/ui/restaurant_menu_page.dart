import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RestaurantMenuPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  const RestaurantMenuPage({super.key, required this.restaurantId, required this.restaurantName});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _foods = [];

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        ApiConstant.foodsByRestaurantUrl,
        queryParameters: {
          'restaurantId': widget.restaurantId,
          'limit': 100,
          'lang': lang,
        },
      );
      final List data = (res.data?['data'] ?? []) as List;
      _foods = data.cast<Map<String, dynamic>>();
    } catch (e) {
      String message = 'فشل في تحميل قائمة المطعم، حاول لاحقاً';
      if (e is DioException) {
        final serverMsg = (e.response?.data is Map)
            ? (e.response?.data['error']?['message'] ?? e.response?.data['message'])
            : null;
        if (serverMsg is String && serverMsg.isNotEmpty) message = serverMsg;
      }
      _error = message;
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _fetchFoods,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _foods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final f = _foods[index];
                    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
                    final name = isArabic && (f['nameAr'] ?? '').toString().isNotEmpty ? f['nameAr'] : f['name'];
                    final price = f['price'];
                    final image = (f['image'] ?? '').toString();
                    final rating = (f['rating'] ?? '').toString();
                    final prep = (f['preparationTime'] ?? '').toString();
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: image.isNotEmpty
                              ? Image.network(
                                  image,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 64,
                                    height: 64,
                                    color: colors.surface,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                )
                              : Container(
                                  width: 64,
                                  height: 64,
                                  color: colors.surface,
                                  child: const Icon(Icons.fastfood),
                                ),
                        ),
                        title: Text(
                          '$name',
                          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(rating.isEmpty ? '-' : rating, style: text.bodySmall),
                                const SizedBox(width: 12),
                                const Icon(Icons.access_time, size: 14),
                                const SizedBox(width: 4),
                                Expanded(child: Text(prep, style: text.bodySmall, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          price == null ? '' : '${price.toString()} ر.س',
                          style: text.titleMedium?.copyWith(color: colors.primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
