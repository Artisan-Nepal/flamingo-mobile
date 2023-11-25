import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/screen/login/login_view_model.dart';
import 'package:flamingo/feature/auth/screen/login/verify_otp_screen.dart';
import 'package:flamingo/feature/feature.dart';
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
        return DefaultScreen(
          child: Form(
            key: _formKey,
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpaceWidget(
                      height: Dimens.spacingSizeSmall,
                    ),
                    Text(
                      'Connect with mobile number',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeExtraSmall),
                    Text(
                      'Please enter your mobile number',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeExtraLarge),
                    PhoneTextFieldWidget(
                      controller: _mobileNumberController,
                      maxLength: 10,
                      enabled: !viewModel.sendOtpUseCase.isLoading,
                      textInputAction: TextInputAction.done,
                      validator: validatePhoneNumber,
                    ),
                    const VerticalSpaceWidget(
                      height: Dimens.spacingSizeOverLarge,
                    ),
                    FilledButtonWidget(
                      width: double.infinity,
                      label: 'Login',
                      onPressed: () {
                        _onLogin(viewModel);
                      },
                      isLoading: viewModel.sendOtpUseCase.isLoading,
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onLogin(LoginViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      await viewModel.sendOtp(_mobileNumberController.text);
      _observeSendOtpResponse(viewModel);
    }
  }

  void _observeSendOtpResponse(LoginViewModel viewModel) {
    if (viewModel.sendOtpUseCase.hasCompleted) {
      NavigationHelper.push(
        context,
        ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, child) => VerifyOtpScreen(
            otpReceiver: _mobileNumberController.text,
          ),
        ),
      );
    } else {
      showToast(
        context,
        viewModel.sendOtpUseCase.exception!,
        isSuccess: false,
      );
    }
  }
}
