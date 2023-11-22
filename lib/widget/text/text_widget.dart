import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double scaleForSmallerDevice;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final bool? softWrap;

  const TextWidget(
    this.text, {
    super.key,
    this.style = TypographyStyles.bodyMedium,
    this.scaleForSmallerDevice = 1,
    this.textAlign = TextAlign.start,
    this.textOverflow = TextOverflow.visible,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        fontSize: style.fontSize != null
            ? getScaledValueForSmallerDevice(
                value: style.fontSize!, scale: scaleForSmallerDevice)
            : null,
      ),
      textAlign: textAlign,
      overflow: textOverflow,
      softWrap: softWrap,
    );
  }
}
