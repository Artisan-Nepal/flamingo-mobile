import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/address/addressscreen.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/cashout_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/payment/payment_screen.dart';

import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashoutScreen extends StatefulWidget {
  final int product_count;
  final String total;

  const CashoutScreen({
    required this.product_count,
    required this.total,
  });

  @override
  State<CashoutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashoutScreen> {
  final _viewmodel = locator<CashoutScreenModel>();
  Profile? profile;

  @override
  void initState() {
    super.initState();
    _viewmodel.getaddress();
    _viewmodel.getuserprofile();

    // Place any initialization logic here if needed
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarTitle: const TextWidget(
          'Cashout',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: SafeArea(
          child: Consumer<CashoutScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.profile.isLoading && viewModel.address.isLoading) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  buildStatusCard(
                      title: 'Delivery Address',
                      description: viewModel.address.data.toString(),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddressScreen(),
                        ));
                      },
                      isSuccess: viewModel.address.data!.isNotEmpty),
                  const VerticalSpaceWidget(height: Dimens.iconSizeExtraSmall),
                  buildStatusCard(
                      title: 'Delivery method',
                      description:
                          '${widget.product_count.toString()} items (Total: ${widget.total})',
                      onPressed: () {},
                      isSuccess: true),
                  const VerticalSpaceWidget(height: Dimens.iconSizeExtraSmall),
                  buildStatusCard(
                    title: 'Payment',
                    description: 'Choose Payment Method',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStatusCard({
    required String title,
    required String description,
    required VoidCallback onPressed,
    bool? isSuccess,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Green tick or red cross icon based on isSuccess
            isSuccess != null
                ? Icon(
                    isSuccess ? Icons.check_circle : Icons.cancel,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 32,
                  )
                : Container(),

            // Title and Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Right pointing arrowhead
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
