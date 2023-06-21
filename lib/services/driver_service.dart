import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:transporte_app/models/DriverModel.dart';

import '../config.dart';

class ResponseData {
  int? status;
  String? token;
  List<DriverModel>? data;
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
      data =
          tagObjsJson.map((tagJson) => DriverModel.fromJson(tagJson)).toList();
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

class DriverService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<List<DriverModel>> getDriver(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/driver/$search',
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

  Future<dynamic> getDriverById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/driver/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addDriver(DriverModel driver) async {
    try {
      Response response = await _dio.post('$_baseUrl/driver/',
          data: driver.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> removeDriver(String id) async {
    try {
      Response response = await _dio.delete('$_baseUrl/driver/$id',
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> editDriver(DriverModel driver) async {
    try {
      Response response = await _dio.put('$_baseUrl/driver/${driver.id}',
          data: driver.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}
