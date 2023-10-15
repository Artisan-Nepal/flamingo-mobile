import 'package:flamingo/feature/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      this.focusNode,
      this.controller,
      this.nextNode,
      this.textInputType,
      this.prefixIcon,
      this.suffixIcon,
      this.textInputAction,
      this.hintText,
      this.enabled = true,
      this.onTap,
      this.readOnly = false,
      this.label,
      this.onChanged,
      this.validator,
      this.autoFocus = false,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.maxLines,
      this.maxLength,
      this.obscureText = false,
      this.textCapitalization = TextCapitalization.none,
      this.onFieldSubmitted,
      this.onSaved,
      this.onPrefixPressed,
      this.onSuffixPressed,
      this.textAlign = TextAlign.start})
      : super(key: key);

  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function()? onPrefixPressed;
  final void Function()? onSuffixPressed;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeService>(context).isLightMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          Text(
            label!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          addVerticalSpace(SizeConfig.screenHeight * 0.01)
        ],
        TextFormField(
          style: const TextStyle(
            fontSize: 14,
            textBaseline: TextBaseline.alphabetic,
          ),
          onSaved: onSaved,
          textAlign: textAlign ?? TextAlign.start,
          textCapitalization: textCapitalization,
          autofocus: autoFocus,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!(value);
            }
            FocusScope.of(context).requestFocus(nextNode);
          },
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: prefixIcon != null
                ? const EdgeInsets.symmetric(
                    vertical: 4,
                  )
                : const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: Dimens.spacingSizeLarge,
                  ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixPressed,
                  ),
            errorStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.error),
            hintText: hintText,
            border: _generateBorder(
              isLightMode ? AppColors.grayLight : AppColors.grayLighter,
            ),
            focusedBorder: _generateBorder(
              AppColors.primaryMain,
              isFocused: true,
            ),
            enabledBorder: _generateBorder(
              isLightMode ? AppColors.grayLight : AppColors.grayLighter,
            ),
            errorBorder: _generateBorder(
              AppColors.error,
            ),
            focusedErrorBorder: _generateBorder(
              AppColors.error,
              isFocused: true,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _generateBorder(Color borderColor,
      {bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
      borderSide: BorderSide(width: isFocused ? 1.3 : 1.2, color: borderColor),
    );
  }
}
