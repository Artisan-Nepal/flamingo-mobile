import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/screen/login/login_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _viewModel = locator<LoginViewModel>();

  final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
              child: Form(
                key: _formKey,
                child: Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const VerticalSpaceWidget(height: Dimens.spacing_64),
                        Text(
                          'Hello!',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const VerticalSpaceWidget(
                          height: Dimens.spacingSizeSmall,
                        ),
                        Text(
                          'Welcome to Flamingo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const VerticalSpaceWidget(height: Dimens.spacing_64),
                        TextFieldWidget(
                          controller: _mobileNumberController,
                          maxLength: 10,
                          textInputType: TextInputType.number,
                          enabled: !viewModel.sendOtpUseCase.isLoading,
                          textInputAction: TextInputAction.done,
                        ),
                        const VerticalSpaceWidget(
                          height: Dimens.spacingSizeOverLarge,
                        ),
                        FilledButtonWidget(
                          label: 'Login',
                          onPressed: () {
                            onLogin(viewModel);
                          },
                          isLoading: viewModel.sendOtpUseCase.isLoading,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onLogin(LoginViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      await viewModel.sendOtp(_mobileNumberController.text);
      observeSendOtpResponse(viewModel);
    }
  }

  void observeSendOtpResponse(LoginViewModel viewModel) {
    if (viewModel.sendOtpUseCase.hasCompleted) {
    } else {
      showToast(
        context,
        viewModel.sendOtpUseCase.exception!,
        isSuccess: false,
      );
    }
  }
}
