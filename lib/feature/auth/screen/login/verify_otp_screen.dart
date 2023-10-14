import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/dashboard/dashboard.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final OtpFieldController _otpFieldController = OtpFieldController();
  String _otpCode = "";

  @override
  Widget build(BuildContext context) {
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
                    const TopSpaceWidget(height: Dimens.spacing_64),
                    Text('OTP Code',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                    Text(
                      'Enter OTP code',
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    const VerticalSpaceWidget(height: Dimens.spacing_30),
                    OtpTextFieldWidget(
                      controller: _otpFieldController,
                      length: CommonConstants.otpLength,
                      onCompleted: (otpCode) async {
                        await onContinue(viewModel, otpCode);
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
                        await onContinue(viewModel, _otpCode);
                      },
                      isLoading: viewModel.resendOtpUseCase.isLoading ||
                          viewModel.verifyOtpUseCase.isLoading,
                    ),
                    const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: "Didn't receive code? ",
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                        GestureDetector(
                          onTap: () {
                            onResendOtp(viewModel);
                          },
                          child: TextWidget(
                            text: 'Resend code ',
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
                          Countdown(
                            seconds:
                                (viewModel.sendOtpUseCase.data?.cooldown ?? 2) *
                                    1000,
                            build: (BuildContext context, double time) =>
                                Text(time.toInt().toString()),
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
      ),
    );
  }

  onContinue(LoginViewModel viewModel, String otpCode) async {
    await viewModel.verifyOtp(otpCode);
    observeVerifyOtpResponse(viewModel);
  }

  void observeVerifyOtpResponse(LoginViewModel viewModel) {
    if (viewModel.verifyOtpUseCase.hasCompleted) {
      NavigationHelper.pushAndReplaceAll(
        context,
        const HomeScreen(),
      );
    }
  }

  onResendOtp(LoginViewModel viewModel) async {
    await viewModel.resendOtp();
    observeResendOtpResponse(viewModel);
  }

  void observeResendOtpResponse(LoginViewModel viewModel) {
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
