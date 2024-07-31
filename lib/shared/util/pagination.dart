import 'package:flamingo/data/data.dart';
import 'package:flamingo/shared/shared.dart';

bool incrementPage(Response<FetchResponse<dynamic>> response) {
  return response.hasCompleted && response.data?.metadata.next != null;
}
