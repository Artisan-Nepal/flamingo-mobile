import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flamingo/data/data.dart';
import 'package:flamingo/shared/shared.dart' hide Response;

class DioApiClientImpl implements ApiClient {
  late Dio dio;
  final SecureTokenStore _tokenStore;

  /// Called when an *authenticated* request comes back 401 (the stored token is
  /// no longer valid). The data layer stays UI-agnostic: the app wires this up
  /// (in DI) to route the user back to login. See [_errorInterceptorToHandleExpiredSession].
  final Future<void> Function()? _onUnauthorized;

  DioApiClientImpl({
    required SecureTokenStore tokenStore,
    Future<void> Function()? onUnauthorized,
  })  : _tokenStore = tokenStore,
        _onUnauthorized = onUnauthorized {
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
        onError: _errorInterceptorToHandleExpiredSession,
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

      return _returnResponse(response);
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
    final accessToken = await _tokenStore.getToken();
    if (accessToken != null) {
      options.headers['Authorization'] = "Bearer $accessToken";
    }
    handler.next(options);
  }

  // A 401 on a request we sent *authenticated* means the stored token is no
  // longer valid - expired, revoked, or signed by a different backend (e.g.
  // after pointing the app from the local Docker API to AWS, whose JWT secret
  // differs, an old token fails verification). Clear it and hand off to the app
  // to route back to login, instead of surfacing the raw "Access token is
  // invalid" API error on whatever screen made the call.
  //
  // Scoped to the authenticated case (an Authorization header was attached) so
  // public-endpoint 401s - e.g. a wrong OTP on the login screen - never trigger
  // a spurious "session expired" redirect. The original error still propagates.
  void _errorInterceptorToHandleExpiredSession(
      DioException err, ErrorInterceptorHandler handler) async {
    final wasAuthenticated =
        err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && wasAuthenticated) {
      await _tokenStore.removeToken();
      // Fire-and-forget: don't await navigation (its future only completes when
      // the login route is later popped), which would stall the interceptor.
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}
