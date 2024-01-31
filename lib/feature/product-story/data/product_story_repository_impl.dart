// ignore_for_file: unused_field

import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product-story/data/product_story_repository.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProducStoryRepositoryImpl implements ProductStoryRepository {
  final ProductLocal _productLocal;
  final ProductRemote _productRemote;
  final AuthRepository _authRepository;

  ProducStoryRepositoryImpl({
    required ProductLocal productLocal,
    required ProductRemote productRemote,
    required AuthRepository authRepository,
  })  : _productLocal = productLocal,
        _productRemote = productRemote,
        _authRepository = authRepository;
}
