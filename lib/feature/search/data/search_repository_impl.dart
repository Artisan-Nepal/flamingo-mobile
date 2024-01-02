// ignore_for_file: unused_field
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/search/data/local/search_local.dart';
import 'package:flamingo/feature/search/data/remote/search_remote.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocal _wishlistLocal;
  final SearchRemote _wishlistRemote;

  SearchRepositoryImpl({
    required SearchLocal wishlistLocal,
    required SearchRemote wishlistRemote,
    required AuthRepository authRepository,
  })  : _wishlistLocal = wishlistLocal,
        _wishlistRemote = wishlistRemote;
}
