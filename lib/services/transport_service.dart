import 'package:dio/dio.dart';
import 'package:transporte_app/models/TransportModel.dart';

import '../config.dart';

class ResponseData {
  int? status;
  String? token;
  List<TransportModel>? data;
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
          .map((tagJson) => TransportModel.fromJson(tagJson))
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

class TransportService {
  final Dio _dio = Dio();
  final _baseUrl = baseURL();

  Future<List<TransportModel>> getTransport(String? search) async {
    ResponseData data;
    try {
      Response response = await _dio.get(
        '$_baseUrl/transport/$search',
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

  Future<dynamic> getTransportById(String? id) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/transport/one/$id',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> getTransportByNFC(String? nfc) async {
    try {
      Response response = await _dio.get(
        '$_baseUrl/transport/tag/$nfc',
      );
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> addTransport(TransportModel transport) async {
    try {
      Response response = await _dio.post('$_baseUrl/transport/',
          data: transport.toJson(),
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> removeTransport(String id) async {
    try {
      Response response = await _dio.delete('$_baseUrl/transport/$id',
          options: Options(contentType: 'application/json'));
      //returns the successful user data json object
      //return response.data;
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> editTransport(TransportModel transport) async {
    try {
      Response response = await _dio.put('$_baseUrl/transport/${transport.id}',
          data: transport.toJson(),
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
