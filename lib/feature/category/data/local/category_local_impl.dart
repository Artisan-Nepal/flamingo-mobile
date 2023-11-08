import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/category/data/local/category_local.dart';

class CategoryLocalImpl implements CategoryLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  CategoryLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
