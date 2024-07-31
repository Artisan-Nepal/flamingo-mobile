import 'package:flamingo/data/data.dart';
import 'package:flamingo/shared/shared.dart';

bool incrementPage(Response<FetchResponse<dynamic>> response) {
  int currentPage = response.data?.metadata.currentPage ?? 0;
  int totalPage = response.data?.metadata.total ?? 0;
  return response.hasCompleted && currentPage <= totalPage;
}
