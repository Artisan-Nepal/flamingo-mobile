import 'package:flutter/material.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:provider/provider.dart';
import 'snippet_login_screen_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel viewModel = locator<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (BuildContext context) => viewModel,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Material(
              child: SizedBox(
                child: Column(children: [
                  getProgressIndicator(),
                  addVerticalSpace(56),
                  const Text(
                    'Log in',
                    textAlign: TextAlign.center,
                  ),
                  addVerticalSpace(48),
                  const SnippetLoginScreenForm(),
                ]),
              ),
            ),
          ),
        ));
  }

  Widget getProgressIndicator() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.loginUseCase.isLoading) {
          return const LinearProgressIndicator(
            backgroundColor: AppColors.secondaryDark,
          );
        } else {
          return const SizedBox(
            height: 4,
          );
        }
      },
    );
  }
}
