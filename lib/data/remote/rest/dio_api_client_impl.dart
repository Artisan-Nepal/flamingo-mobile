import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flamingo/data/data.dart';
import 'package:flamingo/shared/shared.dart' hide Response;

class DioApiClientImpl implements ApiClient {
  late Dio dio;
  final LocalStorageClient _sharedPrefManager;

  DioApiClientImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _requestInterceptorToAttachAccessToken,
      ),
    );
  }

  @override
  Future<ApiResponse> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      var response = await dio.get(
        path,
        options: Options(headers: headers),
        queryParameters: queryParams,
      );
      return _returnResponse(response);
    } catch (e) {
      debugPrint(
          'API Error | Method: GET | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await dio.post(
        path,
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return _returnResponse(response);
    } catch (e) {
      debugPrint(
          'API Error | Method: POST | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await dio.put(
        path,
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return _returnResponse(response);
    } catch (e) {
      debugPrint(
          'API Error | Method: PUT | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await dio.patch(
        path,
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return _returnResponse(response);
    } catch (e) {
      debugPrint(
          'API Error | Method: PATCH | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> delete(
    String path, {
    Map<String, String>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await dio.delete(
        path,
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return _returnResponse(response);
    } catch (e) {
      debugPrint(
          'API Error | Method: DELETE | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> multipartRequest(
    String path, {
    Map<String, dynamic> data = const {},
    Map<String, String>? headers,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      var response = await dio.post(
        path,
        data: FormData.fromMap(data),
        onSendProgress: onSendProgress,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      debugPrint(
          'API Error | Method: Multipart Request | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  ApiResponse _returnResponse(Response response) {
    return ApiResponse.fromJson(response.data);
  }

  _requestInterceptorToAttachAccessToken(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken =
        await _sharedPrefManager.getString(LocalStorageKeys.accessToken);
    if (accessToken != null) {
      options.headers['Authorization'] = "Bearer $accessToken";
    }
    handler.next(options);
  }
}
