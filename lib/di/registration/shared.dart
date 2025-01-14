import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:get_it/get_it.dart';

void registerShared(GetIt locator) {
  locator.registerFactory<LoadMoreViewModel>(
    () => LoadMoreViewModel(),
  );
}
