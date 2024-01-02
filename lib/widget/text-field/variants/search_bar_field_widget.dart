import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SearchBarFieldWidget extends StatelessWidget {
  const SearchBarFieldWidget({
    Key? key,
    this.readOnly = false,
    this.enabled = true,
    this.controller,
    this.onTap,
    this.autofocus = false,
    this.onSubmitted,
  }) : super(key: key);

  final bool readOnly;
  final bool enabled;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool autofocus;
  final Function(String?)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayLighter,
        borderRadius: BorderRadius.circular(Dimens.radius_5),
      ),
      height: 35,
      width: double.infinity,
      child: TextField(
        style: TypographyStyles.bodyMedium,
        textInputAction: TextInputAction.search,
        onTap: onTap,
        autofocus: autofocus,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        readOnly: readOnly,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: "Search for products",
          hintStyle: TypographyStyles.bodyMedium,
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 3,
            bottom: 13,
          ),
          prefixIcon: Icon(
            Icons.search_outlined,
            color: enabled ? Colors.grey.shade600 : Colors.grey.shade300,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
