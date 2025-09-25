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
  @DioResponseType(ResponseType.json) // <-- أضف هذا السطر
  Future<Map<String, dynamic>> resetPassword(
    @Body() ResetPasswordRequestBody resetPasswordRequestBody,
  );

  // Home endpoints
  @GET(ApiConstant.homeUrl)
  Future<HomeResponseModel> getHomeData(@Query('lang') String lang);

  @GET(ApiConstant.categoriesUrl)
  Future<ApiResponseModel<List<CategoryModel>>> getCategories(@Query('lang') String lang);

  @GET(ApiConstant.offersUrl)
  Future<ApiResponseModel<List<OfferModel>>> getOffers(@Query('lang') String lang);

  @GET(ApiConstant.restaurantsUrl)
  Future<ApiResponseModel<List<RestaurantModel>>> getRestaurants(
    @Query('type') String type,
    @Query('limit') int limit,
    @Query('lang') String lang,
  );

  @GET(ApiConstant.bestSellingFoodsUrl)
  Future<ApiResponseModel<List<FoodModel>>> getBestSellingFoods(
    @Query('limit') int limit,
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
  );

  @GET(ApiConstant.popularSearchesUrl)
  Future<PopularSearchesResponseModel> getPopularSearches(
    @Query('lang') String lang,
    @Query('limit') int limit,
  );
}
