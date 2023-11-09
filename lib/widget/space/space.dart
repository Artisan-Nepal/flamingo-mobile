import 'package:flutter/material.dart';
import 'package:flamingo/shared/util/util.dart';

class VerticalSpaceWidget extends StatelessWidget {
  final double height;
  final double? scaleForSmallDevice;

  const VerticalSpaceWidget({
    Key? key,
    required this.height,
    this.scaleForSmallDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScaledValueForSmallerDevice(
        value: height,
        scale: scaleForSmallDevice,
      ),
    );
  }
}

class VerticalSpaceColoredWidget extends StatelessWidget {
  final double height;
  final double thickness;
  final double? scaleForSmallDevice;
  final Color? color;

  const VerticalSpaceColoredWidget({
    Key? key,
    this.color,
    required this.height,
    required this.thickness,
    this.scaleForSmallDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: getScaledValueForSmallerDevice(
            value: height / 2,
            scale: scaleForSmallDevice,
          ),
        ),
        Container(
          color: color,
          height: getScaledValueForSmallerDevice(
            value: thickness,
            scale: scaleForSmallDevice,
          ),
        ),
        Container(
          height: getScaledValueForSmallerDevice(
            value: height / 2,
            scale: scaleForSmallDevice,
          ),
        ),
      ],
    );
  }
}

class BottomSpaceWidget extends StatelessWidget {
  final double height;
  final double? scaleForSmallDevice;

  const BottomSpaceWidget({
    Key? key,
    required this.height,
    this.scaleForSmallDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getScaledValueForSmallerDevice(
          value: height,
          scale: scaleForSmallDevice,
        ),
      ),
    );
  }
}

class TopSpaceWidget extends StatelessWidget {
  final double height;
  final double? scaleForSmallDevice;

  const TopSpaceWidget({
    Key? key,
    required this.height,
    this.scaleForSmallDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getScaledValueForSmallerDevice(
          value: height,
          scale: scaleForSmallDevice,
        ),
      ),
    );
  }
}

class HorizontalSpaceWidget extends StatelessWidget {
  final double width;
  final double? scaleForSmallDevice;

  const HorizontalSpaceWidget({
    Key? key,
    required this.width,
    this.scaleForSmallDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScaledValueForSmallerDevice(
        value: width,
        scale: scaleForSmallDevice,
      ),
    );
  }
}
