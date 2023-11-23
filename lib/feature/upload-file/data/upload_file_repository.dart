import 'package:flamingo/feature/upload-file/data/model/upload_file_request.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';

abstract class UploadFileRepository {
  Future<UploadFileResponse> upload(UploadFileRequest request);
}
