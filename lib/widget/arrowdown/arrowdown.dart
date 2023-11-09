import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ArrowDown extends StatefulWidget {
  final String title;
  final Widget body;

  ArrowDown({required this.title, required this.body});

  @override
  _ArrowDownState createState() => _ArrowDownState();
}

class _ArrowDownState extends State<ArrowDown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.grayDarker,
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded) widget.body,
      ],
    );
  }
}
