class ApiResponse {
  final dynamic data;
  final int statusCode;
  final dynamic message;

  ApiResponse({
    required this.data,
    required this.statusCode,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
        data: json['data'],
        statusCode: int.parse(json['statusCode'].toString()),
        message: json['message']);
  }
}
