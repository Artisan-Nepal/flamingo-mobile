import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class LineDashedPainter extends CustomPainter {
  Color color;

  LineDashedPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 2
      ..color = color;
    var max = 65;
    var dashWidth = 5;
    var dashSpace = 5;
    double startY = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SnippetOrderStatusStepper extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLastItem;
  final bool isSecondLastItem;
  final bool greyOutLast;
  const SnippetOrderStatusStepper({
    Key? key,
    required this.title,
    required this.color,
    this.isLastItem = false,
    this.isSecondLastItem = false,
    this.greyOutLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeSmall),
                child: CircleAvatar(
                    backgroundColor:
                        isLastItem && greyOutLast ? AppColors.grayLight : color,
                    radius: 10.0),
              ),
              isLastItem
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: Dimens.spacingSizeExtraSmall,
                          left: Dimens.spacingSizeLarge),
                      child: CustomPaint(
                        painter: LineDashedPainter(
                            isSecondLastItem && greyOutLast
                                ? AppColors.grayLight
                                : color),
                      ),
                    ),
            ],
          ),
          Flexible(child: Text(title))
        ],
      ),
    );
  }
}
