import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/auth_response.dart';
import 'package:deliva_eat/features/auth/signup/data/models/merchant_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/rider_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/signup_req_model.dart';
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
 
}
