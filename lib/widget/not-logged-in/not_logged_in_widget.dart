import 'package:flamingo/feature/auth/screen/login/login_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({
    Key? key,
    required this.title,
    required this.message,
    this.useScaffold = false,
  }) : super(key: key);

  final String title;
  final String message;
  final bool useScaffold;

  @override
  Widget build(BuildContext context) {
    return useScaffold
        ? Scaffold(
            body: Center(
              child: _buildComponent((context)),
            ),
          )
        : _buildComponent(context);
  }

  Widget _buildComponent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpaceWidget(height: Dimens.spacingSizeOverLarge),
        Text(
          title,
          style: TextStyle(
            color: AppColors.primaryMain,
            fontSize: Dimens.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(message),
        const SizedBox(height: 30),
        // Login Button
        OutlinedButtonWidget(
          width: double.infinity,
          label: 'Log in',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(
                  needContinueAsGuest: false,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
