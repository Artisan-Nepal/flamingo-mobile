import 'package:flamingo/data/data.dart';
import 'package:flamingo/navigation/navigation_route_names.dart';

class NavigationService {
  final LocalStorageClient _sharedPrefManager;

  NavigationService({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  late String initialRoute;

  Future<void> getInitialRoute() async {
    final isLoggedIn = await _getIsLoggedIn();
    final isFirstTime = await _getIsFirstTime();
    final continuedAsGuest = await _getContinuedAsGuest();

    if (isFirstTime) {
      initialRoute = NavigationRouteNames.onBoarding;
    } else if (isLoggedIn || continuedAsGuest) {
      initialRoute = NavigationRouteNames.dashboard;
    } else {
      initialRoute = NavigationRouteNames.login;
    }
    print('initital route set to ' + initialRoute);
  }

  Future<bool> _getIsLoggedIn() async {
    return await _sharedPrefManager.containsKey(LocalStorageKeys.accessToken);
  }

  Future<bool> _getIsFirstTime() async {
    return await _sharedPrefManager.getBool(LocalStorageKeys.isFirstTime) ??
        true;
  }

  Future<bool> _getContinuedAsGuest() async {
    return (await _sharedPrefManager.containsKey(LocalStorageKeys.guestId));
  }
}
