import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _viewModel = locator<LoginViewModel>();

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
                        const TopSpaceWidget(height: Dimens.spacing_64),
                        Text('OTP Code',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const VerticalSpaceWidget(
                            height: Dimens.spacingSizeSmall),
                        Text(
                          'Enter otp code',
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        const VerticalSpaceWidget(height: Dimens.spacing_30),
                        OTPTextField(
                          length: 4,
                          width: double.infinity,
                          fieldWidth: 40,
                          spaceBetween: Dimens.spacingSizeLarge,
                          style:
                              const TextStyle(fontSize: Dimens.fontSizeDefault),
                          textFieldAlignment: MainAxisAlignment.center,
                          fieldStyle: FieldStyle.box,
                          onCompleted: (otp) {},
                        ),
                        const VerticalSpaceWidget(
                          height: Dimens.spacingSizeOverLarge,
                        ),
                        FilledButtonWidget(
                          label: 'Continue',
                          onPressed: () {},
                          isLoading: viewModel.sendOtpUseCase.isLoading,
                        ),
                        const VerticalSpaceWidget(
                            height: Dimens.spacingSizeLarge),
                        RichText(
                          text: TextSpan(
                            text: "Didn't receive code? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Resend code',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
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
}
