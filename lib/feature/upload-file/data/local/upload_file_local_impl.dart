import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/upload-file/data/local/upload_file_local.dart';

class UploadFileLocalImpl implements UploadFileLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  UploadFileLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
