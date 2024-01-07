import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/snippet_order_status_stepper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final orderStatuses = widget.order.orderStatus.code == "CANCELLED"
        ? orderStatusLookup
            .where((status) => status.code == "CANCELLED")
            .toList()
        : orderStatusLookup
            .getRange(
                0,
                widget.order.orderStatus.code == "DELIVERED"
                    ? widget.order.orderStatus.sequenceNumber + 1
                    : widget.order.orderStatus.sequenceNumber + 2)
            .toList();
    return DefaultScreen(
      scrollable: false,
      appBarTitle: Text('Code: ${widget.order.orderId}'),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Order Status Log',
              style: TextStyle(
                  fontSize: Dimens.fontSizeLarge, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderStatuses.length,
              itemBuilder: (context, index) => SnippetOrderStatusStepper(
                title: orderStatuses[index].description,
                color: themedPrimaryColor(context),
                isLastItem: index == orderStatuses.length - 1,
                isSecondLastItem: index == orderStatuses.length - 2,
                greyOutLast: widget.order.orderStatus.code != "DELIVERED",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
