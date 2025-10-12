import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/core/widgets/app_button.dart';

class Review {
  final String username;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class RatingReviewsPage extends StatefulWidget {
  const RatingReviewsPage({super.key});

  @override
  State<RatingReviewsPage> createState() => _RatingReviewsPageState();
}

class _RatingReviewsPageState extends State<RatingReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _userRating = 0;
  bool _showRatingError = false;
  String? _commentError;

  List<Review> reviews = [
    Review(
      username: 'Ahmed12',
      rating: 4,
      comment:
          'Amazing flavor! The Chicken was perfectly cooked. and it the spice level right.\nHighly recommended!',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      username: 'Ahmed12',
      rating: 4,
      comment:
          'Amazing flavor! The Chicken was perfectly cooked. and it the spice level right.\nHighly recommended!',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Review(
      username: 'Ahmed12',
      rating: 4,
      comment:
          'Amazing flavor! The Chicken was perfectly cooked. and it the spice level right.\nHighly recommended!',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  double get averageRating {
    if (reviews.isEmpty) return 0;
    double sum = reviews.fold(0, (prev, review) => prev + review.rating);
    return sum / reviews.length;
  }

  void _submitReview() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _showRatingError = _userRating == 0;
      _commentError = _reviewController.text.trim().isEmpty
          ? l10n.pleaseAddRatingAndReview
          : null;
    });

    // لو في أي error، نوقف
    if (_showRatingError || _commentError != null) {
      return;
    }

    // لو كل حاجة تمام، نضيف الـ review
    setState(() {
      reviews.insert(
        0,
        Review(
          username: 'You',
          rating: _userRating,
          comment: _reviewController.text,
          date: DateTime.now(),
        ),
      );
      _reviewController.clear();
      _userRating = 0;
      _showRatingError = false;
      _commentError = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.reviewSubmittedSuccessfully),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.onSurface,
                          width: 1.5.w,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.ratingAndReviews,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dish Name
                      Text(
                        'Chicken Fried Rice',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Average Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 48.sp,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < averageRating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: colorScheme.primary,
                                    size: 28.sp,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Write a Review Section
                      Text(
                        l10n.writeAReview,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Star Rating Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _userRating = index + 1.0;
                                    _showRatingError =
                                        false; // إخفاء الـ error لما يختار rating
                                  });
                                },
                                child: Icon(
                                  index < _userRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: index < _userRating
                                      ? colorScheme.primary
                                      : _showRatingError
                                      ? colorScheme.error
                                      : colorScheme.onSurface.withOpacity(0.4),
                                  size: 32.sp,
                                ),
                              );
                            }),
                          ),
                          // رسالة الـ error للـ rating
                          if (_showRatingError)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h, left: 4.w),
                              child: Text(
                                l10n.pleaseAddRatingAndReview,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.error,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Review Text Field with validation
                      AppTextField(
                        controller: _reviewController,
                        hintText: l10n.shareYourExperience,
                        maxLines: 3,
                        errorText: _commentError,
                        onChanged: (value) {
                          // إخفاء الـ error لما المستخدم يبدأ يكتب
                          if (_commentError != null &&
                              value.trim().isNotEmpty) {
                            setState(() {
                              _commentError = null;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Submit Button
                      AppButton(
                        onPressed: _submitReview,
                        text: l10n.submitReview,
                      ),
                      SizedBox(height: 24.h),

                      // User Reviews Header
                      Text(
                        l10n.userReviews(reviews.length.toString()),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Reviews List
                      ...reviews.map((review) => ReviewCard(review: review)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: colorScheme.surfaceVariant,
                child: Icon(
                  Icons.person,
                  color: colorScheme.onSurfaceVariant,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                review.username,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: colorScheme.primary,
                size: 20.sp,
              );
            }),
          ),
          SizedBox(height: 8.h),
          Text(
            review.comment,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}