import 'package:dio/dio.dart';
import 'package:transporte_app/models/OperationalModel.dart';

import '../config.dart';
import '../models/operationaldetail_model.dart';

class ResponseData {
  int? status;
  String? token;
  List<OperationalModel>? data;
  String? error;
  String? errorDetail;

  ResponseData({
    required this.status,
    required this.token,
    this.data,
    this.error,
    this.errorDetail,
  });

  ResponseData.fromJson(Map<String, dynamic> jsonn) {
    status = jsonn['status'];
    token = jsonn['token'];
    if (jsonn['data'] != null) {
      var tagObjsJson = jsonn['data'] as List;
      data = tagObjsJson
          .map((tagJson) => OperationalModel.fromJson(tagJson))
          .toList();
    }
    error = jsonn['error'];
    errorDetail = jsonn['errorDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['data'] = data;
    data['error'] = error;
    data['errorDetail'] = errorDetail;

    return data;
  }
}

class ResponseDetailData {
  int? status;
  String? token;
  List<OperationaldetailModel>? data;
  String? error;
  String? errorDetail;

  ResponseDetailData({
    required this.status,
    required this.token,
    this.data,
    this.error,
    this.errorDetail,
  });

  ResponseDetailData.fromJson(Map<String, dynamic> jsonn) {
    status = jsonn['status'];
    token = jsonn['token'];
    if (jsonn['data'] != null) {
      var tagObjsJson = jsonn['data'] as List;
      data = tagObjsJson
          .map((tagJson) => OperationaldetailModel.fromJson(tagJson))
          .toList();
    }
    error = jsonn['error'];
    errorDetail = jsonn['errorDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['data'] = data;
    data['error'] = error;
    data['errorDetail'] = errorDetail;

    return data;
  }
}

class OperationalService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<List<OperationalModel>> getOperational(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/operational/$search',
      );
      //returns the successful user data json object
      //return response.data;
      data = ResponseData.fromJson(response.data);
      if (data.data?.isEmpty ?? false) return [];
      return data.data ?? [];
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<List<OperationalModel>> getOperationalByUser(String? id) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/operational/user/$id',
      );
      //returns the successful user data json object
      //return response.data;
      data = ResponseData.fromJson(response.data);
      if (data.data?.isEmpty ?? false) return [];
      return data.data ?? [];
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> getOperationalById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/operational/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addOperational(OperationalModel operational) async {
    try {
      Response response = await _dio.post('$_baseUrl/operational/',
          data: operational.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> removeOperational(String id) async {
    try {
      Response response = await _dio.delete('$_baseUrl/operational/$id',
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> editOperational(OperationalModel operational) async {
    try {
      Response response = await _dio.put(
          '$_baseUrl/operational/${operational.id}',
          data: operational.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  //DETAILS
  Future<List<OperationaldetailModel>> getOperationalDetail(
      String? search) async {
    ResponseDetailData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/operational/detail/$search',
      );
      //returns the successful user data json object
      //return response.data;
      data = ResponseDetailData.fromJson(response.data);
      if (data.data?.isEmpty ?? false) return [];
      return data.data ?? [];
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> getOperationalDetailById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/operational/detail/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addOperationalDetail(
      OperationaldetailModel operationalDetail) async {
    try {
      Response response = await _dio.post('$_baseUrl/operational/detail/',
          data: operationalDetail.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  //REPORT
  Future<List<OperationalModel>> getOperationalReport(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/app/report/operational/$search',
      );
      //returns the successful user data json object
      //return response.data;
      data = ResponseData.fromJson(response.data);
      if (data.data?.isEmpty ?? false) return [];
      return data.data ?? [];
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<List<OperationaldetailModel>> getOperationalDetailReport(
      String? id, String? dni, String? plateNumber) async {
    ResponseDetailData data;
    try {
      Response response = await _dio.post(
          '$_baseUrl/app/report/operational/detail/',
          data: {"id": id, "dni": dni, "plateNumber": plateNumber},
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      data = ResponseDetailData.fromJson(response.data);
      if (data.data?.isEmpty ?? false) return [];
      return data.data ?? [];
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}
