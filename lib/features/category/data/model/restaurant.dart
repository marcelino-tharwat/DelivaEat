class Restaurant {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final int deliveryFee;
  final int? originalDeliveryFee;
  final String cuisine;
  final String? discount;
  final bool isFavorite;
  final bool isPromoted;
  final List<String> tags;
  final int minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.originalDeliveryFee,
    required this.cuisine,
    this.discount,
    required this.isFavorite,
    this.isPromoted = false,
    required this.tags,
    required this.minimumOrder,
  });
}
