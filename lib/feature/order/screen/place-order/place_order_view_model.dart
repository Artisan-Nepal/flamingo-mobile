import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';
import 'package:flamingo/feature/order/data/model/apply_coupon_response.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_request.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_response.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/saved_coupon.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/constant/delivery.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class PlaceOrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  PlaceOrderViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  int _orderIndex = 0;
  ShippingMethod? _selectedShippingMethod;
  PaymentMethod? _selectedPaymentMethod;
  Address? _selectedShippingAddress;
  Address? _selectedBillingAddress;
  Response _placeOrderUseCase = Response();
  Response _khaltiInitiateUseCase = Response();
  Response _applyCouponUseCase = Response();
  ApplyCouponResponse? _appliedCoupon;
  List<SavedCoupon> _savedCoupons = [];
  List<CartItem> _items = [];

  int get orderIndex => _orderIndex;
  ShippingMethod? get selectedShippingMethod => _selectedShippingMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  Address? get selectedShippingAddress => _selectedShippingAddress;
  Address? get selectedBillingAddress => _selectedBillingAddress;
  Response get placeOrderUseCase => _placeOrderUseCase;
  Response get khaltiInitiateUseCase => _khaltiInitiateUseCase;
  Response get applyCouponUseCase => _applyCouponUseCase;
  ApplyCouponResponse? get appliedCoupon => _appliedCoupon;
  List<SavedCoupon> get savedCoupons => _savedCoupons;
  List<CartItem> get items => _items;

  void setCartItems(List<CartItem> items) {
    _items = items;
  }

  void setPlaceOrderUseCase(Response response) {
    _placeOrderUseCase = response;
    notifyListeners();
  }

  void setKhaltiInitiateUseCase(Response response) {
    _khaltiInitiateUseCase = response;
    notifyListeners();
  }

  setSelectedShippingAddress(Address address) {
    _selectedShippingAddress = address;
    notifyListeners();
  }

  setSelectedBillingAddress(Address address) {
    _selectedBillingAddress = address;
    notifyListeners();
  }

  incOrderIndex() {
    _orderIndex++;
    notifyListeners();
  }

  setOrderIndex(int index) {
    _orderIndex = index;
    notifyListeners();
  }

  decOrderIndex() {
    _orderIndex--;
    notifyListeners();
  }

  setSelectedShippingMethod(ShippingMethod? shippingMethod) {
    _selectedShippingMethod = shippingMethod;
    notifyListeners();
  }

  setSelectedPaymentMethod(PaymentMethod? paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  // Delivery charge for one pickup from one store. Standard shipping is priced
  // by delivery city (Rs 100, or Rs 150 for extended zones); other methods use
  // their flat cost. A courier makes one pickup per store, so the total charge
  // scales with the number of distinct stores in the cart, not the item count.
  int get deliveryChargePerStore {
    final method = _selectedShippingMethod;
    if (method == null) return 0;
    if (method.code == kStandardShippingCode) {
      return getDeliveryChargeForCity(_selectedShippingAddress?.area.city.name);
    }
    return method.cost;
  }

  int getShippingFee() {
    return deliveryChargePerStore;
  }

  // Checkout "apply code" preview - just validates and shows what the
  // discount would be. The actual reservation happens server-side when the
  // order is placed (placeOrder/initiateKhaltiOrder pass the same code
  // through), so this can be safely re-applied or abandoned with no side effects.
  Future<void> applyCoupon(String code) async {
    if (code.trim().isEmpty) return;
    try {
      _applyCouponUseCase = Response.loading();
      notifyListeners();
      final response = await _orderRepository.validateCoupon(code.trim());
      _appliedCoupon = response;
      _applyCouponUseCase = Response.complete(response);
      notifyListeners();
    } catch (exception) {
      _appliedCoupon = null;
      _applyCouponUseCase = Response.error(exception);
      notifyListeners();
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _applyCouponUseCase = Response();
    notifyListeners();
  }

  // Suggestion chips shown above the coupon field - codes the customer has
  // already redeemed (e.g. from a home promo banner). Best-effort: failures
  // just leave the list empty, no error surfaced (this is a convenience, not
  // a required step in checkout).
  Future<void> getSavedCoupons() async {
    try {
      _savedCoupons = await _orderRepository.getSavedCoupons();
      notifyListeners();
    } catch (_) {
      _savedCoupons = [];
    }
  }

  Future<void> placeOrder() async {
    try {
      setPlaceOrderUseCase(Response.loading());
      await _orderRepository.placeOrder(
        CreateOrderRequest(
          billingAddressId: _selectedBillingAddress!.id,
          shippingAddressId: _selectedShippingAddress!.id,
          paymentMethodCode: _selectedPaymentMethod!.code,
          shippingMethodId: _selectedShippingMethod!.id,
          couponCode: _appliedCoupon?.code,
        ),
      );
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      _logOrderActvity();
      setPlaceOrderUseCase(Response.complete(null));
    } catch (exception) {
      setPlaceOrderUseCase(Response.error(exception));
    }
  }

  // Step 1 of Khalti checkout: reserves stock and returns a Khalti
  // payment_url for the caller to open in a WebView. Persists the pidx
  // locally so a dangling payment can be retried on next app resume even if
  // the app is killed before confirmKhaltiOrder is called (see
  // KhaltiReconciler).
  Future<KhaltiInitiateResponse?> initiateKhaltiOrder() async {
    try {
      setKhaltiInitiateUseCase(Response.loading());
      final response = await _orderRepository.initiateKhaltiOrder(
        KhaltiInitiateRequest(
          billingAddressId: _selectedBillingAddress!.id,
          shippingAddressId: _selectedShippingAddress!.id,
          paymentMethodCode: _selectedPaymentMethod!.code,
          shippingMethodId: _selectedShippingMethod!.id,
          couponCode: _appliedCoupon?.code,
        ),
      );
      await locator<OrderLocal>().savePendingKhaltiPidx(
        response.pidx,
        DateTime.parse(response.expiresAt),
      );
      setKhaltiInitiateUseCase(Response.complete(response));
      return response;
    } catch (exception) {
      setKhaltiInitiateUseCase(Response.error(exception));
      return null;
    }
  }

  // Step 2 of Khalti checkout: called once the WebView detects the
  // return_url redirect (or later, by KhaltiReconciler, if that call never
  // fired). Safe to call more than once for the same pidx.
  Future<void> confirmKhaltiOrder(String pidx) async {
    try {
      setPlaceOrderUseCase(Response.loading());
      await _orderRepository.confirmKhaltiOrder(pidx);
      await locator<OrderLocal>().clearPendingKhaltiPidx();
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      _logOrderActvity();
      setPlaceOrderUseCase(Response.complete(null));
    } catch (exception) {
      setPlaceOrderUseCase(Response.error(exception));
    }
  }

  _logOrderActvity() async {
    for (CartItem item in _items) {
      await locator<CreateActivityViewModel>().createUserActivity(
        productId: item.product.id,
        activityType: UserActivityType.orderProduct,
      );
    }
  }

  int get subTotal {
    int price = 0;
    for (CartItem cart in items) {
      price = price + (cart.productVariant.price * cart.quantity);
    }
    return price;
  }

  int get distinctStoreCount {
    return items.map((item) => item.product.sellerId).toSet().length;
  }

  int get shippingCost {
    return deliveryChargePerStore * distinctStoreCount;
  }

  int get discountAmount {
    return _appliedCoupon?.discountAmount ?? 0;
  }

  int get orderTotal {
    return subTotal + shippingCost - discountAmount;
  }

  String get orderItemIds {
    return items.map((i) => i.productVariant.id).join(',');
  }

  String get orderItemNames {
    return items.map((i) => i.product.title).join(',');
  }
}
