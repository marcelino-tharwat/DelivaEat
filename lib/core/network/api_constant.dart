class ApiConstant {
  static const String baseUrl = 'http://192.168.1.6:5000/api/';
  static const String loginUrl = 'auth/login';
  static const String signupUserUrl = 'auth/register';
  static const String signupRiderUrl = 'rider/register';
  static const String signupMerchantUrl = 'merchant/register';
  static const String uploadImageUrl = 'upload/image';
  static const String forgetPasswordUrl = 'auth/password/request';
  static const String resetPasswordUrl = 'auth/password/reset';
  static const String verifyCodeUrl = 'auth/password/verify';
  
  // Home endpoints
  static const String homeUrl = 'home';
  static const String categoriesUrl = 'home/categories';
  static const String offersUrl = 'home/offers';
  static const String restaurantsUrl = 'home/restaurants';
  static const String restaurantsByCategoryUrl = 'home/restaurants/by-category';
  static const String bestSellingFoodsUrl = 'home/foods/best-selling';
  static const String foodsByRestaurantUrl = 'home/foods/by-restaurant';
  static const String toggleFavoriteUrl = 'home/restaurants/favorite';
  static const String toggleFoodFavoriteUrl = 'home/foods/favorite';
  
  // Search endpoints
  static const String searchUrl = 'search';
  static const String searchSuggestionsUrl = 'search/suggestions';
  static const String popularSearchesUrl = 'search/popular';
}
