import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  const PhoneTextFieldWidget({
    super.key,
    this.obscureTextInitially = true,
    this.focusNode,
    this.nextNode,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.onChanged,
    this.validator,
    this.autoFocus = false,
    this.autovalidateMode,
    this.maxLength,
    this.onFieldSubmitted,
    this.onSaved,
    this.onPrefixPressed,
    this.onSuffixPressed,
    this.suffixIcon,
  });

  final bool obscureTextInitially;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function()? onPrefixPressed;
  final void Function()? onSuffixPressed;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      focusNode: focusNode,
      nextNode: nextNode,
      controller: controller,
      hintText: hintText,
      prefixIcon: _getTextPrefix(context),
      onPrefixPressed: onPrefixPressed,
      textInputAction: textInputAction,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      label: label,
      onChanged: onChanged,
      validator: validator,
      autoFocus: autoFocus,
      autovalidateMode: autovalidateMode,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      maxLines: 1,
      suffixIcon: suffixIcon,
      onSuffixPressed: onSuffixPressed,
    );
  }

  Widget _getTextPrefix(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 2, Dimens.spacingSizeSmall, 2),
      decoration: const BoxDecoration(
        color: AppColors.grayLighter,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.radiusLarge),
          bottomLeft: Radius.circular(Dimens.radiusLarge),
        ),
      ),
      padding: const EdgeInsets.only(
          left: Dimens.spacingSizeDefault, right: Dimens.spacingSizeSmall),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SvgImageWidget(
            image: ImageConstants.nepalFlag,
            height: Dimens.iconSizeDefault,
          ),
          const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
          Text(
            '+977',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.grayDarker,
                ),
          )
        ],
      ),
    );
  }
}
