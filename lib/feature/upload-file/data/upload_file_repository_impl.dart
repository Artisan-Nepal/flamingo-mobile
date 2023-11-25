// ignore_for_file: unused_field

import 'package:flamingo/feature/upload-file/data/local/upload_file_local.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_request.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/upload-file/data/remote/upload_file_remote.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository.dart';

class UploadFileRepositoryImpl implements UploadFileRepository {
  final UploadFileLocal _uploadFileLocal;
  final UploadFileRemote _uploadFileRemote;

  UploadFileRepositoryImpl(
      {required UploadFileLocal uploadFileLocal,
      required UploadFileRemote uploadFileRemote})
      : _uploadFileLocal = uploadFileLocal,
        _uploadFileRemote = uploadFileRemote;

  @override
  Future<UploadFileResponse> upload(UploadFileRequest request) async {
    return await _uploadFileRemote.upload(request);
  }
}
