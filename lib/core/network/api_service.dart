import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/auth_response.dart';
import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_request_body.dart';
// import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_response.dart';
import 'package:deliva_eat/features/auth/otp/data/model/verify_code_request.dart';
import 'package:deliva_eat/features/auth/signup/data/models/merchant_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/rider_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/signup_req_model.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';
import 'package:deliva_eat/features/home/data/models/category_model.dart';
import 'package:deliva_eat/features/home/data/models/offer_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart';
import 'package:deliva_eat/features/reviews/data/models/review_list_response.dart';
import 'package:deliva_eat/features/reviews/data/models/review_model.dart';
import 'package:deliva_eat/features/reviews/data/models/review_create_request.dart';
import 'package:deliva_eat/features/restaurant/data/models/restaurant_details_model.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstant.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST(ApiConstant.loginUrl)
  Future<AuthResponse> login(@Body() LoginReqModel loginReqModel);

  @POST(ApiConstant.signupUserUrl)
  Future<AuthResponse> userRegister(@Body() SignupReqModel signupReqModel);

  @POST(ApiConstant.signupRiderUrl)
  Future<AuthResponse> riderRegister(@Body() RiderModel riderModel);

  @POST(ApiConstant.signupMerchantUrl)
  Future<AuthResponse> merchantRegister(@Body() MerchantModel merchantModel);

  @POST(ApiConstant.forgetPasswordUrl)
  Future<ForgotPasswordSuccessResponse> requestPasswordReset(
    @Body() ForgotPasswordReqModel request,
  );

  @POST(ApiConstant.verifyCodeUrl)
  Future<ApiResponse<SuccessData>> verifyResetCode(
    @Body() VerifyCodeRequest request,
  );
@POST(ApiConstant.resetPasswordUrl)
@DioResponseType(ResponseType.json) 
Future<dynamic> resetPassword(
  @Body() ResetPasswordRequestBody resetPasswordRequestBody,
);

  // Home endpoints
  @GET(ApiConstant.homeUrl)
  Future<HomeResponseModel> getHomeData(@Query('lang') String lang);

  @GET(ApiConstant.categoriesUrl)
  Future<HomeResultResponseModel<List<CategoryModel>>> getCategories(@Query('lang') String lang);

  @GET(ApiConstant.offersUrl)
  Future<HomeResultResponseModel<List<OfferModel>>> getOffers(@Query('lang') String lang);

  @GET(ApiConstant.restaurantsUrl)
  Future<HomeResultResponseModel<List<RestaurantModel>>> getRestaurants(
    @Query('type') String type,
    @Query('limit') int limit,
    @Query('lang') String lang,
  );



  @GET(ApiConstant.bestSellingFoodsUrl)
  Future<HomeResultResponseModel<List<FoodModel>>> getBestSellingFoods(
    @Query('limit') int limit,
    @Query('lang') String lang,
  );

  // Foods by restaurant
  @GET(ApiConstant.foodsByRestaurantUrl)
  Future<HomeResultResponseModel<List<FoodModel>>> getFoodsByRestaurant(
    @Query('restaurantId') String restaurantId,
    @Query('limit') int limit,
    @Query('lang') String lang,
    @Query('tab') String? tab,
    @Query('type') String? type,
  );

  // Restaurant details
  @GET(ApiConstant.restaurantDetailsUrl)
  Future<RestaurantDetailsResponse> getRestaurantDetails(
    @Query('restaurantId') String restaurantId,
    @Query('lang') String lang,
  );

  // Search endpoints
  @GET(ApiConstant.searchUrl)
  Future<SearchResponseModel> globalSearch(
    @Query('q') String query,
    @Query('lang') String lang,
    @Query('type') String type,
    @Query('limit') int limit,
    @Query('page') int page,
    @Query('category') String? category,
    @Query('minRating') double? minRating,
    @Query('maxPrice') double? maxPrice,
    @Query('minPrice') double? minPrice,
  );

  @GET(ApiConstant.searchSuggestionsUrl)
  Future<SearchSuggestionsResponseModel> getSearchSuggestions(
    @Query('q') String query,
    @Query('lang') String lang,
    @Query('limit') int limit,
    @Query('category') String? category,
  );

  @GET(ApiConstant.popularSearchesUrl)
  Future<PopularSearchesResponseModel> getPopularSearches(
    @Query('lang') String lang,
    @Query('limit') int limit,
    @Query('category') String? category,
  );

  // Reviews endpoints
  @GET(ApiConstant.reviewsUrl)
  Future<ReviewsListResponse> getReviews(
    @Query('foodId') String? foodId,
    @Query('restaurantId') String? restaurantId,
    @Query('limit') int limit,
    @Query('page') int page,
  );

  @POST(ApiConstant.reviewsUrl)
  Future<HomeResultResponseModel<ReviewModel>> addReview(
    @Body() ReviewCreateRequest request,
  );

  // Toggle restaurant favorite
  @POST(ApiConstant.toggleFavoriteUrl)
  Future<HomeResultResponseModel<RestaurantModel>> toggleRestaurantFavorite(
    @Body() Map<String, dynamic> body,
    @Query('lang') String lang,
  );

  // Cart endpoints
  @POST(ApiConstant.cartAddItemUrl)
  Future<HomeResultResponseModel<CartItemModel>> addItemToCart(
    @Body() AddCartItemRequest request,
    @Query('lang') String lang,
  );

  @GET('cart')
  @DioResponseType(ResponseType.json)
  Future<dynamic> getCart(
    @Query('lang') String lang,
  );

  @PATCH('cart/items/{id}')
  @DioResponseType(ResponseType.json)
  Future<dynamic> updateCartItemQuantity(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('cart/items/{id}')
  @DioResponseType(ResponseType.json)
  Future<dynamic> removeCartItem(
    @Path('id') String id,
  );
}
