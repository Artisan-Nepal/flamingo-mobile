import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_screen.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/order_detail_screen.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_screen.dart';
import 'package:flamingo/shared/helper/navigation_helper.dart';

// Shared by both push-notification taps (NotificationService, no
// BuildContext available) and the in-app inbox (NotificationInboxScreen).
// The two sources hand slightly different shapes: a push `data` payload is
// {type: 'order'|'promo', orderId?}, while a persisted inbox `metadata` row
// is {orderId?} / {orderIds?} and may have no `type` at all (older rows).
// So only `promo` is matched explicitly; everything else is treated as an
// order, which is what every non-promo notification this app sends is.
class NotificationRouter {
  static Future<void> route(Map<String, dynamic> data) async {
    if (data['type'] == 'promo') {
      // No banner detail beyond its id reaches the app here (see
      // PromoBannerService.notify) - Home already surfaces the active
      // banners/coupons, so land there rather than guessing a deep link.
      await NavigationHelper.pushAndReplaceAllGlobal(const DashboardScreen());
      return;
    }
    await _routeToOrder(data['orderId'] as String?);
  }

  static Future<void> _routeToOrder(String? orderId) async {
    // Order endpoints require a signed-in customer - an anonymous install
    // wouldn't have received an order push to begin with, but a promo
    // broadcast (topic, no login required) could still reach one, so guard
    // rather than assume.
    if (!locator<AuthViewModel>().isLoggedIn) return;

    if (orderId != null) {
      try {
        final response = await locator<OrderRepository>().getUserOrders();
        Order? match;
        for (final order in response.rows) {
          if (order.id == orderId) {
            match = order;
            break;
          }
        }
        if (match != null) {
          await NavigationHelper.pushGlobal(OrderDetailScreen(order: match));
          return;
        }
      } catch (_) {
        // Falls through to the listing below.
      }
    }
    await NavigationHelper.pushGlobal(const OrderListingScreen());
  }
}
