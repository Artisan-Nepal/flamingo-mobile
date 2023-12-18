import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropDownFieldWidget<T> extends StatelessWidget {
  const DropDownFieldWidget({
    Key? key,
    this.prefixIcon,
    this.hintText = '',
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.label,
    this.onChanged,
    required this.items,
    this.showSearchBox = false,
    this.selectedItem,
    this.itemAsString,
    this.compareFn,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final IconData? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final List<T> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final bool showSearchBox;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.01,
          ),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: DropdownSearch<T>(
            autoValidateMode: AutovalidateMode.onUserInteraction,
            popupProps: PopupProps.menu(
              showSearchBox: showSearchBox,
              showSelectedItems: true,
              itemBuilder: (context, item, isSelected) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
                  child: (itemAsString == null && (item is! String))
                      ? const SizedBox()
                      : (item is String)
                          ? Text(
                              item,
                              style: textTheme(context).bodyMedium!,
                            )
                          : TextWidget(
                              itemAsString!(
                                item,
                              ),
                              style: textTheme(context).bodyMedium!,
                            ),
                );
              },
            ),
            enabled: enabled,
            itemAsString: itemAsString,
            items: items,
            compareFn: compareFn,
            validator: validator,
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(
                fontSize: Dimens.fontSizeDefault,
                textBaseline: TextBaseline.alphabetic,
              ),
              dropdownSearchDecoration: InputDecoration(
                hintText: hintText,
                contentPadding: prefixIcon != null
                    ? const EdgeInsets.symmetric(vertical: 5)
                    : const EdgeInsets.all(
                        10,
                      ),
                prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
                border: generateBorder(
                  isLightMode(context)
                      ? AppColors.grayLight
                      : AppColors.grayLighter,
                ),
                focusedBorder: generateBorder(
                  AppColors.primaryMain,
                  isFocused: true,
                ),
                enabledBorder: generateBorder(
                  isLightMode(context)
                      ? AppColors.grayLight
                      : AppColors.grayLighter,
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
            onChanged: onChanged,
            selectedItem: selectedItem,
          ),
        ),
      ],
    );
  }
}
