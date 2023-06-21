import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:transporte_app/models/InspectorModel.dart';

import '../config.dart';

class ResponseData {
  int? status;
  String? token;
  List<InspectorModel>? data;
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
          .map((tagJson) => InspectorModel.fromJson(tagJson))
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

class InspectorService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<List<InspectorModel>> getInspector(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/inspector/$search',
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

  Future<dynamic> getInspectorById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/inspector/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addInspector(InspectorModel inspector) async {
    try {
      Response response = await _dio.post('$_baseUrl/inspector/',
          data: inspector.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> removeInspector(String id) async {
    try {
      Response response = await _dio.delete('$_baseUrl/inspector/$id',
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> editDriver(InspectorModel inspector) async {
    try {
      Response response = await _dio.put('$_baseUrl/inspector/${inspector.id}',
          data: inspector.toJson(),
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
