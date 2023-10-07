import 'package:flamingo/shared/helper/helper.dart';

abstract class ApiClient {
  Future<ApiResponse> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });

  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });

  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });

  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });

  Future<ApiResponse> delete(
    String path, {
    Map<String, String>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });

  Future<ApiResponse> multipartRequest(
    String path, {
    Map<String, dynamic> data,
    Map<String, String>? headers,
    Function(int, int)? onSendProgress,
  });
}
