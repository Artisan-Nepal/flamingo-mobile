import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/dashboard/dashboard.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.otpReceiver});

  final String otpReceiver;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final OtpFieldController _otpFieldController = OtpFieldController();
  String _otpCode = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DefaultScreen(
        child: Form(
          key: _formKey,
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter the OTP code',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraSmall),
                  Text(
                    'Please enter the ${CommonConstants.otpLength}-digit code sent to ${widget.otpReceiver}.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraLarge),
                  OtpTextFieldWidget(
                    controller: _otpFieldController,
                    length: CommonConstants.otpLength,
                    onCompleted: (otpCode) async {
                      await _onContinue(viewModel, otpCode);
                    },
                    onChanged: (otpCode) => _otpCode = otpCode,
                    error: viewModel.verifyOtpUseCase.exception,
                  ),
                  const VerticalSpaceWidget(
                    height: Dimens.spacingSizeOverLarge,
                  ),
                  FilledButtonWidget(
                    label: 'Continue',
                    onPressed: () async {
                      await _onContinue(viewModel, _otpCode);
                    },
                    isLoading: viewModel.resendOtpUseCase.isLoading ||
                        viewModel.verifyOtpUseCase.isLoading,
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        "Didn't receive code? ",
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (viewModel.canResendCode) {
                            _onResendOtp(viewModel);
                          }
                        },
                        child: TextWidget(
                          'Resend code ',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: viewModel.canResendCode
                                      ? null
                                      : AppColors.grayLight),
                        ),
                      ),
                      if (!viewModel.canResendCode)
                        CountdownWidget(
                          minutes:
                              (viewModel.sendOtpUseCase.data?.cooldown ?? 2),
                          onFinished: () {
                            viewModel.allowResendCode();
                          },
                        )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _onContinue(LoginViewModel viewModel, String otpCode) async {
    await viewModel.verifyOtp(otpCode);
    _observeVerifyOtpResponse(viewModel);
  }

  void _observeVerifyOtpResponse(LoginViewModel viewModel) {
    if (viewModel.verifyOtpUseCase.hasCompleted) {
      NavigationHelper.pushAndReplaceAll(
        context,
        const HomeScreen(),
      );
    }
  }

  _onResendOtp(LoginViewModel viewModel) async {
    await viewModel.resendOtp();
    _observeResendOtpResponse(viewModel);
  }

  void _observeResendOtpResponse(LoginViewModel viewModel) {
    if (viewModel.resendOtpUseCase.hasCompleted) {
      showToast(
        context,
        "OTP code sent successfully.",
      );
    } else {
      showToast(
        context,
        viewModel.resendOtpUseCase.exception!,
        isSuccess: false,
      );
    }
  }
}
