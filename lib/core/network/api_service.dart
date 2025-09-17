import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_res_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstant.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // @GET('/tasks')
  // Future<List<Task>> getTasks();
  @POST(ApiConstant.loginUrl)
  Future<LoginResModel> login(@Body() LoginReqModel loginReqModel);

}

