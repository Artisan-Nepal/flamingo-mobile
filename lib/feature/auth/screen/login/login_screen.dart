import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/screen/login/verify_otp_screen.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.needContinueAsGuest = true,
  });

  final bool needContinueAsGuest;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _viewModel = locator<LoginViewModel>();

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('inside login');
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
                      'Connect with email',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeExtraSmall),
                    Text(
                      'Please enter your email',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeExtraLarge),
                    // PhoneTextFieldWidget(
                    //   controller: _mobileNumberController,
                    //   maxLength: 10,
                    //   enabled: !viewModel.sendOtpUseCase.isLoading,
                    //   textInputAction: TextInputAction.done,
                    //   validator: validatePhoneNumber,
                    // ),
                    TextFieldWidget(
                      hintText: 'Email',
                      controller: _emailController,
                      enabled: !viewModel.sendOtpUseCase.isLoading,
                      textInputAction: TextInputAction.done,
                      validator: validateEmail,
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
                    ),

                    if (widget.needContinueAsGuest) ...[
                      const VerticalSpaceWidget(
                        height: Dimens.spacingSizeSmall,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Or'),
                      ),
                      const VerticalSpaceWidget(
                        height: Dimens.spacingSizeSmall,
                      ),
                      OutlinedButtonWidget(
                        width: double.infinity,
                        label: 'Continue as guest',
                        onPressed: () {
                          _onContinueAsGuest(viewModel);
                        },
                        enabled: !viewModel.sendOtpUseCase.isLoading,
                      ),
                    ]
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onContinueAsGuest(LoginViewModel viewModel) async {
    await viewModel.continueAsGuest();

    NavigationHelper.pushAndReplaceAll(
      context,
      const DashboardScreen(),
    );
  }

  void _onLogin(LoginViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      await viewModel.sendOtp(_emailController.text);
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
            otpReceiver: _emailController.text,
          ),
        ),
      );
    } else {
      showToast(
        context,
        message: viewModel.sendOtpUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
