# Hero Tag Fix TODO

- [x] Update Hero tag in lib/features/home/ui/widget/favorite_restaurant_list.dart from index-based to ID-based ('restaurant_$restaurantId')
- [x] Update Hero tag in lib/features/home/ui/widget/top_rated_resturant_list.dart from 'top_restaurant_$index' to 'restaurant_${restaurant['id']}'
- [x] Update Hero tag in lib/features/home/ui/widget/food_card_list.dart from 'food_$index' to 'food_$foodId'
- [x] Test the app: Run 'flutter run' and navigate/tap items in home page lists to verify no duplicate Hero tag errors in console

# Favorites Page Implementation

- [x] Add favoritesPage route to lib/core/routing/routes.dart
- [x] Add GoRoute for favoritesPage in lib/core/routing/app_router.dart
- [x] Create lib/features/home/ui/favorites_page.dart with categories for restaurants and foods
- [x] Update _handleSeeAll in lib/features/home/ui/home_page.dart to navigate to favoritesPage when section is favorites
- [x] Test navigation to favorites page from home page "عرض المزيد" button
