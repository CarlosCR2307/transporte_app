import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:transporte_app/models/DealershipModel.dart';

import '../config.dart';

class ResponseData {
  int? status;
  String? token;
  List<DealershipModel>? data;
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
          .map((tagJson) => DealershipModel.fromJson(tagJson))
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

class DealershipService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<List<DealershipModel>> getDealership(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/dealership/$search',
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

  Future<dynamic> getDealershipById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/dealership/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addDealership(DealershipModel dealship) async {
    try {
      Response response = await _dio.post('$_baseUrl/dealership/',
          data: dealship.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> removeDealership(String id) async {
    try {
      Response response = await _dio.delete('$_baseUrl/dealership/$id',
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> editDealership(DealershipModel dealship) async {
    try {
      Response response = await _dio.put('$_baseUrl/dealership/${dealship.id}',
          data: dealship.toJson(),
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
