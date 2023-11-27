import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      appBarTitle: const Text('Account'),
      child: Column(children: [
        Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return FilledButtonWidget(
              label: 'Logout',
              width: double.infinity,
              isLoading: authViewModel.logoutUseCase.isLoading,
              onPressed: () {
                _onLogout(authViewModel);
              },
            );
          },
        )
      ]),
    );
  }

  Future<void> _onLogout(AuthViewModel viewModel) async {
    await viewModel.logout();
    if (!context.mounted) return;

    if (viewModel.logoutUseCase.hasCompleted) {
      NavigationHelper.pushAndReplaceAll(context, const LoginScreen());
    } else {
      showToast(
        context,
        message: viewModel.logoutUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
