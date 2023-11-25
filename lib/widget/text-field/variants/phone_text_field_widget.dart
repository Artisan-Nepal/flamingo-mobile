import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  const PhoneTextFieldWidget({
    super.key,
    this.focusNode,
    this.controller,
    this.nextNode,
    this.textInputType = TextInputType.phone,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
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
    this.textAlign = TextAlign.start,
    this.initialCountryCode = 'NP',
  });

  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final Function(PhoneNumber)? onChanged;
  final String? Function(PhoneNumber?)? validator;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final void Function(PhoneNumber?)? onSaved;
  final void Function()? onPrefixPressed;
  final void Function()? onSuffixPressed;
  final TextAlign? textAlign;
  final String? initialCountryCode;

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
        IntlPhoneField(
          countries: const [
            Country(
              code: '977',
              name: 'Nepal',
              dialCode: '977',
              flag: '🇳🇵',
              minLength: 10,
              nameTranslations: {
                'en': 'Nepal',
                'ne': 'नेपाल',
              },
              maxLength: 10,
            )
          ],
          style: const TextStyle(
            fontSize: 14,
            textBaseline: TextBaseline.alphabetic,
          ),
          onSaved: (phone) {
            PhoneNumber? phoneNumber;
            if (phone != null) {
              phoneNumber = PhoneNumber(
                countryISOCode: phone.countryISOCode,
                countryCode: phone.countryCode,
                number: phone.number,
                completeNumber: phone.completeNumber,
              );
            }
            if (onSaved != null) {
              onSaved!(phoneNumber);
            }
          },
          textAlign: textAlign ?? TextAlign.start,
          autofocus: autoFocus,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          validator: (phone) {
            PhoneNumber? phoneNumber;
            if (phone != null) {
              phoneNumber = PhoneNumber(
                countryISOCode: phone.countryISOCode,
                countryCode: phone.countryCode,
                number: phone.number,
                completeNumber: phone.completeNumber,
              );
            }

            if (validator != null) {
              return validator!(phoneNumber);
            }

            return null;
          },
          onChanged: (phone) {
            if (onChanged != null) {
              onChanged!(
                PhoneNumber(
                  countryISOCode: phone.countryISOCode,
                  countryCode: phone.countryCode,
                  number: phone.number,
                  completeNumber: phone.completeNumber,
                ),
              );
            }
          },
          onTap: onTap,
          readOnly: readOnly,
          enabled: enabled,
          showDropdownIcon: false,
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (value) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!(value);
            }
            FocusScope.of(context).requestFocus(nextNode);
          },
          invalidNumberMessage: 'Invalid mobile number.',
          initialCountryCode: initialCountryCode,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          flagsButtonMargin: const EdgeInsets.only(
              left: 1, top: 1, bottom: 1, right: Dimens.spacingSizeSmall),
          flagsButtonPadding:
              const EdgeInsets.only(left: Dimens.spacingSizeSmall),
          dropdownDecoration: const BoxDecoration(
            color: AppColors.grayLighter,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.radiusLarge),
              bottomLeft: Radius.circular(Dimens.radiusLarge),
            ),
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
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
            border: generateBorder(
              isLightMode ? AppColors.grayLight : AppColors.grayLighter,
            ),
            focusedBorder: generateBorder(
              themedPrimaryColor(context),
              isFocused: true,
            ),
            enabledBorder: generateBorder(
              isLightMode ? AppColors.grayLight : AppColors.grayLighter,
            ),
            errorBorder: generateBorder(
              AppColors.error,
            ),
            focusedErrorBorder: generateBorder(
              AppColors.error,
              isFocused: true,
            ),
          ),
        ),
      ],
    );
  }
}
