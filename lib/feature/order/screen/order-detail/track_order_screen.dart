import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/order_status_view_model.dart';
import 'package:flamingo/feature/order/screen/order-detail/snippet_order_status_stepper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final viewModel = locator<OrderStatusViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.trackOrderStatus(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<OrderStatusViewModel>(
        builder: (context, viewModel, child) {
          return DefaultScreen(
            scrollable: false,
            appBarTitle: Text('Code: ${widget.order.orderCode}'),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Order Status Log',
                    style: TextStyle(
                        fontSize: Dimens.fontSizeLarge,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: !viewModel.trackOrderStatusUseCase.hasCompleted
                      ? DefaultScreenLoaderWidget()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              (viewModel.trackOrderStatusUseCase.data ?? [])
                                  .length,
                          itemBuilder: (context, index) {
                            final orderStatuses =
                                viewModel.trackOrderStatusUseCase.data ?? [];
                            final isLastItem =
                                index == orderStatuses.length - 1;
                            final statusLog = orderStatuses[index];
                            return SnippetOrderStatusStepper(
                              title: statusLog.status.name,
                              subTitle: isLastItem &&
                                      widget.order.orderStatus.code !=
                                          "DELIVERED" &&
                                      widget.order.orderStatus.code !=
                                          "CANCELLED"
                                  ? ""
                                  : formatDate(
                                      statusLog.timestamp,
                                      format:
                                          DateFormatConstant.dateTimeDefault,
                                    ),
                              color: themedPrimaryColor(context),
                              isLastItem: isLastItem,
                              isSecondLastItem:
                                  index == orderStatuses.length - 2,
                              greyOutLast: widget.order.orderStatus.code !=
                                      "DELIVERED" &&
                                  widget.order.orderStatus.code != "CANCELLED",
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
