import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cashout_screen/address/editaddress/editaddressscreen_model.dart';

import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAddressScreen extends StatefulWidget {
  final String? name;
  final List<String>? address;
  const EditAddressScreen(
      {Key? key, required this.address, required this.name});

  @override
  State<EditAddressScreen> createState() => EditAddressScreenState();
}

class EditAddressScreenState extends State<EditAddressScreen> {
  final _viewmodel = locator<EditAddressScreenModel>();

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _citycontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _statecontroller = TextEditingController();
  final TextEditingController _postalcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();

  //
  Profile? profile;

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
        appBarTitle: TextWidget(
          widget.address == null && widget.name == null
              ? 'Create Delivery Address'
              : 'Edit Delivery Address',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: FilledButtonWidget(
          label: 'Save and Continue',
          onPressed: () {
            print('Saved and continued');
            Navigator.of(context).pop();
          },
        ),
        child: SafeArea(
          child: Consumer<EditAddressScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.profile.isLoading) {
                return const CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpaceWidget(height: 10),
                    const TextWidget(
                      'Username:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: widget.name ?? 'Enter Username',
                      controller: _namecontroller,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    const TextWidget(
                      'Address:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: widget.address != null
                          ? widget.address.toString()
                          : 'Enter Address',
                      controller: _addresscontroller,
                      textInputType: TextInputType.multiline,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    const TextWidget(
                      'City:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: 'Enter city',
                      controller: _citycontroller,
                      textInputType: TextInputType.multiline,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    const TextWidget(
                      'Postal Code:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: 'Enter Postal code',
                      controller: _postalcontroller,
                      textInputType: TextInputType.number,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    const TextWidget(
                      'State:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: 'Enter State',
                      controller: _statecontroller,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    const TextWidget(
                      'Phone:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: 'Enter phone number',
                      controller: _phonecontroller,
                      textInputType: TextInputType.number,
                    ),
                    const Text(
                      'We will only contact you using phone number if there is a problem.',
                      textAlign: TextAlign.justify,
                    ),
                    const VerticalSpaceWidget(height: 15),
                    widget.address != null && widget.name != null
                        ? ButtonWidget(
                            fontSize: 20,
                            label: 'Delete this address',
                            backgroundColor: AppColors.white,
                            textColor: AppColors.black,
                            borderColor: AppColors.black,
                            needBorder: true,
                            onPressed: () {
                              print('Delete address here.');
                            },
                          )
                        : Container()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
