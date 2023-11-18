import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/address/addressscreen_model.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/address/editaddress/edit_addressscreen.dart';

import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key});

  @override
  State<AddressScreen> createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  final _viewmodel = locator<AddressScreenModel>();
  Profile? profile;
  bool _isselected = false;

  @override
  void initState() {
    super.initState();

    _viewmodel.getuserprofile();
    _viewmodel.getaddress();
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
          'Select Delivery Address',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: FilledButtonWidget(
          label: 'Save and Continue',
          onPressed: () {
            if (_isselected == true) {
              Navigator.of(context).pop();
            } else {
              showToast(context, 'Please select an address');
            }
          },
        ),
        child: SafeArea(
          child: Consumer<AddressScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.profile.isLoading) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Stack(children: [
                    ButtonWidget(
                      fontSize: 20,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditAddressScreen(
                            address: null,
                            name: null,
                          ),
                        ));
                      },
                      label: 'Add New Address',
                      borderColor: AppColors.black,
                      needBorder: true,
                      textColor: AppColors.black,
                      backgroundColor: AppColors.white,
                    ),
                    Positioned(
                        right: 5,
                        bottom: 0,
                        top: 0,
                        child: Icon(
                          Icons.add,
                          size: 40,
                        ))
                  ]),
                  VerticalSpaceWidget(height: 10),
                  buildAddressCard(
                    selected: _isselected,
                    username: viewModel.profile.data!.name,
                    address: viewModel.address.data!,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditAddressScreen(
                          address: viewModel.address.data!,
                          name: viewModel.profile.data!.name,
                        ),
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

  Widget buildAddressCard({
    required String username,
    required List<String> address,
    required VoidCallback onPressed,
    bool? selected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _isselected = !_isselected;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // White selection dot
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: selected == true
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
            HorizontalSpaceWidget(width: 20),

            // Name, Address, and Button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (String addr in address) ...[
                    SizedBox(height: 4),
                    Text(
                      addr,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            // Edit button
            ButtonWidget(
              fontSize: 20,
              textColor: AppColors.black,
              backgroundColor: AppColors.white,
              needBorder: true,
              borderColor: AppColors.black,
              width: MediaQuery.of(context).size.width * 0.22,
              label: 'Edit',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
