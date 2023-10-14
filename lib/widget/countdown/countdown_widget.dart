import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({
    super.key,
    required this.minutes,
    this.onFinished,
    this.textStyle,
  });

  final double minutes;
  final Function? onFinished;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: (minutes * 60).toInt(),
      build: (BuildContext context, double time) => Text(
        formatSeconds(time.toInt()),
        style: textStyle,
      ),
      onFinished: onFinished,
    );
  }
}
