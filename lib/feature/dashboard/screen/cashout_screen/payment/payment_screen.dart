import 'package:flamingo/di/di.dart';

import 'package:flamingo/feature/dashboard/screen/cashout_screen/payment/payment_screen_model.dart';

import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final _viewmodel = locator<PaymentScreenModel>();
  Profile? profile;

  @override
  void initState() {
    super.initState();

    _viewmodel.getuserprofile();
    _viewmodel.setselection('');

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
          'Payment',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: SafeArea(
          child: Consumer<PaymentScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.profile.isLoading) {
                return const CircularProgressIndicator();
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildSelectableButton(
                          text: 'Credit Card',
                          isSelected:
                              viewModel.selected_method.data == 'Credit Card',
                          onPressed: () {
                            viewModel.setselection('Credit Card');
                          },
                        ),
                        const HorizontalSpaceWidget(width: 20),
                        buildSelectableButton(
                          text: 'Esewa',
                          isSelected: viewModel.selected_method.data == 'Esewa',
                          onPressed: () {
                            viewModel.setselection('Esewa');
                          },
                        ),
                        const HorizontalSpaceWidget(width: 20),
                        buildSelectableButton(
                          text: 'Cash on Delivery',
                          isSelected: viewModel.selected_method.data ==
                              'Cash on Delivery',
                          onPressed: () {
                            viewModel.setselection('Cash on Delivery');
                          },
                        ),
                      ],
                    ),
                    const VerticalSpaceWidget(height: 10),
                    // Additional widgets based on the selected option
                    if (viewModel.selected_method.data == 'Credit Card')
                      buildCreditCardWidgets()
                    else if (viewModel.selected_method.data == 'Esewa')
                      buildEsewaWidgets()
                    else if (viewModel.selected_method.data ==
                        'Cash on Delivery')
                      buildCashOnDeliveryWidgets(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSelectableButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppColors.black, width: 2)
              : Border.all(color: AppColors.grayLight, width: 1),
        ),
        child: TextWidget(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildCreditCardWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add 'Scan Your Card' button with camera icon
        buildStatusCard(
          title: 'Scan Your Card',
          description: 'Tap to scan your credit card',
          onPressed: () {
            // Implement your logic for scanning the card
          },
          isSuccess: null,
        ),
        // Additional widgets for credit card option
        Center(
          child: ButtonWidget(
            fontSize: 20,
            width: MediaQuery.of(context).size.width * 0.8,
            height: Dimens.spacing_50,
            label: 'Save and Continue',
            onPressed: () {
              print('Saved and continued');
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget buildEsewaWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add 'Esewa' button
        buildStatusCard(
          title: 'Esewa',
          description: 'Tap to use Esewa for payment',
          onPressed: () {
            // Implement your logic for Esewa payment
          },
          isSuccess: null,
        ),
        // Additional widgets for Esewa option
        Center(
          child: ButtonWidget(
            fontSize: 20,
            height: Dimens.spacing_50,
            width: MediaQuery.of(context).size.width * 0.8,
            label: 'Save and Continue',
            onPressed: () {
              print('Saved and continued');
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget buildCashOnDeliveryWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display 'Cash on Delivery' text
        buildStatusCard(
          title: 'Cash on Delivery',
          description: 'Payment will be made upon delivery',
          onPressed: () {
            // Implement your logic for Cash on Delivery
          },
          isSuccess: null,
        ),
        // Additional widgets for Cash on Delivery option
        Center(
          child: ButtonWidget(
            fontSize: 20,
            height: Dimens.spacing_50,
            width: MediaQuery.of(context).size.width * 0.8,
            label: 'Save and Continue',
            onPressed: () {
              print('Saved and continued');
              Navigator.of(context).pop();
            },
          ),
        )
      ],
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
