import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/reviews/cubit/reviews_cubit.dart';
import 'package:deliva_eat/features/reviews/cubit/reviews_state.dart';
import 'package:deliva_eat/features/reviews/data/models/review_model.dart';

class RatingReviewsPage extends StatefulWidget {
  final String? title;
  const RatingReviewsPage({super.key, this.title});

  @override
  State<RatingReviewsPage> createState() => _RatingReviewsPageState();
}

class _RatingReviewsPageState extends State<RatingReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _userRating = 0;
  bool _showRatingError = false;
  String? _commentError;

  @override
  void initState() {
    super.initState();
    
  }

  double _averageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (prev, r) => prev + (r.rating));
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

    if (_showRatingError || _commentError != null) {
      return;
    }

    context.read<ReviewsCubit>().submitReview(
      rating: _userRating.toInt(),
      comment: _reviewController.text.trim(),
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
                        widget.title ?? '',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Average Rating
                      BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          if (state is ReviewsLoading ||
                              state is ReviewsInitial) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 48.sp,
                                  width: 48.sp,
                                  child: const CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }
                          final items = state is ReviewsLoaded
                              ? state.items
                              : <ReviewModel>[];
                          final avg = _averageRating(items);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                avg.toStringAsFixed(1),
                                style: textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.sp,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < avg.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: colorScheme.primary,
                                    size: 28.sp,
                                  );
                                }),
                              ),
                            ],
                          );
                        },
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
                      BlocConsumer<ReviewsCubit, ReviewsState>(
                        listener: (context, state) {
                          if (state is ReviewSubmitted) {
                            _reviewController.clear();
                            setState(() {
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
                          } else if (state is ReviewsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isSubmitting = state is ReviewSubmitting;
                          return AppButton(
                            onPressed: isSubmitting ? null : _submitReview,
                            text: isSubmitting
                                ? l10n.loading
                                : l10n.submitReview,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // User Reviews Header
                      BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          final count = state is ReviewsLoaded
                              ? state.items.length
                              : 0;
                          return Text(
                            l10n.userReviews(count.toString()),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Reviews List
                      BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          if (state is ReviewsLoading ||
                              state is ReviewsInitial) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (state is ReviewsError) {
                            return Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Text(
                                state.message,
                                style: textTheme.bodyMedium,
                              ),
                            );
                          }
                          final items = (state is ReviewsLoaded)
                              ? state.items
                              : <ReviewModel>[];
                          if (items.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Text(l10n.noData),
                            );
                          }
                          return Column(
                            children: items
                                .map((r) => ReviewCard(review: r))
                                .toList(),
                          );
                        },
                      ),
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
  final ReviewModel review;

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
                review.userName,
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
                index < (review.rating) ? Icons.star : Icons.star_border,
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
