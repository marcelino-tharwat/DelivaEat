import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/category/data/model/category_item.dart';
import 'package:deliva_eat/features/home/ui/widget/offer_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// هذا الملف يحتوي فقط على القالب القابل لإعادة الاستخدام
class ReusableCategoryLayout extends StatefulWidget {
  final String pageTitle;
  final String searchHintText;
  final List<Map<String, dynamic>> offers;
  final List<CategoryItem> categories;
  final String selectedCategoryId;
  final Function(String categoryId) onCategorySelected;
  final List<String> filters;
  final String selectedFilter;
  final Function(String filter) onFilterSelected;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const ReusableCategoryLayout({
    super.key,
    required this.pageTitle,
    this.searchHintText = 'ابحث...',
    required this.offers,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.isLoading,
    this.errorMessage,
    required this.onRetry,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<ReusableCategoryLayout> createState() => _ReusableCategoryLayoutState();
}

class _ReusableCategoryLayoutState extends State<ReusableCategoryLayout> {
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... الكود الخاص ببناء الواجهة (build) يبقى كما هو تمامًا بدون أي تغيير ...
    // لقد قمت بنسخه كما هو من سؤالك لأنه صحيح
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. العنوان وزر الرجوع
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.pageTitle, // نستخدم المتغير الممرر
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(Icons.arrow_back_ios_new, size: 20, color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 2. شريط البحث (شكلي فقط)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
                  border: Border.all(color: theme.dividerColor, width: 1),
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push(AppRoutes.searchPage);
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: widget.searchHintText, // نستخدم المتغير الممرر
                      hintStyle: TextStyle(color: theme.hintColor, fontSize: 16, fontWeight: FontWeight.w400),
                      prefixIcon: Icon(Icons.search_rounded, color: theme.hintColor, size: 24),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 3. السلايدر
            OffersSlider(
              offers: widget.offers, // نستخدم المتغير الممرر
              pageController: _pageController,
              onPageChanged: (index) => setState(() => _currentPageIndex = index),
              onOfferTap: (offer) {},
              currentPageIndex: _currentPageIndex,
            ),
            // 4. قسم الفئات الدائرية
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(
                      'الأصناف',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.categories.length, // نستخدم المتغير الممرر
                      itemBuilder: (context, index) {
                        final category = widget.categories[index];
                        final isSelected = widget.selectedCategoryId == category.id;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            widget.onCategorySelected(category.id);
                          },
                          child: Container(
                            width: 120,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 2, spreadRadius: 1)] : [],
                                  ),
                                  child: Card(
                                    elevation: isSelected ? 8 : 4,
                                    shadowColor: theme.shadowColor.withOpacity(isSelected ? 0.25 : 0.15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                                    clipBehavior: Clip.antiAlias,
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Container(
                                        color: theme.cardColor,
                                        child: Icon(
                                          category.id == 'restaurants' ? Icons.restaurant : Icons.fastfood,
                                          size: 40,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // 5. الفلاتر
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.filters.map((filter) => _buildFilterChip(filter, theme)).toList(),
              ),
            ),
            // 6. عرض المحتوى (تحميل، خطأ، أو القائمة)
            _buildContentBody(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterName, ThemeData theme) {
    final isSelected = widget.selectedFilter == filterName;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onFilterSelected(filterName); // إبلاغ الأب
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? theme.primaryColor : theme.dividerColor, width: 1),
        ),
        child: Text(
          filterName,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContentBody(ThemeData theme) {
    if (widget.isLoading) {
      return const Padding(padding: EdgeInsets.symmetric(vertical: 64.0), child: Center(child: CircularProgressIndicator()));
    }
    if (widget.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Column(
            children: [
              Text(widget.errorMessage!, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: widget.onRetry, child: const Text("إعادة المحاولة")),
            ],
          ),
        ),
      );
    }
    if (widget.itemCount == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: theme.hintColor),
              const SizedBox(height: 16),
              Text(
                'لم يتم العثور على عناصر',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.hintColor),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        itemBuilder: widget.itemBuilder,
      ),
    );
  }
}