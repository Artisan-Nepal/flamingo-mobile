import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OtpTextFieldWidget extends StatelessWidget {
  const OtpTextFieldWidget(
      {super.key,
      required this.length,
      this.error,
      this.onCompleted,
      this.controller,
      this.onChanged});

  final int length;
  final OtpFieldController? controller;
  final String? error;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OTPTextField(
          controller: controller,
          length: length,
          width: double.infinity,
          fieldWidth: 40,
          spaceBetween: Dimens.spacingSizeLarge,
          hasError: error != null,
          style: const TextStyle(fontSize: Dimens.fontSizeDefault),
          textFieldAlignment: MainAxisAlignment.center,
          fieldStyle: FieldStyle.box,
          onCompleted: onCompleted,
          onChanged: onChanged ?? (value) {},
          otpFieldStyle: OtpFieldStyle(
            errorBorderColor: AppColors.error,
          ),
        ),
        getError(context),
      ],
    );
  }

  Widget getError(BuildContext context) {
    if (error == null) return const SizedBox();
    return Column(
      children: [
        const VerticalSpaceWidget(height: 20),
        TextWidget(
          text: error!,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.error),
        )
      ],
    );
  }
}
