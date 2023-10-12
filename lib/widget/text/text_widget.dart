import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final bool isBold;
  final double size;
  final TextStyle style;
  final bool? adaptive;
  final double adaptiveValue;
  final double miniAdaptiveValue;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final bool? softWrap;

  const TextWidget({
    super.key,
    required this.text,
    this.isBold = false,
    this.size = Dimens.fontSizeDefault,
    this.style = TypographyStyles.bodyMedium,
    this.adaptive = false,
    this.adaptiveValue = 1,
    this.textAlign = TextAlign.center,
    this.textOverflow = TextOverflow.visible,
    this.miniAdaptiveValue = 0.5,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isSmallerDevice = SizeConfig.isSmallerDevice;
    bool isMediumDevice = SizeConfig.isMediumDevice;
    return Text(
      text,
      style: style.copyWith(
        fontSize: isMediumDevice && adaptive!
            ? style.fontSize! * adaptiveValue
            : isSmallerDevice && style.fontSize != null && adaptive!
                ? style.fontSize! * miniAdaptiveValue
                : null,
      ),
      textAlign: textAlign,
      overflow: textOverflow,
      softWrap: softWrap,
    );
  }
}
