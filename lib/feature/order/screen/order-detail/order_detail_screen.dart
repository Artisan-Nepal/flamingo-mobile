import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/order_detail_view_model.dart';
import 'package:flamingo/feature/order/screen/order-detail/snippet_order_detail_info.dart';
import 'package:flamingo/feature/order/screen/order-detail/track_order_screen.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_order_item.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _cancellableStatusCodes = ['PENDING', 'PROCESSING'];

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _viewModel = locator<OrderDetailViewModel>();
  bool _cancelled = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<OrderDetailViewModel>(
        builder: (context, viewModel, child) => DefaultScreen(
          appBarTitle: Text('Order ID: ${widget.order.orderId.toString()}'),
          bottomNavigationBar: _buildBottomBar(viewModel),
          child: Column(
            children: [
              // Order and Estimated delivery date
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Ordered on',
                            style: TextStyle(
                                // color: AppColors.primaryColor,
                                ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: themedPrimaryColor(context),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              formatDate(widget.order.createdAt,
                                  format: DateFormatConstant.fullDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.fontSizeLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Est. Delivery on',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: themedPrimaryColor(context),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              formatDate(widget.order.estimatedDelivery,
                                  format: DateFormatConstant.fullDate),
                              style: const TextStyle(
                                fontSize: Dimens.fontSizeLarge,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              // Products Detail
              _buildProductsDetail(),
              // const SizedBox(
              //   height: 20,
              // ),
// Billing Details
              _buildBillingDetails(),
              _buildDivider(),

              // Shipping address
              SnippetOrderDetailInfo(
                label: 'Shipping Address',
                title:
                    '${widget.order.shippingAddress.name}, ${widget.order.shippingAddress.area.name}',
                subtitle:
                    '${widget.order.shippingAddress.fullName}, ${widget.order.shippingAddress.mobileNumber}',
              ),
              _buildDivider(),
              // Billing address
              SnippetOrderDetailInfo(
                label: 'Billing Address',
                title:
                    '${widget.order.billingAddress.name}, ${widget.order.billingAddress.area.name}',
                subtitle:
                    '${widget.order.billingAddress.fullName}, ${widget.order.billingAddress.mobileNumber}',
              ),
              _buildDivider(),

              // Shipping Method
              SnippetOrderDetailInfo(
                label: 'Shipping Method',
                title: widget.order.shippingMethod.name,
              ),
              _buildDivider(),

              // Payment Method
              SnippetOrderDetailInfo(
                label: 'Payment Method',
                title: widget.order.paymentMethod.name,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
      child: Divider(
        thickness: 0.5,
      ),
    );
  }

  Widget _buildBottomBar(OrderDetailViewModel viewModel) {
    final canCancel =
        _cancellableStatusCodes.contains(widget.order.orderStatus.code) &&
            !_cancelled;
    return Row(
      children: [
        Expanded(
          child: FilledButtonWidget(
            label: 'Track Order',
            onPressed: () {
              NavigationHelper.push(
                context,
                TrackOrderScreen(
                  order: widget.order,
                ),
              );
            },
          ),
        ),
        if (canCancel) ...[
          const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
          Expanded(
            child: OutlinedButtonWidget(
              label: 'Cancel Order',
              isLoading: viewModel.cancelOrderUseCase.isLoading,
              onPressed: () => _onCancelOrder(viewModel),
            ),
          ),
        ],
      ],
    );
  }

  void _onCancelOrder(OrderDetailViewModel viewModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialogWidget(
        title: 'Cancel this order?',
        description: 'This cannot be undone.',
        needSecondButton: true,
        firstButtonLabel: 'Cancel Order',
        firstButtonOnPressed: () async {
          Navigator.pop(ctx);
          await viewModel.cancelOrder(widget.order.id);
          if (!mounted) return;
          if (viewModel.cancelOrderUseCase.hasCompleted) {
            setState(() => _cancelled = true);
            showToast(context, message: 'Order cancelled', isSuccess: true);
          } else {
            showToast(
              context,
              message: viewModel.cancelOrderUseCase.exception,
              isSuccess: false,
            );
          }
        },
      ),
    );
  }

  Widget _buildProductsDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRODUCT DETAIL',
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        GestureDetector(
          // Opens the product's detail page read-only, with a back button to
          // return to this order.
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigationHelper.push(
              context,
              ProductDetailScreen(
                productId: widget.order.product.id,
                title: widget.order.product.title,
                readOnly: true,
              ),
            );
          },
          child: SnippetOrderItem(
            quantity: widget.order.quantity,
            productTitle: widget.order.product.title,
            productVariant: widget.order.productVariant,
            // Snapshot price from when the order was placed, so it matches the
            // billing "Order Cost" and isn't affected by later price changes.
            unitPrice: widget.order.price,
            image: extractProductVariantImage(
              widget.order.product.images,
              widget.order.productVariant,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBillingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 0.5,
        ),
        const SizedBox(height: 5),
        _buildOrderDetailItem(
            title: 'Order Cost', amount: widget.order.orderTotal),
        // The actually-charged delivery fee, not the shipping method's flat
        // cost - standard shipping is priced by delivery city (see
        // resolveStandardDeliveryCharge server-side) and split across a store's
        // items, so shippingMethod.cost alone doesn't match what was billed.
        // netTotal = orderTotal + deliveryShare - discountAmount, so the
        // discount has to be added back to isolate just the delivery share.
        _buildOrderDetailItem(
            title: 'Shipping Fee',
            amount: widget.order.netTotal -
                widget.order.orderTotal +
                widget.order.discountAmount),
        _buildOrderDetailItem(
          title: 'Discount',
          isDiscount: true,
          amount: widget.order.discountAmount,
        ),
        const SizedBox(height: 5),
        _buildOrderDetailItem(
          title: 'Total ',
          amount: widget.order.netTotal,
          boldText: true,
        ),
      ],
    );
  }

  Widget _buildOrderDetailItem({
    required String title,
    required int amount,
    bool boldText = false,
    bool isDiscount = false,
  }) {
    final textStyle = textTheme(context).titleSmall!.copyWith(
          fontWeight: boldText ? FontWeight.bold : null,
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSizeExtraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          Text(
            isDiscount
                ? '-Rs. ${formatNepaliCurrency(amount)}'
                : 'Rs. ${formatNepaliCurrency(amount)}',
            style: textStyle,
          )
        ],
      ),
    );
  }
}
