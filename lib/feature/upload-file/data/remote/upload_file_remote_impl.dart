import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_request.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/upload-file/data/remote/upload_file_remote.dart';

class UploadFileRemoteImpl implements UploadFileRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  UploadFileRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<UploadFileResponse> upload(UploadFileRequest request) async {
    final apiResponse = await _apiClient.multipartRequest(ApiUrls.uploadFiles,
        data: await request.toJson());
    return UploadFileResponse.fromJson(apiResponse.data);
  }
}
