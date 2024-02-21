import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/user/screen/account-setting/edit_email_screen.dart';
import 'package:flamingo/feature/user/screen/account-setting/edit_mobile_number_screen.dart';
import 'package:flamingo/feature/user/screen/account-setting/edit_name_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      appBarTitle: const Text('Account Settings'),
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              ListTileV1Wdiget(
                title: 'Name',
                value: viewModel.user?.firstName != null ||
                        viewModel.user?.lastName != null
                    ? getFullName(
                        firstName: viewModel.user?.firstName,
                        lastName: viewModel.user?.lastName,
                      )
                    : null,
                onPressed: () {
                  NavigationHelper.push(context, const EditNameScreen());
                },
              ),
              ListTileV1Wdiget(
                title: 'Mobile Number',
                value: viewModel.user?.mobileNumber,
                onPressed: () {
                  NavigationHelper.push(
                      context, const EditMobileNumberScreen());
                },
              ),
              ListTileV1Wdiget(
                title: 'Email',
                value: viewModel.user?.email,
                onPressed: () {
                  NavigationHelper.push(context, const EditEmailScreen());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
