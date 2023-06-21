import 'package:dio/dio.dart';
import '../config.dart';

class LoginResponse {
  LoginResponse({
    required this.status,
    required this.token,
    required this.error,
    required this.errorDetail,
  });

  int status;
  String? token;
  String? error;
  String? errorDetail;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        token: json["token"],
        error: json["error"],
        errorDetail: json["errorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "error": error,
        "errorDetail": errorDetail,
      };
}

class ApiService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        '$_baseUrl/app/login',
        data: {'user': email, 'password': password},
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}
