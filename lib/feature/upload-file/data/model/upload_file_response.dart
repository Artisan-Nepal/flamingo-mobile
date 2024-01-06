class UploadFileResponse {
  final String id;
  final String filename;
  final String url;
  final String mimetype;

  UploadFileResponse({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimetype,
  });

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      id: json['id'],
      url: json['url'],
      filename: json['filename'],
      mimetype: json['mimetype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'filename': filename,
      'mimetype': mimetype,
    };
  }

  static List<UploadFileResponse> fromJsonList(dynamic json) =>
      List<UploadFileResponse>.from(
        json.map(
          (data) => UploadFileResponse.fromJson(data),
        ),
      );
}
