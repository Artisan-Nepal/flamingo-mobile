import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flamingo/data/data.dart';
import 'package:flamingo/shared/shared.dart' hide Response;

class DioApiClientImpl implements ApiClient {
  late Dio dio;

  /// Separate client (no interceptors) used only to call /auth/refresh, so the
  /// refresh request itself never re-enters the 401 handling below.
  late Dio _refreshDio;

  final SecureTokenStore _tokenStore;

  /// Called only when the session can no longer be recovered (refresh token is
  /// missing/expired/revoked). The data layer stays UI-agnostic: the app wires
  /// this up (in DI) to route the user back to login.
  final Future<void> Function()? _onUnauthorized;

  /// Single-flight guard: if several requests 401 at once, only one refresh runs.
  Future<bool>? _refreshInFlight;

  DioApiClientImpl({
    required SecureTokenStore tokenStore,
    Future<void> Function()? onUnauthorized,
  })  : _tokenStore = tokenStore,
        _onUnauthorized = onUnauthorized {
    final options = BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
    dio = Dio(options);
    _refreshDio = Dio(options);

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

  // A 401 on a request we sent *authenticated* means the access token is stale
  // (short-lived tokens expire; or it was signed by a different backend, e.g.
  // after pointing the app from local Docker to AWS). First try to silently
  // refresh the access token and replay the request - so the user never notices.
  // Only if the refresh itself fails (no/expired/revoked refresh token) do we
  // clear the session and route to login.
  //
  // Scoped to the authenticated case (an Authorization header was attached) so
  // public-endpoint 401s - e.g. a wrong OTP on the login screen - are left alone.
  void _errorInterceptorToHandleExpiredSession(
      DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final is401 = err.response?.statusCode == 401;
    final wasAuthenticated = req.headers.containsKey('Authorization');
    final alreadyRetried = req.extra['__retriedAfterRefresh'] == true;

    if (!is401 || !wasAuthenticated || alreadyRetried) {
      return handler.next(err);
    }

    final refreshed = await _refreshAccessToken();
    if (!refreshed) {
      // Session unrecoverable -> clear both tokens and hand off to login.
      // Fire-and-forget the navigation (its future only completes once the
      // login route is popped, which would otherwise stall the interceptor).
      await _tokenStore.clearSession();
      _onUnauthorized?.call();
      return handler.next(err);
    }

    // Replay the original request once with the fresh access token.
    try {
      req.extra['__retriedAfterRefresh'] = true;
      final newToken = await _tokenStore.getToken();
      req.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(req);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e is DioException ? e : err);
    }
  }

  // Exchanges the refresh token for a new access token via /auth/refresh, using
  // the interceptor-free [_refreshDio]. Single-flight: concurrent 401s share one
  // in-flight refresh. Returns false if there's no refresh token or the call
  // fails (expired/revoked) - the caller then logs out.
  Future<bool> _refreshAccessToken() {
    return _refreshInFlight ??=
        _performRefresh().whenComplete(() => _refreshInFlight = null);
  }

  Future<bool> _performRefresh() async {
    final refreshToken = await _tokenStore.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final res = await _refreshDio.post(
        ApiUrls.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = res.data['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      if (newAccessToken == null) return false;
      await _tokenStore.setToken(newAccessToken);
      if (newRefreshToken != null) {
        await _tokenStore.setRefreshToken(newRefreshToken);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
